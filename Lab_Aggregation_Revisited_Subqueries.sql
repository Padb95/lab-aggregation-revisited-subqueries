-- Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT DISTINCT 
    customer.first_name,
    customer.last_name,
    customer.email
FROM 
    customer
JOIN 
    rental ON customer.customer_id = rental.customer_id;
    
    -- What is the average payment made by each customer (display the customer id
    -- , customer name (concatenated), and the average payment made).
    SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    AVG(p.amount) AS average_payment
FROM 
    customer c
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name;
    
    -- Select the name and email address of all the customers who have rented the "Action" movies.
    
 SELECT DISTINCT 
    CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
    customer.email
FROM 
    customer
JOIN 
    rental ON customer.customer_id = rental.customer_id
JOIN 
    inventory ON rental.inventory_id = inventory.inventory_id
JOIN 
    film ON inventory.film_id = film.film_id
JOIN 
    film_category ON film.film_id = film_category.film_id
JOIN 
    category ON film_category.category_id = category.category_id
WHERE 
    category.name = 'Action';

-- Write the query using sub queries with multiple WHERE clause and IN condition
    SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email
FROM 
    customer c
WHERE 
    c.customer_id IN (
        SELECT 
            r.customer_id
        FROM 
            rental r
        WHERE 
            r.inventory_id IN (
                SELECT 
                    i.inventory_id
                FROM 
                    inventory i
                WHERE 
                    i.film_id IN (
                        SELECT 
                            fc.film_id
                        FROM 
                            film_category fc
                        JOIN 
                            category cat ON fc.category_id = cat.category_id
                        WHERE 
                            cat.name = 'Action'
                    )
            )
    );
    
    -- Verify if the above two queries produce the same results or not
    
    DROP TEMPORARY TABLE IF EXISTS customer_action_joins;

CREATE TEMPORARY TABLE customer_action_joins AS
SELECT DISTINCT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category cat ON fc.category_id = cat.category_id
WHERE 
    cat.name = 'Action';
    
-- Use the case statement to create a new column classifying existing columns as either or high value transactions 
-- based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is 
-- between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
    
   SELECT
    payment_id,
    customer_id,
    amount,
    CASE
        WHEN amount BETWEEN 0 AND 2 THEN 'low'
        WHEN amount BETWEEN 2 AND 4 THEN 'medium'
        WHEN amount > 4 THEN 'high'
        ELSE 'unknown'  -- Optional, for values that do not fit any category
    END AS value_classification
FROM
    payment;
