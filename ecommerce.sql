SELECT * FROM ecommerce;

--Percentage sales by country
SELECT
    country,
    CONCAT('$ ', TRIM(TO_CHAR(ROUND(SUM(itemtotal), 0), '9G999G999'))) AS country_sales,
    CONCAT(ROUND(SUM(itemtotal)
     / 
     (SELECT SUM(itemtotal) FROM ecommerce) *100 ,2)::text, '%') 
      AS percentage_of_sales
FROM ecommerce
GROUP BY country
ORDER BY percentage_of_sales DESC;


--Most popular products

SELECT stockcode, description, sum(quantity)as no_of_orders
FROM ecommerce
group by stockcode, description
order by sum(quantity) desc
limit 10

---New customers each month 

WITH ucem AS
(
    SELECT
        TO_CHAR(invoice_date, 'YYYY-MM') AS month 
        ,CAST(customerid AS VARCHAR) AS customerid
        
        ,COUNT(*) 
    FROM ecommerce
    WHERE customerid IS NOT NULL 
    GROUP BY month, customerid 
    ORDER BY month, customerid
),
create_lists_with_customerids_present_before AS
(
    SELECT
        month
        ,customerid
        ,STRING_AGG(customerid, ',') OVER(
            ORDER BY month, customerid
            ROWS BETWEEN UNBOUNDED PRECEDING
                         AND
                         CURRENT ROW
            ) AS lists
       
    FROM ucem
),
shift_lists_up_in_order_to_compare_with_previous_customerids AS
(
    SELECT
        month
        ,customerid
        ,LAG(lists, 1) OVER(ORDER BY month,customerid) AS lists
  
    FROM create_lists_with_customerids_present_before
),
check_if_customerid_is_new AS
(
    SELECT
        month
        ,customerid
        ,CASE
            WHEN POSITION(customerid IN lists) > 0 
            THEN 0    
            ELSE 1    
         END AS is_new
        
    FROM shift_lists_up_in_order_to_compare_with_previous_customerids
),
final_table AS
(
    SELECT
        month
        ,ROW_NUMBER() OVER(ORDER BY month) 
        ,COUNT(customerid) AS unique_customers_this_month
        ,SUM(is_new) AS new_customers_this_month
        ,SUM(SUM(is_new)) OVER(  
            ORDER BY month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS total_unique_customers
    FROM check_if_customerid_is_new
    GROUP BY month  
)                   

SELECT
    TO_CHAR(TO_DATE(month,'YYYY-MM'), 'Mon YYYY') AS month
    ,unique_customers_this_month
    ,total_unique_customers
FROM final_table
ORDER BY row_number 
;
     










