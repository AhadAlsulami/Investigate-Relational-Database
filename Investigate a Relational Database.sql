/*Query 1 - query used for the first insight
Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.*/

SELECT f.title AS film_title, c.name AS category_name, COUNT(r.rental_id) AS rental_count
 FROM film f
JOIN film_category fc
 ON f.film_id = fc.film_id 
JOIN category c
 ON fc.category_id = c.category_id
JOIN inventory i
 ON f.film_id = i.film_id
JOIN rental r
 ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1,2
ORDER BY 2;




/*Query 2 - query used for the second insight 
Provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories*/

SELECT f.title, sub.name, f.rental_duration, NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
 FROM (
	SELECT c.name, c.category_id 
	 FROM category c 
	 WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music') 
	 ORDER BY 1) sub
JOIN film_category fc 
 ON fc.category_id = sub.category_id
JOIN film f
 ON f.film_id = fc.film_id
GROUP BY 1,2,3;




/*Query 3 - query used for the third insight 
Provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category.*/

SELECT sub.name, sub.standard_quartile, count(sub.standard_quartile)
FROM (
	SELECT f.title, c.name, f.rental_duration, NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
	 FROM category c
	JOIN film_category fc
       ON fc.category_id = c.category_id
      JOIN film f
       ON f.film_id = fc.film_id
      WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) sub
GROUP BY 1,2
ORDER BY 1,2,3 DESC;




/*Query 4 - query used for the fourth insight 
Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month.*/

SELECT DATE_PART('month', r.rental_date) Rental_month, DATE_PART('year', r.rental_date) Rental_year, s.store_id, COUNT(*)
 FROM rental r
JOIN staff s
 ON s.staff_id = r.staff_id
GROUP BY 1,2,3
ORDER BY 4 DESC; 
