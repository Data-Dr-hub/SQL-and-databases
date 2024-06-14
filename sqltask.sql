/*
1.1 You’ve been asked to extract the data on products from the Product table where there exists a product subcategory. And also include the name of the ProductSubcategory.

Columns needed: ProductId, Name, ProductNumber, size, color, ProductSubcategoryId, Subcategory name.
Order results by SubCategory name.
*/

--My solution:
SELECT													
 ProductID,													
 products.Name,													
 ProductNumber,													
 size,													
 Color,													
 products.ProductSubcategoryID,													
 subcategory.Name as SubCategory -- select the name column from the subcategory table and rename as SubCategory													
FROM													
 `adwentureworks_db.product`products --alias product table as products													
JOIN													
 `adwentureworks_db.productsubcategory`subcategory --join the subcategory table with alias subcategory													
ON													
 products.ProductSubcategoryID = subcategory.ProductSubcategoryID													
ORDER BY													
 SubCategory													
												
/*
1.2 In 1.1 query you have a product subcategory but see that you could use the category name.
Find and add the product category name.
Afterwards order the results by Category name.
*/
--My Solution:
SELECT
  ProductID,
  products.Name,
  ProductNumber,
  size,
  Color,
  products.ProductSubcategoryID,
  subcategory.Name as SubCategory, -- select the name column from the subcategory table and rename as SubCategory
  category.Name as Category --select the product category name from the category table
FROM
  `adwentureworks_db.product`products --alias product table as products
JOIN
  `adwentureworks_db.productsubcategory`subcategory --join the productsubcategory table with alias subcategory
ON
  products.ProductSubcategoryID = subcategory.ProductSubcategoryID 
JOIN
  `adwentureworks_db.productcategory` category --join the productcategory table with alias category
ON
  category.ProductCategoryID = subcategory.ProductCategoryID
ORDER BY
  Category


/*
1.3 Use the established query to select the most expensive (price listed over 2000) bikes that are still actively sold (does not have a sales end date)

Order the results from most to least expensive bike.
*/
--My Solution:
SELECT
  products.Name,
  products.ListPrice as Price,
FROM
  `adwentureworks_db.product`products --alias product table as products
JOIN
  `adwentureworks_db.productsubcategory`subcategory --join the productsubcategory table with alias subcategory
ON
  products.ProductSubcategoryID = subcategory.ProductSubcategoryID -- leave the subcategory table joined as a connection between products and category tables
JOIN
  `adwentureworks_db.productcategory` category --join the productcategory table with alias category
ON
  category.ProductCategoryID = subcategory.ProductCategoryID
WHERE category.Name = "Bikes" 
      AND products.ListPrice > 2000
      AND SellEndDate IS NULL
ORDER BY Price DESC

/*
2.1 Create an aggregated query to select the:

Number of unique work orders.
Number of unique products.
Total actual cost.
For each location Id from the 'workoderrouting' table for orders in January 2004.
*/
--My Solution:
SELECT
  routing.LocationID AS LocationId,
  -- get count of unique workorders and products 
  COUNT(DISTINCT workorder.WorkOrderID) AS no_work_orders,
  COUNT(DISTINCT workorder.ProductID) AS no_unique_products,
  SUM(routing.ActualCost) AS actual_cost -- the Actual Cost from the workorderrouting table
FROM
  `tc-da-1.adwentureworks_db.workorder` AS workorder
JOIN
  `tc-da-1.adwentureworks_db.workorderrouting` AS routing
ON
  workorder.WorkOrderID = routing.WorkOrderID
-- filter for orders in January 2004
WHERE
  (EXTRACT(YEAR
  FROM
    routing.ActualStartDate)= 2004) 
  AND
  (EXTRACT(MONTH
  FROM
    routing.ActualStartDate)= 01) 
GROUP BY
  LocationID

/*
2.2 Update your 2.1 query by adding the name of the location 
and also add the average days amount between actual start date and actual end date per each location.
*/
--My Solution:
SELECT
  routing.LocationID AS LocationId,
  Location.Name as location, --get location from Location table
  -- get count of unique workorders and products 
  COUNT(DISTINCT workorder.WorkOrderID) AS no_work_orders,
  COUNT(DISTINCT workorder.ProductID) AS no_unique_products,
  SUM(routing.ActualCost) AS actual_cost, -- the Actual Cost from the workorderrouting table
  ROUND(
        AVG(
            DATETIME_DIFF(routing.ActualEndDate, routing.ActualStartDate, DAY)
            ), 
        2) AS avg_days_diff
FROM
  `tc-da-1.adwentureworks_db.workorder` AS workorder
JOIN
  `tc-da-1.adwentureworks_db.workorderrouting` AS routing
ON
  workorder.WorkOrderID = routing.WorkOrderID
JOIN
  `tc-da-1.adwentureworks_db.location` as Location
ON
  routing.LocationID = Location.LocationID
-- filter for orders in January 2004
WHERE
  (EXTRACT(YEAR
  FROM
    routing.ActualStartDate)= 2004) 
  AND
  (EXTRACT(MONTH
  FROM
    routing.ActualStartDate)= 01) 
GROUP BY
  LocationID, location

/*
2.3 Select all the expensive work Orders (above 300 actual cost) that happened throught January 2004.
*/
--My Solution:
SELECT
  workorder.WorkOrderID,
  SUM(ActualCost) AS actual_cost
FROM
  `tc-da-1.adwentureworks_db.workorder` AS workorder
JOIN
  `tc-da-1.adwentureworks_db.workorderrouting` AS routing
ON
  workorder.WorkOrderID = routing.WorkOrderID
WHERE
  (EXTRACT(YEAR
    FROM
      routing.ActualStartDate)= 2004)
  AND (EXTRACT(MONTH
    FROM
      routing.ActualStartDate)= 01)
GROUP BY
  workorder.WorkOrderID
HAVING
  actual_cost > 300

/*
3.1 Your colleague has written a query to find the list of orders connected to special offers. 
The query works fine but the numbers are off, investigate where the potential issue lies.
*/
--The Wrong Query:
/*
SELECT sales_detail.SalesOrderId
      ,sales_detail.OrderQty
      ,sales_detail.UnitPrice
      ,sales_detail.LineTotal
      ,sales_detail.ProductId
      ,sales_detail.SpecialOfferID
      ,spec_offer_product.ModifiedDate
      ,spec_offer.Category
      ,spec_offer.Description

FROM `tc-da-1.adwentureworks_db.salesorderdetail`  as sales_detail

left join `tc-da-1.adwentureworks_db.specialofferproduct` as spec_offer_product
on sales_detail.productId = spec_offer_product.ProductID

left join `tc-da-1.adwentureworks_db.specialoffer` as spec_offer
on sales_detail.SpecialOfferID = spec_offer.SpecialOfferID

order by LineTotal desc
*/
--My Solution:
SELECT sales_detail.SalesOrderId
      ,sales_detail.OrderQty
      ,sales_detail.UnitPrice
      ,sales_detail.LineTotal
      ,sales_detail.ProductId
      ,sales_detail.SpecialOfferID
      ,spec_offer_product.ModifiedDate
      ,spec_offer.Category
      ,spec_offer.Description

FROM `tc-da-1.adwentureworks_db.salesorderdetail`  as sales_detail

left join `tc-da-1.adwentureworks_db.specialofferproduct` as spec_offer_product
on sales_detail.productId = spec_offer_product.ProductID AND sales_detail.SpecialOfferID = spec_offer_product.SpecialOfferID

left join `tc-da-1.adwentureworks_db.specialoffer` as spec_offer
on sales_detail.SpecialOfferID = spec_offer.SpecialOfferID

order by LineTotal desc

/*
3.2 Your colleague has written this query to collect basic Vendor information. The query does not work, look into the query and find ways to fix it. 
Can you provide any feedback on how to make this query be easier to debug/read?
*/
--Wrong Query:
/*
SELECT a.VendorId as Id,vendor_contact.ContactId, b.ContactTypeId, a.Name, a.CreditRating, a.ActiveFlag, c.AddressId,d.City

FROM tc-da-1.adwentureworks_db.Vendor as a

left join tc-da-1.adwentureworks_db.vendorcontact as vendor_contact on vendor.VendorId = vendor_contact.VendorId left join tc-da1.adwentureworks_db.vendoraddress as c on a.VendorId = c.VendorId

left join tc-da-1.adwentureworks_db.address as address on vendor_address.VendorId = d.VendorId
*/
--My Solution:
SELECT
  vendor.VendorID AS Id,
  vendor_contact.ContactId,
  vendor_contact.ContactTypeID,
  vendor.Name,
  vendor.CreditRating,
  vendor.ActiveFlag,
  vendor_address.AddressId,
  address.City
FROM
  `tc-da-1.adwentureworks_db.vendor` AS vendor
LEFT JOIN
  `tc-da-1.adwentureworks_db.vendorcontact` AS vendor_contact
ON
  vendor.VendorId = vendor_contact.VendorId
LEFT JOIN
  `tc-da-1.adwentureworks_db.vendoraddress` AS vendor_address
ON
  vendor.VendorId = vendor_address.VendorId
LEFT JOIN
  `adwentureworks_db.address` AS address
ON
  vendor_address.AddressID = address.AddressID

  