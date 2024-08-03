# ERD Overview

- Each car has an ID and Quantity also it have a relation with car category
- Car Category to explain model, price, color, production_Year and manufacturer. Here we know the details of our car
- Client entity has an id, email, name, address, phone numbers (multi value)
- We have also Sales_Operation which organize our sales as it has operation_date, installment_plan, Fees, PaymentMethod, Price and for sure operation id
- Finally sales person who handle client and records the sale operation it has an ID, Name, Email, phone Numbers  (multi value) and address
    
    ![initialERD.jpg](https://prod-files-secure.s3.us-west-2.amazonaws.com/82f4328f-1316-499c-976b-272748013a6c/733627af-206b-4561-989b-212d70c1a7bd/initialERD.jpg)
    

---

# Schema Overview

- Car has a relation with Car category and car category id is a FK in car table
- Sales operation has a relation with Car and Client sales person so it has an FK for Client id, Car id and Sales person id
- Sales person phone in a single table with id of sales person as a multivalue
- client phone in a single table with id of client as a multivalue
    
    ![Initialschema.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/82f4328f-1316-499c-976b-272748013a6c/c05cecfd-c910-4197-b937-1563825a501f/Initialschema.png)
    

---

# Queries

1. Register a new car
    
    ```sql
    
    insert into Car (car_ID,Quantity)
    select  car_id, ABS(CHECKSUM(NEWID()) % 100) + 1
    from Car_Category
    where car_id = 20;
    ```
    
    here the quantity column is a random num from 1 to 100
    
2. Record the sale of a car to a new client, allowing payment via bank account
    
    ```sql
    insert into client 
    values(3,'Mariem','mariem@gmail.com','mansoura');
    
    insert into Sales_operation
    select 20,'2024-12-01',Price,50.50,'Bank',5,car_id,Client_ID
    from Client, Car_Category
    where Client_ID = 3 and Car_Category_ID = 23242980;
    ```
    
3. Retrieve the number of clients who bought cars in the last month
    
    ```sql
    select count(Operation_ID)
    from Sales_operation
    where Operation_Date >= DATEADD(MONTH, -1, GETDATE());
    ```
    
4. Fetch details of cars purchased by a client based on their phone number
    
    ```sql
    select *
    from Sales_operation s
    inner join Client_Phone c
    on c.Client_ID = s.Client_ID
    inner join Car_Category cc
    on cc.car_id = s.car_ID
    where c.Client_Phone = 012345678l;
    
    ```
    
5. Identify the top 10 salespersons by the number of sales
    
    ```sql
    select top 10 SalesPerson_ID , count(SalesPerson_ID) as numOfSales
    from Sales_operation
    group by SalesPerson_ID
    ORDER BY numOfSales DESC;
    ```
    
6.  Determine the town with the most customers
    
    ```sql
    select top 1 Client_Address, count(Client_Address) as twon_count
    from Client
    group by Client_Address
    ORDER BY twon_count DESC;
    ```
    
7. Calculate the total revenue from car sales in 2024
    
    ```sql
    select sum(s.Price) as [ total revenue]
    from Sales_operation s
     join Car_Category c
    on c.car_id = s.car_ID
    where YEAR(Operation_Date) = 2024;
    
    ```