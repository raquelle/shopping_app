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

## Add Data to Database

1. Store [1]
2. List [1]
3. Item [3]
4. check deletion 

### Create a Store 

Give Store a Name
Many commands will need to be run will enter the rails console to complete.
Enter rails console
```bash
    bundle exec rails c
```

```rails
Store.create(name: 'Costco')
```
if it works then this should display in your console
```rails
irb(main):001:0> Store.create(name: 'Costco')
   (0.2ms)  BEGIN
  SQL (2.9ms)  INSERT INTO "stores" ("name", "created_at", "updated_at") VALUES ($1, $2, $3) RETURNING "id"  [["name", "Costco"], ["created_at", "2017-12-30 18:01:05.429408"], ["updated_at", "2017-12-30 18:01:05.429408"]]
   (8.2ms)  COMMIT
=> #<Store id: 1, name: "Costco", created_at: "2017-12-30 18:01:05", updated_at: "2017-12-30 18:01:05">
irb(main):002:0>
```
This action did not generate any code in the repository but updated the database.
That being said, a commit to git is not needed.

tried to create list but could not need to add relationships

##Add Relationships between List, Store, and Items

```app/models/list
belongs_to :store
has_many :items
```

```app/models/item
belongs_to :list
```

```app/models/store
has_many :lists
```
try to create a new migration to update the database to connect so we can update

```bash
    bundle exec rake db:migrate
```



### Create a List
 Give a List a Name 
 Since many rails commands will be run we will enter the rails console to complete.

Enter rails console
```bash
    bundle exec rails c
```
make store name
```rails
List.create(name: 'Groceries', store_id: 1)
```
sadly this still didn't seem to work
this was the comment returned to me by the command line

irb(main):002:0> List.create(name: 'Groceries', store_id: 1)
ActiveModel::UnknownAttributeError: unknown attribute 'store_id' for List.
	from (irb):2
irb(main):003:0>

So that didn't work

### Create some Items

### Check Deletion Properties

Make sure if a parent model is destroyed its children are destroyed as well

# To Do

## Add validations to the model

## Create Model Methods

Create at least two model methods (1 instance method and 1 class method) 

We will aggregate prices of items as sums.

### Instance Method
Given an instance of a list sum all the prices for the items in that list.

### Class Method
Given no instance sum all the prices for all items.
Note: Item is a class not an instance.