/*create Restuarant DB 
5 table, 5 query, 1 with clause, 1 subquery, 1 agg fx */

.open restaurant.db
  
---------------------- Create 5 table db 
  
DROP TABLE menus;
create table if not exists menus (
  menu_id int unique,
  menu_name TEXT,
  menu_category TEXT,
  menu_price real
);
insert into menus values
(1, "Burger", "Food", 120),
(2, "Pizza", "Food", 400),
(3, "Pasta", "Food", 200),
(4, "French fries","Snack",100),
(5, "Hashbrown","Snack",100),
(6, "Sprite", "Beverage", 30),
(7, "Water", "Beverage", 20);

DROP TABLE customers;
CREATE TABLE if not exists customers (
	customer_id int , 
	customer_name TEXT,
  customer_phonenum int,
  primary key (customer_id)
);
INSERT INTO customers VALUES
(1,"Ross","0918751224"),
(2,"Chandler","0866445987"),
(3,"Joey","0817000658"),
(4,"Monica","0909845695"),
(5,"Rachel","0909745132"),
(6,"Phoebe","0871254687");

DROP TABLE staffs;
CREATE TABLE if not exists staffs (
	staff_id INT , 
	staff_name TEXT, 
	position TEXT,
  primary key (staff_id)
);
INSERT INTO staffs VALUES
(01,"Winter","Manager"),
(02,"Spy","Waiter"),
(03,"Yui","Chef"),
(04,"Koco","Waiter"),
(05,"Knight","Dish Washer");

DROP TABLE invoices;
CREATE TABLE invoices(
	invoice_id INT unique, 
	order_date DATE, 
	amount REAL, 
	customer_id INT, 
	staff_id INT
);
INSERT INTO invoices VALUES
(1,"2023-01-02",420,1,4),
(2,"2023-01-02",200,2,2),
(3,"2023-01-03",730,3,4),
(4,"2023-01-03",600,4,4),
(5,"2023-01-05",220,5,4),
(6,"2023-01-06",600,6,2),
(7,"2023-01-06",220,6,2),
(8,"2023-01-06",500,3,2),
(9,"2023-01-07",160,2,4),
(10,"2023-01-07",400,6,2);

DROP TABLE orders;
CREATE TABLE orders(
	order_id int unique, 
  invoice_id int,
	menu_id int,
  quantity int,
  price real
);
INSERT INTO orders VALUES
  (1, 1, 2, 1, 400),
  (2, 1, 7, 1, 20),
  (3, 2, 4, 1, 100),
  (4, 2, 5, 1, 100),
  (5, 3, 2, 1, 400),
  (6, 3, 3, 1, 200),
  (7, 3, 4, 1, 100),
  (8, 3, 6, 1, 30),
  (9, 4, 2, 1, 400),
  (10, 4, 3, 1, 200),
  (11, 5, 3, 1, 200),
  (12, 5, 7, 1, 20),
  (13, 6, 1, 5, 600),
  (14, 7, 1, 1, 120),
  (15, 7, 5, 1, 100),
  (16, 8, 2, 1, 400),
  (17, 8, 4, 1, 100),
  (18, 9, 5, 1, 100),
  (19, 9, 6, 2, 60),
  (20, 10, 2, 1, 400);

---------- Custom table
.mode box
.header on

---------- Query_1 Table list to view Sales by items.
select 
  m.menu_id as No, 
  m.menu_name as Name, 
  m.menu_category as Category, 
  sum(o.quantity) as Unit_Sold,
  sum(i.amount) as Sales
  from menus m 
  join orders o on m.menu_id = o.menu_id 
  join invoices i on i.invoice_id = o.invoice_id
  group by m.menu_id ;

---------- Query_2 Sales by category
select 
  m.menu_category as Category, 
  sum(o.quantity) as Unit_Sold,
  sum(i.amount) as Sales
  from menus m 
  join orders o on m.menu_id = o.menu_id 
  join invoices i on i.invoice_id = o.invoice_id
  group by m.menu_category 
  order by Sales desc;

---------- Query_3 Which is the best selling menu using sub query.

select 
  sub.No,
  sub.Name,
  sub.Category,
  max(sub.Sales) as Best_Seller
from (
  select 
  m.menu_id as No, 
  m.menu_name as Name, 
  m.menu_category as Category, 
  sum(o.quantity) as Unit_Sold,
  sum(i.amount) as Sales
  from menus m 
  join orders o on m.menu_id = o.menu_id 
  join invoices i on i.invoice_id = o.invoice_id
  group by m.menu_id ) as sub ;

---------- Query_4 Top 3 Customers using with clause

with sub2 as (select
  c.customer_id, 
	c.customer_name,
  c.customer_phonenum,
  sum(i.amount) as Spending
from customers c
join invoices i on i.customer_id = c.customer_id 
group by c.customer_id 
order by Spending desc)

  select * 
  from sub2
  limit 3;

---------- Query_5 Cal salary for part-time waiters (500/Day).

select 
  s.staff_id,
  s.staff_name,
  s.position,
  count(i.staff_id) as Working_Day,
  count(i.staff_id)*500 as Salary
  
from staffs s
join invoices i on i.staff_id = s.staff_id
group by s.staff_id;