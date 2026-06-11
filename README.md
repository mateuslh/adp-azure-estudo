# adp-azure-estudo — Infraestrutura PostgreSQL

Terraform que provisiona um banco de dados **PostgreSQL Flexible Server** na Azure, usado como backend dos projetos de estudo.

## Recursos criados

| Recurso | Detalhes |
|---|---|
| PostgreSQL Flexible Server | SKU `B_Standard_B1ms` — 1 vCore, 2 GB RAM |
| Banco de dados | `adp_test` — UTF8 |
| Firewall rule | Libera serviços Azure (`0.0.0.0`) |

Todos os recursos ficam dentro do Resource Group `rg-azure-estudo` (pré-existente, não gerenciado por este Terraform).

O estado do Terraform é armazenado no Azure Blob Storage (`stterraformadpstate / tfstate / adp-postgres.tfstate`).

## Pipeline

```
push main → terraform plan → terraform apply
PR         → terraform plan → comentário no PR
manual     → escolhe: plan | apply | destroy
```

## Primeiros passos

**1. Bootstrap** (apenas na primeira vez — cria o storage account do state):
```sh
bash terraform/bootstrap.sh
```

**2. Variáveis locais:**
```sh
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# preencha subscription_id e db_admin_password
```

**3. Subir:**
```sh
cd terraform
terraform init
terraform apply
```

## Secrets necessários no GitHub

| Secret | Descrição |
|---|---|
| `AZURE_CLIENT_ID` | Service principal client ID |
| `AZURE_CLIENT_SECRET` | Service principal secret |
| `AZURE_SUBSCRIPTION_ID` | ID da subscription |
| `AZURE_TENANT_ID` | ID do tenant |
| `DB_ADMIN_PASSWORD` | Senha do admin do PostgreSQL |

## Projetos relacionados

- [faa-azure-estudo](https://github.com/mateuslh/faa-azure-estudo) — API que consome este banco
- [swa-azure-estudo](https://github.com/mateuslh/swa-azure-estudo) — Frontend estático
