use Competition;

-- add review column


-- add trigger to sales operation to calc payoff and to add constrain on review

CREATE or alter TRIGGER review_tirgger
on Sales_operation
after insert
as
begin

	-- give coupon to client
	if exists(
		select 1
		from Sales_operation so inner join inserted i
		on so.Client_ID = i.Client_ID
		where count(so.Client_ID)>= 2
		group by so.Client_ID
	)
	begin 
		print('coustomer');
		
	end

	-- check review
	if exists(
		select 1
		from inserted
		where review < 1 or review > 5
	)
	begin
		rollback transaction
		print('Review must be from 1 to 5')
	end
	else
	begin 
		commit transaction
		print('Review Done')

	end
	-- calculate avg rating to every sales person every month
	if day(getdate()) = day(eomonth(getdate())) 
	begin
		insert into Sales_Person_Payoff
		select SalesPerson_ID,GETDATE(),avg(review) as numOfReview
		from Sales_operation
		where  month(Operation_Date) = month(GETDATE())
		group by SalesPerson_ID;
		print('done payoff');
	end
	else 
	begin
		print('failed payoff');

	end;

	
end;
----------------------------------------------------------------------------------------------------------------------------------

-- filter car with model 

select *
from car_category
where Manufacturer = 'TOYOTA';

-- filter car with category 

select *
from car_category cc inner join car c
on cc.Car_Category_ID = c.Category_ID
where cc.Category = 'jeep';

----------------------------------------------------------------------------------------------------------------------------------

-- check quantity befor insert

declare @carID int = 7;
declare @carQuantity int = 1; -- quantity will be sold
if exists(
	select 1 
	from car 
	where car_ID = @carID and Quantity >= @carQuantity
)
begin
	
	-- count down quantity in the table
	update car
	set Quantity = Quantity - @carQuantity
	where car_ID = @carID;

	-- insert in client table
	insert into client 
	values(22,'Mariem','mariem@gmail.com','mansoura');
	
	-- insert in sales operation
	insert into Sales_operation (Operation_Date,Fees,Payment_Method,SalesPerson_ID,car_ID,Client_ID,quantity,review)
	select '2024-8-01',50.50,'Bank',1,cr.Car_ID,Client_ID,@carQuantity, 1
	from car cr inner join car_category cc
	on cc.Car_Category_ID = cr.Category_ID
	inner join Client
	on Client_ID = 22 and cr.car_ID = @carID;

	print('Successful insert and updated');
end
else 
begin 
print('Failed to insert');
end;
-----------------------------
----------------------------------------------------------------------------------------------------------------------------------


create table Sales_Person_Payoff
(
	sales_person_ID int,
	payoff_date date,
	payoff decimal(10,2),

	primary key (sales_person_ID,payoff_date),
	foreign key (sales_person_ID) references Sales_Person(SalesPerson_ID)
);

/*create trigger tri_payoff
on sales_operation
after insert 
as
begin
	if day(getdate()) = day(eomonth(getdate())) or day(GETDATE()) = day(GETDATE())
	begin
		insert into Sales_Person_Payoff
		select SalesPerson_ID,GETDATE(),avg(review) as numOfReview
		from Sales_operation
		where  month(Operation_Date) = month(GETDATE())
		group by SalesPerson_ID;
		print('done payoff');
	end
	
end;

CREATE TRIGGER tri_payoff
on Sales_operation
after insert
as
begin
	if day(getdate()) = day(eomonth(getdate())) or day(GETDATE()) = day(GETDATE())
	begin
		insert into Sales_Person_Payoff
		select SalesPerson_ID,GETDATE(),avg(review) as numOfReview
		from Sales_operation
		where  month(Operation_Date) = month(GETDATE())
		group by SalesPerson_ID;
		print('done payoff');
	end
	else 
	begin
	print('pay off failed')
	end;
end;
*/





select SalesPerson_ID, count(SalesPerson_ID), sum(review)
from Sales_operation
group by SalesPerson_ID

/*create or alter trigger tri_payoff
on Sales_operation
after insert
as 
begin
if 1 = 1
begin
print('offffffffffff')
end
end;

CREATE OR ALTER TRIGGER tri_payoff_test
ON Sales_operation
AFTER INSERT
AS 
BEGIN
    PRINT 'Trigger Fired';
END;*/

-- check trigger enable or not
SELECT name, is_disabled
FROM sys.triggers
WHERE parent_id = OBJECT_ID('Sales_operation') AND name = 'tri_payoff';

--------------------------------------------------------------
-- deadline

declare @clientID int = 112;
if exists(
	select 1 
	from installments i inner join Sales_operation so
	on Sale_op = Operation_ID
	where Installment_Due_Date < GETDATE() and Paid = 0 and Client_ID = @clientID
)
begin
print('Not paid');
end;


alter table coupon
add client_id int


-- declare @numOfOperations int = 2;
create or alter trigger trig_disCoupon
on sales_operation
after insert
as
begin
	if exists(
		select count(so.Client_ID)
		from Sales_operation so inner join inserted i
		on so.Client_ID = i.Client_ID
		where so.Client_ID >= 2
		group by so.Client_ID
	)
	begin 
		print('coustomer')
	end
end;