## Project

```bash 
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

now I will make my models make models that are dependent after parent model

I will need to make all belongs_to associations when making the model. This will allow our database to have the columns it needs

```bash

bundle exec rails generate model store name:string
bundle exec rails generate model list name:string store:belongs_to
bundle exec rails generate model item name:string price:integer sku:string list:belongs_to
```

If you cannot generate models because you have already created them then you will need to destroy the models
```bash
bundle exec rails destroy model item
bundle exec rails destroy model list
bundle exec rails destroy model store
```

## Migrate

run migration

```bash
bundle exec rake db:migrate
```

## Add Other Associations
Add other associations directly into model
store:has_many lists
list:has_many items

## Add Data to Database

1. Store [1]
2. List [1]
3. Item [3]
4. check deletion 

### Add Store to Database
Enter rails console
```bash
    bundle exec rails c
```
Store.create(name:'Costco')

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

### List to Database
Enter rails console
```bash
    bundle exec rails c
```
Make List name
```rails
List.create(name:'Groceries', store_id:1)
```
If it worked this should appear in the console
```rails
irb(main):002:0> List.create(name:'Groceries', store_id:1)
   (0.2ms)  BEGIN
  Store Load (0.4ms)  SELECT  "stores".* FROM "stores" WHERE "stores"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  SQL (24.9ms)  INSERT INTO "lists" ("name", "store_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["name", "Groceries"], ["store_id", 1], ["created_at", "2018-01-01 22:56:07.784814"], ["updated_at", "2018-01-01 22:56:07.784814"]]
   (0.4ms)  COMMIT
=> #<List id: 1, name: "Groceries", store_id: 1, created_at: "2018-01-01 22:56:07", updated_at: "2018-01-01 22:56:07">
irb(main):003:0> Store.first.lists
  Store Load (1.0ms)  SELECT  "stores".* FROM "stores" ORDER BY "stores"."id" ASC LIMIT $1  [["LIMIT", 1]]
NoMethodError: undefined method `lists' for #<Store:0x007faa839f2d58>
	from (irb):3
```

check to see first list associated with store
```rails
Store.first.lists
```
If it works it should look something like this
```rails
irb(main):001:0> Store.first.lists
  Store Load (0.5ms)  SELECT  "stores".* FROM "stores" ORDER BY "stores"."id" ASC LIMIT $1  [["LIMIT", 1]]
  List Load (0.5ms)  SELECT  "lists".* FROM "lists" WHERE "lists"."store_id" = $1 LIMIT $2  [["store_id", 1], ["LIMIT", 11]]
=> #<ActiveRecord::Associations::CollectionProxy [#<List id: 1, name: "Groceries", store_id: 1, created_at: "2018-01-01 22:56:07", updated_at: "2018-01-01 22:56:07">]>
```

### Add Items to Database
Enter rails console
```bash
    bundle exec rails c
```
Make Item name
```rails
Item.create(name: 'ice cream', price: 4, sku: 'S5', list_id:1)
```
If it worked your rails console should return something like this
```rails
irb(main):002:0> Item.create(name: 'ice cream', price: 4, sku: 'S5', list_id:1)
   (0.2ms)  BEGIN
  List Load (2.5ms)  SELECT  "lists".* FROM "lists" WHERE "lists"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  SQL (13.6ms)  INSERT INTO "items" ("name", "price", "sku", "list_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"  [["name", "ice cream"], ["price", 4], ["sku", "S5"], ["list_id", 1], ["created_at", "2018-01-01 23:02:56.260515"], ["updated_at", "2018-01-01 23:02:56.260515"]]
   (1.2ms)  COMMIT
=> #<Item id: 1, name: "ice cream", price: 4, sku: "S5", list_id: 1, created_at: "2018-01-01 23:02:56", updated_at: "2018-01-01 23:02:56">
irb(main):003:0> quit
```

### Check Deletion Properties
Make sure if a parent model is destroyed its children are destroyed as well

```Store Model
has_many :lists, dependent: :destroy
```
```List Model
has_many :items, dependent: :destroy
```

## Add Valadations to Model
Validations are used to only accept complete data into the database

```Store Model
validates :name, presence: true
validates :name, uniqueness: true
```

## Create Model Methods

Create at least two model methods (1 instance method and 1 class method) 

We will aggregate prices of items as sums.

### Class Method
Given no instance sum all the prices for all items.
Note: Item is a class not an instance.
We created a class method in the Stores model. This method allows us to alpabetically organize our Stores.

```Store Model
def self.by_name
        order(:name)
end
```
This call will be made and applied to all Stores from our database.
To check to make sure the class ran the way we expected we ran created two more Stores in the database and ran the ".by_name" method

```rails
irb(main):001:0> Store.create(name:'Amazon')
   (0.3ms)  BEGIN
  Store Exists (1.9ms)  SELECT  1 AS one FROM "stores" WHERE "stores"."name" = $1 LIMIT $2  [["name", "Amazon"], ["LIMIT", 1]]
  SQL (0.8ms)  INSERT INTO "stores" ("name", "created_at", "updated_at") VALUES ($1, $2, $3) RETURNING "id"  [["name", "Amazon"], ["created_at", "2018-01-01 23:32:43.944025"], ["updated_at", "2018-01-01 23:32:43.944025"]]
   (7.5ms)  COMMIT
=> #<Store id: 2, name: "Amazon", created_at: "2018-01-01 23:32:43", updated_at: "2018-01-01 23:32:43">
irb(main):002:0> Store.create(name:'Zara')
   (0.3ms)  BEGIN
  Store Exists (1.3ms)  SELECT  1 AS one FROM "stores" WHERE "stores"."name" = $1 LIMIT $2  [["name", "Zara"], ["LIMIT", 1]]
  SQL (1.0ms)  INSERT INTO "stores" ("name", "created_at", "updated_at") VALUES ($1, $2, $3) RETURNING "id"  [["name", "Zara"], ["created_at", "2018-01-01 23:33:07.437531"], ["updated_at", "2018-01-01 23:33:07.437531"]]
   (1.9ms)  COMMIT
=> #<Store id: 3, name: "Zara", created_at: "2018-01-01 23:33:07", updated_at: "2018-01-01 23:33:07">
irb(main):003:0> Store.by_name
  Store Load (2.8ms)  SELECT  "stores".* FROM "stores" ORDER BY "stores"."name" ASC LIMIT $1  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<Store id: 2, name: "Amazon", created_at: "2018-01-01 23:32:43", updated_at: "2018-01-01 23:32:43">, #<Store id: 1, name: "Costco", created_at: "2018-01-01 22:54:10", updated_at: "2018-01-01 22:54:10">, #<Store id: 3, name: "Zara", created_at: "2018-01-01 23:33:07", updated_at: "2018-01-01 23:33:07">]>
```
### Instance Method
Given an instance of a list sum all the prices for the items in that list.

We created an instance method in the Item model. This method allows us to view the name and price of a requested Item.

```Item Model
def show_price
    "#{self.name} costs #{self.price}"
end
```
This call will be made and applied to only the Items that are called in the method.
To check to make sure this instance class ran the way we expected we ran created two more Items in the database and ran the "show_price" method


```rails
irb(main):005:0> Item.create(name: 'socks', price: 2, sku: 'H4',list_id:1)
   (0.2ms)  BEGIN
  List Load (0.5ms)  SELECT  "lists".* FROM "lists" WHERE "lists"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  SQL (1.4ms)  INSERT INTO "items" ("name", "price", "sku", "list_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"  [["name", "socks"], ["price", 2], ["sku", "H4"], ["list_id", 1], ["created_at", "2018-01-01 23:38:48.203368"], ["updated_at", "2018-01-01 23:38:48.203368"]]
   (6.3ms)  COMMIT
=> #<Item id: 2, name: "socks", price: 2, sku: "H4", list_id: 1, created_at: "2018-01-01 23:38:48", updated_at: "2018-01-01 23:38:48">
irb(main):006:0> Item.create(name: 'lettuce', price: 5, sku: '64',list_id:1)
   (0.3ms)  BEGIN
  List Load (0.3ms)  SELECT  "lists".* FROM "lists" WHERE "lists"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
  SQL (2.5ms)  INSERT INTO "items" ("name", "price", "sku", "list_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"  [["name", "lettuce"], ["price", 5], ["sku", "64"], ["list_id", 1], ["created_at", "2018-01-01 23:39:18.827548"], ["updated_at", "2018-01-01 23:39:18.827548"]]
   (1.9ms)  COMMIT
=> #<Item id: 3, name: "lettuce", price: 5, sku: "64", list_id: 1, created_at: "2018-01-01 23:39:18", updated_at: "2018-01-01 23:39:18">
irb(main):007:0> quit
```
```rails
irb(main):001:0> item.first.show_price
NameError: undefined local variable or method `item' for main:Object
	from (irb):1
irb(main):002:0> Item.first.show_price
  Item Load (0.6ms)  SELECT  "items".* FROM "items" ORDER BY "items"."id" ASC LIMIT $1  [["LIMIT", 1]]
=> "ice cream costs 4"
irb(main):003:0> Item.last.show_price
  Item Load (0.4ms)  SELECT  "items".* FROM "items" ORDER BY "items"."id" DESC LIMIT $1  [["LIMIT", 1]]
=> "lettuce costs 5"
irb(main):004:0> Item.find(2).show_price
  Item Load (0.6ms)  SELECT  "items".* FROM "items" WHERE "items"."id" = $1 LIMIT $2  [["id", 2], ["LIMIT", 1]]
=> "socks costs 2"
irb(main):005:0>
```

## Making additions to the Gem File
If additions are made to the Gem File then run the bundle command in the terminal
```bash
bundle
```
## Understanding the Instance Method
I was having a difficult time understanding the instance method so Taylor walked me though how to using binding pry. You can see with the binding pry the values that are assigned to different variables. This helped me see that the instance method only pulled one entry or one instance from the item database.

```rails
irb(main):001:0> Item.first
  Item Load (0.7ms)  SELECT  "items".* FROM "items" ORDER BY "items"."id" ASC LIMIT $1  [["LIMIT", 1]]
=> #<Item id: 1, name: "ice cream", price: 4, sku: "S5", list_id: 1, created_at: "2018-01-01 23:02:56", updated_at: "2018-01-01 23:02:56">
irb(main):002:0> Item.first.show_price
  Item Load (0.6ms)  SELECT  "items".* FROM "items" ORDER BY "items"."id" ASC LIMIT $1  [["LIMIT", 1]]

From: /Users/raqueleisele/Desktop/DevPoint/week4/shopping_app/app/models/item.rb @ line 5 Item#show_price:

    4: def show_price
 => 5:   binding.pry
    6:   "#{}"
    7: end

[1] pry(#<Item>)> self.name
=> "ice cream"
[2] pry(#<Item>)> self.price
=> 4
[3] pry(#<Item>)> quit
=> ""
irb(main):003:0> quit
```