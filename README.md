# Turing College Project: SQL and databases 
This is an hands-on real world project I carried out and reviewed with an SQL Expert **Tomas Rimkus**.
# Tasks:
## 1. An overview of Products

**1.1** I was asked to extract the data on products from the Product table where there exists a product subcategory. And also include the name of the ProductSubcategory.

   * Columns needed: ProductId, Name, ProductNumber, size, color, ProductSubcategoryId, Subcategory name.
   * Order results by SubCategory name.
    
**1.2** In 1.1 query I have a product subcategory but see that I could use the category name.

  * Find and add the product category name.
  * Afterwards order the results by Category name.
    
**1.3** I am to use the established query to select the most expensive (price listed over 2000) bikes that are still actively sold (does not have a sales end date)

  * Order the results from most to least expensive bike.

## 2. Reviewing work orders
**2.1** I Created an aggregated query to select the:

* Number of unique work orders.
* Number of unique products.
* Total actual cost.
For each location Id from the 'workoderrouting' table for orders in January 2004.

**2.2** I updated the 2.1 query by adding the name of the location and also add the average days amount between actual start date and actual end date per each location.

**2.3** I selected all the expensive work Orders (above 300 actual cost) that happened throught January 2004.

## 3. Query validation
**Below are 2 queries that needed to be fixed/updated:**

**3.1** My colleague was assumed to have written a query to find the list of orders connected to special offers. The query works fine but the numbers are off. 
```
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
```
I investigated where the potential issue lies and made correction accordingly.

**3.2** A colleague is assumed to have written the query below to collect basic Vendor information. The query does not work:

```
SELECT a.VendorId as Id,vendor_contact.ContactId, b.ContactTypeId, a.Name, a.CreditRating, a.ActiveFlag, c.AddressId,d.City

FROM tc-da-1.adwentureworks_db.Vendor as a

left join tc-da-1.adwentureworks_db.vendorcontact as vendor_contact on vendor.VendorId = vendor_contact.VendorId left join tc-da1.adwentureworks_db.vendoraddress as c on a.VendorId = c.VendorId

left join tc-da-1.adwentureworks_db.address as address on vendor_address.VendorId = d.VendorId
```

I examined the query and found ways to fix it.

**This project was done in BigQuery.**

Here is a link to the project documents:
1. [Spreadsheet Results and Query](https://1drv.ms/x/c/52de9c3c4fde2f7c/EcYaQ-nPNvFKoqb3g_WWDWEB8qglyUd8EMMhTrA0_gn5Gg?e=jSgpC7)
2. [Task 3.1 Result and Query](https://docs.google.com/spreadsheets/d/1b7aYaiHd0pPbX5N0XI74CnE0_8Yd6lGGFyuyLpqZAeo/edit?usp=sharing)
3. I have documented the sql queries in this [SQL-file](sqltask.sql)

Thanks for following through😄
