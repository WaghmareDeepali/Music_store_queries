Q1.who is senior most employee based on job title?

select * from employee;

select * from employee 
order by levels desc
limit 1;


Q2) which counteries have the most invoices?

select * from invoice;

select count(*) as c,billing_country 
from invoice
group by billing_country
order by c desc;

Q3)what are the top 3 values of invoices?

select total from invoice
order by total desc
limit 3;


Q4)which city has the best customers?we would like to throw promotional music festival in the city 
we made the most money write a query that returns one city we made the highest sum of invoice totals
return one city that has the heighest sum of invoice totals 
return both the city name and sum of all invoice totals


select sum(total) as invoice_total,billing_city 
from invoice
group by billing_city
order by invoice_total  desc;


Q5)Who is the best customer? the customer who has spent the most 
money will be declared the best customer.
write a query that returns the persons who has spent the most money 

select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total) as total
from customer 
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1;



set 2:Moderate

Q1)write a query to return the email,first name,last name,
& genre of all rock music listeners, return
your list ordered alphabetically by email starting with A


select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in(
	select track_id from track 
	join genre on track.genre_id=genre.genre_id 
	where genre.name like 'Rock')
order by email;


Q2): lets invite the artists who have written  the most rock music
in our dataset.write a query that returns the artist name and 
total count of the 10 rocks bands

select artist.artist_id,artist.name,count(artist.artist_id)as number_of_songs
from track 
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;


Q3) Return all the track names that have a song lenght longer than
the average song length.return the name and milliseconds for 
each track.order by the song lenght with the longest songs listed
first

select name,milliseconds
from track
where milliseconds>(
	select avg(milliseconds) as avg_track_length
	from track)
order by milliseconds desc;



----------------Advance level query -------------

Q1)Find how much amount spent by each customers on artists?
write a query to return customers name,
---artists name and total spent

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres.

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1






