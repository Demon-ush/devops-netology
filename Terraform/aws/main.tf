provider "aws" {
  access_key = "var.access_key"
  secret_key = "var.secret_key"
  region     = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
    }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}


resource "aws_vpc" "vpc" {
  # Задаём IP-адрес сети VPC в нотации CIDR (IP/Prefix)
  cidr_block         = "172.16.8.0/24"
  # Активируем поддержку разрешения доменных имён с помощью DNS-серверов
  enable_dns_support = true

  # Присваиваем создаваемому ресурсу тег Name
  tags = {
    Name = "My project"
  }
}

resource "aws_subnet" "subnet" {
  # Задаём зону доступности, в которой будет создана подсеть
  # Её значение берём из переменной az
  availability_zone = var.az
  # Используем для подсети тот же CIDR-блок IP-адресов, что и для VPC
  cidr_block        = aws_vpc.vpc.cidr_block
  # Указываем VPC, где будет создана подсеть
  vpc_id            = aws_vpc.vpc.id
  # Подсеть создаём только после создания VPC
  depends_on        = [aws_vpc.vpc]

  # В тег Name для подсети включаем значение переменной az и тег Name для VPC
  tags = {
    Name = "Subnet in ${var.az} for ${lookup(aws_vpc.vpc.tags, "Name")}"
  }
}

# Создаём бакет в объектном хранилище для хранения данных сайта и резервных копий:

resource "aws_s3_bucket" "bucket" {
  provider = aws.noregion
  # Задаём имя хранилища из переменной bucket_name
  bucket = var.bucket_name
  # Указываем разрешения на доступ
  acl    = "private"
}

# Выделяем Elastic IP для доступа к серверу с веб-приложением извне:

resource "aws_eip" "eips" {
  # Указываем количество выделяемых EIP в переменной eips_count –
  # это позволяет сразу выделить необходимое количество EIP.
  # В нашем случае адрес выделяется только первому серверу
  count = var.eips_count
  # Выделяем в рамках нашего VPC
  vpc = true
  # и только после его создания
  depends_on = [aws_vpc.vpc]

  # В качестве значения тега Name берём имя хоста будущей ВМ из переменной hostnames
  # по индексу из массива
  tags = {
    Name = "${var.hostnames[count.index]}"
  }
}

# создаём две группы безопасности – одна открывает доступ со всех адресов через порты 22, 80 и 443, а вторая разрешает полный доступ внутри себя самой. В первую позже добавим ВМ с веб-приложением, а во вторую поместим оба наших сервера, чтобы они могли взаимодействовать между собой:

# Создаём группу безопасности для доступа извне
resource "aws_security_group" "ext" {
  # В рамках нашего VPC
  vpc_id = aws_vpc.vpc.id
  # задаём имя группы безопасности
  name = "ext"
  # и её описание
  description = "External SG"

  # Определяем входящие правила
  dynamic "ingress" {
    # Задаём имя переменной, которая будет использоваться
    # для перебора всех заданных портов
    iterator = port
    # Перебираем порты из списка портов allow_tcp_ports
    for_each = var.allow_tcp_ports
    content {
      # Задаём диапазон портов (в нашем случае он состоит из одного порта),
      from_port = port.value
      to_port   = port.value
      # протокол,
      protocol = "tcp"
      # и IP-адрес источника в нотации CIDR (IP/Prefix)
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Определяем исходящее правило – разрешаем весь исходящий IPv4-трафик
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.vpc]

  tags = {
    Name = "External SG"
  }
}

# Создаём внутреннюю группу безопасности,
# внутри которой будет разрешён весь трафик между её членами
resource "aws_security_group" "int" {
  vpc_id      = aws_vpc.vpc.id
  name        = "int"
  description = "Internal SG"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.vpc]

  tags = {
    Name = "Internal SG"
  }
}

Теперь блок кода для создания виртуальных машин:

resource "aws_instance" "vms" {
  # Количество создаваемых виртуальных машин берём из переменной vms_count
  count = var.vms_count
  # ID образа для создания экземпляра ВМ – из переменной vm_template
  ami = var.vm_template
  # Наименование типа экземпляра создаваемой ВМ – из переменной vm_instance_type
  instance_type = var.vm_instance_type
  # Назначаем экземпляру внутренний IP-адрес из созданной ранее подсети в VPC
  subnet_id = aws_subnet.subnet.id
  # Подключаем к создаваемому экзепляру внутреннюю группу безопасности
  vpc_security_group_ids = [aws_security_group.int.id]
  # Не выделяем и не присваиваем экземпляру внешний Elastic IP
  associate_public_ip_address = false
  # Активируем мониторинг экземпляра
  monitoring = true

  # Экземпляр создаём только после того как созданы:
  # – подсеть
  # – внутренняя группа безопасности
  # – публичный SSH-ключ
  depends_on = [
    aws_subnet.subnet,
    aws_security_group.int,
    aws_key_pair.pubkey,
  ]

  tags = {
    Name = "VM for ${var.hostnames[count.index]}"
  }

  # Создаём диск, подключаемый к экземпляру
  ebs_block_device {
    # Говорим удалять диск вместе с экземпляром
    delete_on_termination = true
    # Задаём имя устройства вида "disk<N>",
    device_name = "disk1"
    # его тип
    volume_type = var.vm_volume_type
    # и размер
    volume_size = var.vm_volume_size

    tags = {
      Name = "Disk for ${var.hostnames[count.index]}"
    }
  }
}

# подключаем внешнюю группу безопасности:

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  # Получаем ID внешней группы безопасности
  security_group_id    = aws_security_group.ext.id
  # и ID сетевого интерфейса первого экземпляра
  network_interface_id = aws_instance.vms[0].primary_network_interface_id
  # Назначаем группу безопасности только после того, как созданы
  # соответствующие экземпляр и группа безопасности
  depends_on = [
    aws_instance.vms,
    aws_security_group.ext,
  ]
}

# и внешний Elastic IP:

resource "aws_eip_association" "eips_association" {
  # Получаем количество созданных EIP
  count         = var.eips_count
  # и по очереди назначаем каждый из них экземплярам
  instance_id   = element(aws_instance.vms.*.id, count.index)
  allocation_id = element(aws_eip.eips.*.id, count.index)
}

output "ip_of_webapp" {
  description = "IP of webapp"
  # Берём значение публичного IP-адреса экземпляра
  # и выводим его по завершении работы Terraform
  value       = aws_eip.eips[0].public_ip
}

