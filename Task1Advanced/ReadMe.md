1. Установл terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli?in=terraform%2Faws-get-started

2. Установил Yandex CLI
https://yandex.cloud/ru/docs/cli/operations/install-cli

3. Настроил отдельный yandex каталог и сервисный аккаунт с admin правами.

4. Настроил окружение для доступа к Yandex Catalog

```sh
export YC_TOKEN=$(yc iam create-token --impersonate-service-account-id <service_account_id>)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

5. Сконфигурировал terraform для работы с Yandex.

https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart

- Создал файл *~/.terraformrc* , хотя, вроде, он не обязателен:

```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

6. Разработал конфигурацию согласно заданию.


7. Как запускать

 - Модуль ожидает следующие параметры:

| Параметр | Тип | Описание |
|----------|-----|----------|
| environment | string | Окружение: dev, stage, prod |
| num_cores | number | Количество ядер CPU (2-16) |
| memory_size | number | Объем RAM в ГБ (2-8) |
| disk_size | number | Объем диска в ГБ (5-128) |
| subnet_id | string | Одно из "subnet_dev", "subnet_stage", subnet_prod" |
| ssh_key_path | string | Путь к файлу ключа | 


 - Запускать с параметром -var-file из корня (Task1Advanced).

 - В папках ./envs/dev, ./envs/stage, ./envs/prod необходимо поместить файл с публичным SSH ключом и соответствующим именем файла: dev_key.pub, stage_key.pub или prod_key.pub.

- Модуль всегда создает 3 подсети

> Запуск с разными -var-file приведет к преобразованиям из одного энвайронмента в другой.
> Создать несколько VMs из корневой папки не получится.

8. Проверил подключение:

```sh
ssh -i <путь к private key file> ubuntu@$(terraform output -raw external_ip_address_vm)
```

Для dev выглядело примерно так:
external_ip_address_vm = "158.160.176.156"
internal_ip_address_vm = "192.168.10.28"
my_image_id = "fd8jcu0hns086qm7ldj7"
vm_subnet_id = "fl8m4mt8d100cd8p2u59"
vm_tag = "dev-vm"

9. Все удалил

```sh
terraform destroy
```