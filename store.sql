--question 1
select * from store
limit 10;

--Qn.2
select count(distinct order_id)
from store;

select count(distinct customer_id)
from store;

--Qn.3
select customer_id,customer_email,customer_phone 
from store
where customer_id=1;

--Qn. 4
select item_1_id,item_1_name,item_1_price
from store 
where item_1_id=4;


--Qn.5
create table customers as
select distinct customer_id,customer_phone,
customer_email
from store;

--Qn.6
alter table customers
add primary key(customer_id);

--Qn.7
create table items as
select distinct item_1_id as item_id,
       item_1_name as name,item_1_price as price
       from store
       union
   select distinct item_2_id as item_id,
       item_2_name  as name,
       item_2_price as price
       from store 
       where item_2_id is not null
       union
       select distinct item_3_id as item_id,
       item_3_name as name,
       item_3_price as price
       from store   
        where item_3_id is not null;
--Qn.8
alter table items
add primary key(item_id);

--Qn. 9
create table orders_items as
select order_id,
item_1_id as item_id
from store
union all
select order_id,
item_2_id as item_id
from store
where item_2_id is not null
union all
select order_id,
item_3_id as item_id
from store
where item_3_id is not null;

--Qn.10
create table orders as
select  order_id,order_date,customer_id
from store;
--Qn.11
alter table orders
add primary key(order_id);

--Qn.12
alter table orders
add foreign key(customer_id) references customers(customer_id) on delete cascade;

--Qn.13
alter table orders_items
add foreign key(item_id) references items(item_id) on delete cascade,
add foreign key(order_id) references orders(order_id) on delete cascade;

select constraint_name ,table_name,column_name
from information_schema.key_column_usage
where table_name='orders_items';


--Qn.14
select customer_email,order_id
from store
where order_date >'2019-07-25'
limit 10;

--Qn.15
select a.customer_email,b.order_id
from customers a, orders b
where a.customer_id=b.customer_id
and b.order_date >'2019-07-25'
limit 10;

--Qn.16
with store_orders as(
  select item_1_name item,
         order_id
         from store
         union all
       select item_2_name item,
         order_id
         from store  
         where item_2_id is not null
         union all
         select item_3_name item,
         order_id
         from store
         where item_3_id is not null
)
select item ,count(order_id) as Number_of_orders
from store_orders
group by 1
order by 2 desc
limit 10;

 --Qn.7
 select b.name,
 count(a.item_id) as number_of_orders
 from orders_items a
 join items b
 on b.item_id=a.item_id
 group by 1
 order by 2 desc
 limit 10;   

 --Qn.18
 select customer_email,count(*)
 from store
 group by 1
 having count(*) >1
 order by 2 desc 
 limit 10;  

 --===normalized db
 select a.customer_email,
 count(distinct b.order_id)
 from customers a,orders_items b,orders c
 where c.customer_id=a.customer_id
 and b.order_id=c.order_id
 group by 1
 having count(b.order_id) >1
 order by 2 desc
 limit 10;
 ---
select * from orders
where customer_id=18;
--
select * from orders_items
where order_id in(18,98);
--
select customer_id from customers
 where customer_email='Armando18@email.com';

 --lamp
 with order_inc_lamp as(
select item_1_name item,
       order_date
from store
where item_1_name='lamp' 
and order_date>'2019-07-15'
union all
select item_2_name item,
       order_date
from store
where item_2_name='lamp' 
and order_date>'2019-07-15' 
union all
select item_3_name item,
       order_date
from store
where item_3_name='lamp' 
and order_date>'2019-07-15' 
 )
 select 'Including lamp' as name,count(*) from order_inc_lamp;

 --normalize
 select b.name,
 count(a.order_id) 
 from orders_items a
 join items b
 on b.item_id=a.item_id
 join orders c
 on c.order_id=a.order_id
 where b.name='lamp'
 and c.order_date >'2019-07-17'
 group by 1;

--not structured
with order_inc_chair as(
select item_1_name item,
       order_date
from store
where item_1_name='chair' 

union all
select item_2_name item,
       order_date
from store
where item_2_name='chair' 
 
union all
select item_3_name item,
       order_date
from store
where item_3_name='chair' 

 )
 select 'Including chair' as name,count(*) from order_inc_chair;

 ---normalized
 select 
 count(a.order_id) as Including_chairs
 from orders_items a
 join items b
 on b.item_id=a.item_id
 where b.name='chair'
