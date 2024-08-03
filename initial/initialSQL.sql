-- Register a new car

insert into Car (car_ID,Quantity)
select  car_id, ABS(CHECKSUM(NEWID()) % 100) + 1
from Car_Category
where car_id = 20;

-- Record the sale of a car to a new client, allowing payment via bank account. 

insert into client 
values(3,'Mariem','mariem@gmail.com','mansoura');

insert into Sales_operation
select 20,'2024-12-01',Price,50.50,'Bank',5,car_id,Client_ID
from Client, Car_Category
where Client_ID = 3 and Car_Category_ID = 23242980;

-- Retrieve the number of clients who bought cars in the last month. 

select count(Operation_ID)
from Sales_operation
where Operation_Date >= DATEADD(MONTH, -1, GETDATE());


-- Fetch details of cars purchased by a client based on their phone number.

select *
from Sales_operation s
inner join Client_Phone c
on c.Client_ID = s.Client_ID
inner join Car_Category cc
on cc.car_id = s.car_ID
where c.Client_Phone = 012345678l;


-- Identify the top 10 salespersons by the number of sales.

select top 10 SalesPerson_ID , count(SalesPerson_ID) as numOfSales
from Sales_operation
group by SalesPerson_ID
ORDER BY numOfSales DESC;

-- Determine the town with the most customers.

select top 1 Client_Address, count(Client_Address) as twon_count
from Client
group by Client_Address
ORDER BY twon_count DESC;

-- Calculate the total revenue from car sales in 2024. 

select sum(s.Price) as [ total revenue]
from Sales_operation s
 join Car_Category c
on c.car_id = s.car_ID
where YEAR(Operation_Date) = 2024;
