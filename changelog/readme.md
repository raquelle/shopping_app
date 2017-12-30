## Project

rails new shopping_app -d postgresql
cd shopping_app
git init
mkdir changelog
touch changelog/readme.md
git add .gitignore
git add *

## Make Database
```bash
bundle exec rake db:create
```
If database already exists then need to drop it before creating new.

```bash
rake db:drop
```
This did not change my source code but it did change the postgres database.
This will be an almost empty commit, just the readme files will be updated.

# To Do

## Models

now I will make my models

```bash
bundle exec rails g model item name:string price:integer sku:string

bundle exec rails g model store name:string

bundle exec rails g model list name:string
```

## Migrate

run migration

```bash
bundle exec rake db:migrate
```