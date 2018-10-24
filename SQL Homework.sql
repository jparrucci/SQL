use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select *
from actor
where first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select *
from actor
where last_name LIKE '%LI%'
ORDER BY last_name, first_name; 

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh','China');

-- 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, so create a column in the table 
-- actor named description and use the data type BLOB (Make sure to research the type BLOB, 
-- as the difference between it and VARCHAR are significant).

ALTER TABLE actor 
ADD COLUMN Description BLOB AFTER last_name;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP COLUMN Description 
SELECT * FROM actor

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS 'Total of last names'  
FROM actor
GROUP BY last_name 

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS 'Totals' 
FROM actor
GROUP BY last_name
having COUNT(last_name) >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
SELECT *
FROM actor
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS'

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS'

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS'

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SHOW CREATE TABLE address

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT first_name, last_name, address
FROM staff
JOIN address ON 
address.address_id = staff.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT first_name, last_name, amount
FROM staff
JOIN payment ON
staff.staff_id = payment.staff_id
WHERE MONTH(payment.payment_date) = 08 and YEAR(payment.payment_date) = 2005
GROUP BY staff.staff_id; 

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT title, COUNT(actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT title, COUNT(inventory_id)
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible'
GROUP by film.title;

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount) 
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP by customer.customer_id
ORDER BY customer.last_name; 

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE title LIKE 'K%' 
OR title LIKE 'Q%'
AND language_id  IN
(
	select language_id
    from language
    where name = 'English'
);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN(
	
    Select actor_id
    FROM film_actor
    WHERE film_id = 
    (
    Select film_id
    FROM film
    WHERE title = 'Alone Trip'));
    
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email 
-- addresses of all Canadian customers. Use joins to retrieve this information.

SELECT first_name, last_name, email
FROM customer
INNER JOIN address ON address.address_id = customer.address_id
INNER JOIN city ON city.city_id = address.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country = 'Canada'; 

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT title
FROM film 
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE name = 'Family';
 

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(title) AS 'Totals' 
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY Totals DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) AS 'Store_Total'
FROM store s
INNER JOIN inventory i
ON i.store_id = s.store_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
INNER JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT store_id, city, country
FROM store s
INNER JOIN address a 
ON s.address_id = a.address_id
INNER JOIN city c
ON a.city_id = c.city_id
INNER JOIN country co 
ON c.country_id = co.country_id;


-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name, SUM(amount) AS 'Gross_Revenue' 
FROM category c 
INNER JOIN film_category f
ON f.category_id = c.category_id
INNER JOIN inventory i
ON i.film_id = f.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY Gross_Revenue DESC LIMIT 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the 
-- Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW Gross_Revenue AS 
SELECT name, SUM(amount) AS 'Gross_Revenue' 
FROM category c 
INNER JOIN film_category f
ON f.category_id = c.category_id
INNER JOIN inventory i
ON i.film_id = f.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY Gross_Revenue DESC LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM sakila.gross_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
    
DROP VIEW sakila.gross_revenue;













 












