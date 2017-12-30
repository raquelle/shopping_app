## Project

``bash 
rails new shopping_app -d postgresql
cd shopping_app
```

We want to track our work in git so set up the repository
```bash
git init
mkdir changelog
touch changelog/readme.md
git add .gitignore
git add *
```

We want to have a backup so we can share with the instructor.
After creating the project on github 
https://github.com/raquelle/shopping_app
```bash
git remote add origin git@github.com:raquelle/shopping_app.git
git push -u origin master
```
From here on the pattern is to 
1. update this changelog 
2. add changes to the stage
3. commit the stage to the local repository [put the change text in the mesage]
4. push the local repository to github


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

## Define Models

now I will make my models

```bash
bundle exec rails g model item name:string price:integer sku:string
bundle exec rails g model store name:string
bundle exec rails g model list name:string
```

If you cannot generate models because you have already created them then you will need to destroy the models
```bash
bundle exec rails d model item
bundle exec rails d model list
bundle exec rails d model store
```

## Migrate

run migration

```bash
bundle exec rake db:migrate
```
# To Do

## Create a Store 

Give Store a Name

## Create a List

## Create some Items

## Check Deletion Properties

Make sure if a parent model is destroyed its children are destroyed as well

## Add validations to the model

## Create Model Methods

Create at least two model methods (1 instance method and 1 class method) 

