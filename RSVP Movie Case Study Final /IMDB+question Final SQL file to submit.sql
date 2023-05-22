USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


select count(*) from genre;

-- Answer: 14662

select count(*) from ratings;

-- Answer: 7997

select count(*) from director_mapping;

-- Answer: 3867

select count(*) from names;

-- Answer: 25735

select count(*) from role_mapping;

-- Answer: 15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select
(select count(*) from movie where id is NULL) as id,
(select count(*) from movie where title is NULL) as title,
(select count(*) from movie where year is NULL) as year,
(select count(*) from movie where date_published is NULL) as date_published,
(select count(*) from movie where duration is NULL) as duration,
(select count(*) from movie where country is NULL) as country,
(select count(*) from movie where worlwide_gross_income is NULL) as worlwide_gross_income,
(select count(*) from movie where languages is NULL) as languages,
(select count(*) from movie where production_company is NULL) as production_company;

-- Answer: id-0  title-0	year-0	date_published-0	duration-0	country-20	worlwide_gross_income-3724	languages-194	production_company-528


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


select year, count(title) as number_of_movies
from movie
group by year;

-- Answer: 2017-3052 (highest), 2018-2944, 2019-2001 --

select month(date_published) as month_num, count(*) as number_of_movies
from movie
group by month_num
order by month_num;

-- Answer: Highest number of movies produced in March and lowest in December--


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(id) as movie_counts
from movie
where year=2019 and (country like '%USA%' or country like '%India%');

-- Answer: Number of movies produced in USA or India in the year 2019 were 1059 --






/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre from genre;

T-- Answer: The unique list of the genres present in the data set are 13 --







/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre, count(movie_id) as number_of_movies
from movie as m
inner join genre as g
on m.id=g.movie_id
group by genre
order by number_of_movies desc;

-- Answer: As we can see highest number of movies produced overall for any genre is Drama --


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select genre_count, count(movie_id) as movie_count
from (select movie_id, count(genre) as genre_count from genre
		group by movie_id
        order by genre_count desc) as genre_counts
where genre_count=1
group by genre_count;

-- Answer: Total 3289 movies are which belong to only one genre --


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select round(avg(duration),2) as avg_duration, genre
from movie as m
inner join genre as g
on m.id=g.movie_id
group by genre
order by avg_duration desc;

-- Answer: Action movies has highest average genre 112.88 whereas Horror movies has lowest average genre 92.72 --


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_summary as
(
 select genre, count(movie_id) as movie_count,
 rank() over(order by count(movie_id) desc) as genre_rank
 from genre
 group by genre
 )
select *
from genre_summary
where genre="Thriller";

-- Answer: Rank of the ‘thriller’ genre of movies is 3 --


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select
		min(avg_rating) as min_avg_rating,
        max(avg_rating) as max_avg_rating,
        min(total_votes) as min_total_votes,
        max(total_votes) as max_total_votes,
        min(median_rating) as min_median_rating,
        max(median_rating) as max_median_rating
from ratings;

-- Answer: max_avg_rating is 1.0, max_total_votes are 725138 , max_median_rating is 10


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select title, avg_rating,
rank() over(order by avg_rating desc) as movie_rank
from ratings as r
inner join movie as m
on r.movie_id=m.id limit 10;

-- Answer: Movies title "Kirket" and "Love in Kilnerry" has maximum average rating with rank as 1 --

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating, count(movie_id) as movie_count
from ratings
group by median_rating
order by movie_count desc;

-- Answer: Movies having Median rating 7 has the highest number of movie_count 2257 --


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, count(title) as movie_count, 
	rank() over(order by count(movie_id) desc) as prod_company_rank
from movie as m
inner join ratings as r
on m.id=r.movie_id
where avg_rating>8
and production_company is not NULL
group by production_company;

-- Answer: Production houses "Dream Warrior Pictures" and "National Theater Live" has maximum number of movie counts with Rank as 1 --


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


select g.genre, count(g.movie_id) as movie_count 
from genre g 
inner join ratings r
on g.movie_id = r.movie_id 
inner join movie m
on g.movie_id = m.id 
where country = 'USA' and r.total_votes > 1000 and month(date_published) = 3 and year(date_published) = 2017 
group by g.genre 
order by movie_count desc;

/* Answer: Below are the movies released in each genre during March 2017 in USA:
Drama	16
Comedy	8
Crime	5
Horror	5
Action	4
Sci-Fi	4
Thriller	4
Romance	3
Fantasy	2
Mystery	2
Family	1
*/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select title, avg_rating, genre
from movie as m
inner join ratings as r
on r.movie_id=m.id
inner join genre as g
on g.movie_id=m.id
where title like "The%"
and avg_rating>8
order by avg_rating desc;

-- Answer: Movie with title "The Brighton Miracle" has the most average rating 9.5 with genre as Drama --


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select median_rating, count(*) as movie_count
from movie as m
inner join ratings as r
on r.movie_id=m.id
where median_rating=8
and date_published between '2018-04-01' and '2019-04-01'
group by median_rating;

-- Answer: Number of Movies with median rating 8 for movies released between 1 April 2018 and 1 April 2019 are 361 --


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select country, sum(total_votes) as total_votes
from movie as m
inner join ratings as r
on m.id=r.movie_id
where lower(country) = "germany" or lower(country) = "italy"
group by country;

-- Answer: German movies get more votes than Italian movies - 106710 in total --


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select  sum(case when name is null then 1 else 0 end) as name_nulls,
		sum(case when height is null then 1 else 0 end) as height_nulls,
        sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
        sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;

/* Answer: 
name_nulls - 0
height_nulls - 17335
date_of_birth_nulls - 13431
known_for_movies_nulls - 15226
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top3_genre
as
(
select
genre,
count(m.id) as movie_count,
rank() over(order by count(m.id) desc) as movie_rank
from movie as m
inner join genre as g
on g.movie_id=m.id
inner join ratings as r
on r.movie_id=m.id
where avg_rating>8
group by genre
limit 3
)
select n.name as director_name,
	count(dm.movie_id) as movie_count
from director_mapping as dm
inner join genre using (movie_id)
inner join names as n
on n.id=dm.name_id
inner join top3_genre using (genre)
inner join ratings using (movie_id)
where avg_rating>8
group by name
order by movie_count desc limit 3;



/* Answer: Yop three directors in the top three genres whose movies have an average rating > 8 are as below:
James Mangold
Anthony Russo
Soubin Shahir
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


select * from role_mapping;
select
n.name as actor_name,
count(rm.movie_id) as movie_count
from role_mapping rm
inner join names n
on n.id = rm.name_id
inner join ratings r
on r.movie_id = rm.movie_id
where category="actor"
and r.median_rating >= 8
group by n.name
order by movie_count desc
limit 2;

-- Answer: Top two actors whose movies have a median rating >= 8 are Mammootty and Mohanlal --


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, sum(total_votes) as vote_count,
rank() over(order by sum(total_votes) desc) as prod_comp_rank
from movie as m
inner join ratings as r
on r.movie_id=m.id
group by production_company
limit 3;


/* Answer: Top three production houses based on the number of votes received by their movies are:
Marvel Studios - 2656967
Twentieth Century Fox - 2411163
Warner Bros. - 2396057



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select
n.name as actor_name,
SUM(r.total_votes) as total_votes,
COUNT(r.movie_id) as movie_count,
ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) as actor_avg_rating, 
rank() over(order by ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) desc) as  actor_rank
from names n
inner join role_mapping rm
on n.id = rm.name_id
inner join ratings r
on rm.movie_id = r.movie_id
inner join movie m
on m.id = r.movie_id
where rm.category="actor" and m.country="India"
group by n.id
having COUNT(r.movie_id) >= 5;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


select 
n.name as actor_name,
SUM(r.total_votes) as total_votes,
COUNT(m.id) as  movie_count,
ROUND(SUM(avg_rating * total_votes)/SUM(total_votes), 2) as actress_avg_rating, 
rank() over(order by ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) desc) as actress_rank
from names n
inner join role_mapping rm
on n.id = rm.name_id
inner join movie m
on rm.movie_id = m.id
inner join ratings r
on m.id = r.movie_id
where rm.category = "ACTRESS" and m.languages like "%Hindi%" and  m.country = "INDIA"
group by n.id, actor_name
having COUNT(m.id) >= 3
limit 5;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

with thriller_movie as
(
select distinct title, avg_rating
from movie as m
inner join ratings as r
on m.id=r.movie_id
inner join genre as g
on g.movie_id=m.id
where genre like 'THRILLER')
select *,
	case
    when avg_rating > 8 then 'superhit movies'
    when avg_rating between 7 and 8 then 'Hit movies'
    when avg_rating between 5 and 7 then 'One-time-watch movies'
    else 'Flop movies'
    end as avg_rating_category
from thriller_movie;


-- Answer: Thriller movie title Abstruse have best average rating of 9.0 in superhit movie--




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select genre,
round(avg(duration),2) as avg_duration,
sum(round(avg(duration),2)) over(order by genre rows unbounded preceding) as running_total_duration,
round(avg(avg(duration)) over(order by genre rows 10 preceding),2) as moving_avg_duration
from movie as m
inner join genre as g
on m.id=g.movie_id
group by genre
order by genre;


/* Answer: Best genre is Action:
Action	112.88	112.88	112.88
*/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top3_genre
AS
(
SELECT
genre,
COUNT(movie_id) as movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
),
top5_movie
AS
(
SELECT
genre,
year,
title as movie_name,
worlwide_gross_income,
DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
WHERE genre IN(SELECT genre FROM top3_genre)
)
SELECT *
FROM top5_movie
WHERE movie_rank<=5;


/* Answer: Five highest-grossing movies of each year that belong to the top three genres are below:
Drama	2017	Shatamanam Bhavati	INR 530500000	1
Drama	2017	Winner	INR 250000000	2
Drama	2017	Thank You for Your Service	$ 9995692	3
Comedy	2017	The Healer	$ 9979800	4
Drama	2017	The Healer	$ 9979800	4
Thriller	2017	Gi-eok-ui bam	$ 9968972	5
Thriller	2018	The Villain	INR 1300000000	1
Drama	2018	Antony & Cleopatra	$ 998079	2
Comedy	2018	La fuitina sbagliata	$ 992070	3
Drama	2018	Zaba	$ 991	4
Comedy	2018	Gung-hab	$ 9899017	5
Thriller	2019	Prescience	$ 9956	1
Thriller	2019	Joker	$ 995064593	2
Drama	2019	Joker	$ 995064593	2
Comedy	2019	Eaten by Lions	$ 99276	3
Comedy	2019	Friend Zone	$ 9894885	4
Drama	2019	Nur eine Frau	$ 9884	5
*/




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


Select
production_company,
COUNT(id) as movie_count,
ROW_NUMBER() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE median_rating>=8
AND production_company IS NOT NULL
AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;


/* Answer: top two production houses that have produced the highest number of hits among multilingual movies are
Star Cinema
Twentieth Century Fox
*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


select name as actress_name, SUM(total_votes) as total_votes, COUNT(rm.movie_id) as movie_id, 
Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) as actress_avg_rating,
RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank
FROM names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN ratings r
ON r.movie_id = rm.movie_id
INNER JOIN genre g
ON g.movie_id = r.movie_id
WHERE category="actress" AND avg_rating>8 AND g.genre="Drama"
GROUP BY name
LIMIT 3;

/* Answer: Top 3 actresses based on number of Super Hit movies in Drama genre are:
Parvathy Thiruvothu
Susan Brown
Amanda Lawrence
*/


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH ctf_date_summary AS
(
SELECT d.name_id,
NAME,
d.movie_id,
duration,
r.avg_rating,
total_votes,
m.date_published,
Lead(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
FROM director_mapping AS d
INNER JOIN names AS n ON n.id = d.name_id
INNER JOIN movie AS m ON m.id = d.movie_id
INNER JOIN ratings AS r ON r.movie_id = m.id ),
top_director_summary AS
(
SELECT *,
Datediff(next_date_published, date_published) AS date_difference
FROM ctf_date_summary
)
SELECT name_id AS director_id,
NAME AS director_name,
COUNT(movie_id) AS number_of_movies,
ROUND(AVG(date_difference),2) AS avg_inter_movie_days,
ROUND(AVG(avg_rating),2) AS avg_rating,
SUM(total_votes) AS total_votes,
MIN(avg_rating) AS min_rating,
MAX(avg_rating) AS max_rating,
SUM(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC
limit 9;


/* Answer: Details for top 9 directors (based on number of movies) are as below:
nm2096009	Andrew Jones	5	190.75	3.02	1989	2.7	3.2	432
nm1777967	A.L. Vijay	5	176.75	5.42	1754	3.7	6.9	613
nm0814469	Sion Sono	4	331.00	6.03	2972	5.4	6.4	502
nm0831321	Chris Stokes	4	198.33	4.33	3664	4.0	4.6	352
nm0515005	Sam Liu	4	260.33	6.23	28557	5.8	6.7	312
nm0001752	Steven Soderbergh	4	254.33	6.48	171684	6.2	7.0	401
nm0425364	Jesse V. Johnson	4	299.00	5.45	14778	4.2	6.5	383
nm2691863	Justin Price	4	315.00	4.50	5343	3.0	5.8	346
nm6356309	Özgür Bakar	4	112.00	3.75	1092	3.1	4.9	374
*/

