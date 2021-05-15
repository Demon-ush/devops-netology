Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

1.	Установить средство виртуализации Oracle VirtualBox.

  Нет технической возможности. В наличии 2 железка с Ubuntu 20.04.

2.	Установите средство автоматизации Hashicorp Vagrant.

  Аналогично п. 1 и бессмысленно вследствие п.1.
    Примечание: если для дальнейшего прохождения курса обязательна комбинация VirtualBox-Vagrant, прошу обозначить.

3.	В основном окружении подготовить удобный для дальнейшей работы терминал.

  o	Родной и любимый Putty

4.	С помощью базового файла конфигурации запустить Ubuntu 20.04 в VirtualBox посредством Vagrant:

  Нет в соответствии с указанным в п. 1-2. 

5.	Ознакомиться с графическим интерфейсом VirtualBox, 
  
  знакомы

посмотреть как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
Нет в соответствии с указанным в п. 1-2

6.	Ознакомиться с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

  Согласно документации по Vagrant:
      config.vm.provider "virtualbox" do |v|
          v.memory = 1024
          v.cpus = 2
      end
  в самом VirtualBox - из графического интерфейса

7.	Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.

  Обязательно из vagrant? Или putty тоже подходит?

8.	Ознакомиться с разделами man bash, почитать о настройках самого bash:
  o	какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
    .bash_history
    export HISTSIZE=<число>
    export HISTFILESIZE=<число>

  o	что делает директива ignoreboth в bash?
    является сокращением ignorespace + ignoredups
      ignorespace – не сохранять строки, начинающиеся с пробела
      ignoredups  – не писать повторы предыдущей команды

9.	В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
  Reserved Words
  Reserved words are words that have a special meaning to the shell. The following words are recognized as reserved when unquoted and either the first word of a simple command (see SHELL GRAMMAR below) or the third word of a case or for command: 
  ! case do done elif else esac fi for function if in select then until while { } time [[ ]] 
  Compound Commands 
  A compound command is one of the following: 
  (list) 
  list is executed in a subshell environment (see COMMAND EXECUTION ENVIRONMENT below). Variable assignments and builtin commands that affect the shell's environment do not remain in effect after the command completes. The return status is the exit status of list. 
  { list; } 
  list is simply executed in the current shell environment. list must be terminated with a newline or semicolon. This is known as a group command. The return status is the exit status of list. Note that unlike the metacharacters ( and ), { and } are reserved words and must occur where a reserved word is permitted to be recognized. Since they do not cause a word break, they must be separated from list by whitespace or another shell metacharacter. 

10.	Создать однократным вызовом touch 100 000 файлов. А получится ли создать 300 000?

  touch filename-{1..100000}
  bash: /usr/bin/touch: Argument list too long
  touch filename-{1..99999} - лимит

11.	В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]

  Проверка наличия каталога.
    вернет 0 если /tmp не каталог или его нет
    1 если есть и это каталог
 
  Conditional Expressions
  Conditional expressions are used by the [[ compound command and the test and [ builtin commands to test file attributes and perform string and arithmetic comparisons. Expressions are formed from the following unary or binary primaries. If any file argument to one of the primaries is of the form /dev/fd/n, then file descriptor n is checked. If the file argument to one of the primaries is one of /dev/stdin, /dev/stdout, or /dev/stderr, file descriptor 0, 1, or 2, respectively, is checked. 
  Unless otherwise specified, primaries that operate on files follow symbolic links and operate on the target of the link, rather than the link itself. 
  When used with [[, The < and > operators sort lexicographically using the current locale. 
  -a file 
  True if file exists. 
  -b file 
    True if file exists and is a block special file. 
  -c file 
    True if file exists and is a character special file. 
  -d file 
    True if file exists and is a directory. 

12.	Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
(прочие строки могут отличаться содержимым и порядком)

    PATH=”/tmp/new_path_directory: /usr/local/bin: /bin:/usr/bin: …”


13.	Чем отличается планирование команд с помощью batch и at?
    at     —  для назначения разового задания в заданное время
    batch — для назначения разовых задач, выполняющихся при загрузке системы менее 0,8

14.	Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
  
  нечего останавливать...
  
  
