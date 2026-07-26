## Как запускать

- Запуск вручную *"terraform-workflow-task2"* из github actions (см. .github/workflows/terraform-workflow-task2.yml)
- Работает только в ветках main и projectwork.
- 2 Jobs: plan и apply.
- plan создает tfplan в артефакты
- apply потребует подтверждения и пользуется tfplan из артефактов
- после apply сразу исполнится destroy
- main.tf использует backend Yandex Object Storage.
- Переменные окружения и секреты настроены в GitHub. YC_TOKEN получаем через OIDC.
- OIDC способ не очень удобен из-за ошибки в github c ::add-mask:: которая не работает между jobs, только внутри - это все усложяет очень сильно или снижает безопасность. Я не стал бороться до конца . В реальном проде придется использовать долговременный токен в секрете или файл с ключом (ну или кто-то подскажет что-то иное)
https://github.com/orgs/community/discussions/29880?ysclid=ms14r4j6eg606086153


## Как настраивал (больше для меня, чем для ревьюера)

1. Настроил бекенд terraform:
https://developer.hashicorp.com/terraform/language/backend

2. Использовал Yandex Object Storage bucket
https://yandex.cloud/ru/docs/storage/concepts/bucket

Бакет: tf-state-bucket
Доступ через service account: 

```sh
yc storage bucket create --name tf-state-bucket
yc iam access-key create --service-account-name "<имя sa>"
```


3. Доступ к backend из terraform

Должны быть установлены такие переменные - настроил в GitHub secrets

```sh
export AWS_ACCESS_KEY_ID=<key_id>
export AWS_SECRET_ACCESS_KEY=<secret>
```

4. Настроил связку github - Yandex через федерацию каталогов.

Access token получим в GitHub через OIDC. Работает для _main_ и _work_ бранчей.

https://yandex.cloud/ru/docs/iam/operations/authentication/manage-access-keys#cli_1


4. Для удаления (post-review):

```sh
yc iam access-key list --service-account-name "имя сервисного аккаунта"
yc iam access-key delete "идентификатор_ключа"
```