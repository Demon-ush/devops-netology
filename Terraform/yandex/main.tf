terraform {
  required_version = "= 1.1.7"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "= 0.73"
    }
  }
}
provider "yandex" {
  token     = "<OAuth>"
  cloud_id  = "<идентификатор облака>"
  folder_id = "<идентификатор каталога>"
  zone      = "<зона доступности по умолчанию>"
}
