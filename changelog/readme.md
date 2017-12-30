## Project

rails new shopping_app -d postgresql
cd shopping_app
git init
mkdir changelog
touch changelog/readme.md
git add .gitignore
git add *

# To Do

## Make Database
bundle exec rake db:create


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