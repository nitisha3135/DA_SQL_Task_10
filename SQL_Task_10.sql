-- 1NF

create table food_products (
    Product_Id varchar(10),
    Product_Name varchar(100),
    Category varchar(50),
    Price decimal(10, 2),
    Stock_Quantity int,
    Supplier varchar(100),
    Expiration_Date date,
    Discount_Percentage int,
    Is_Organic varchar(3),
    Rating decimal(2, 1)
);

select * from food_products;

copy food_products from 'D:\SQL Tasks\Food_Products.csv' DELIMITER ',' csv header;

-- To fix it we have to determine primary key for the above table as follows

alter table food_products
add primary key (Product_Id);

select * from food_products;

-- Now the table satisfies the condition of 1NF.


-- 2NF

create table products as 
select product_id,product_name,category,price,stock_quantity,supplier,expiration_date,discount_percentage,is_organic,rating
from food_products;

select * from products;

create table suppliers as select distinct supplier from food_products;

select * from suppliers;

alter table suppliers add supplier_id serial primary key;

alter table products add supplier_id int;

update products as p
set supplier_id = s.supplier_id
from suppliers as s
where p.supplier = s.supplier;

alter table products drop column supplier;

select p.*, s.supplier 
from products as p
join suppliers as s
on p.supplier_id = s.supplier_id;


-- 3NF

create table categories as select distinct category from food_products;

select * from categories;

alter table categories add category_id serial primary key;

alter table products add category_id int;

update products as p
set category_id = c.category_id
from categories as c 
where p.category = c.category;

alter table products drop column category;

select p.*,s.supplier,c.category
from products p
join categories c on p.category_id = c.category_id
join suppliers s on p.supplier_id = s.supplier_id;

alter table products
add foreign key (category_id)references categories (category_id);

alter table products
add foreign key (supplier_id)references suppliers (supplier_id);


