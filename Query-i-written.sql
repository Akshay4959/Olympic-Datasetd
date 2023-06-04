use olympic;
SELECT * FROM atheletic_event;
-- How many olympics games have been held?
select count(distinct(games)) from atheletic_event;

-- List down all Olympics games held so far?
select distinct(games) from atheletic_event;

-- Mention the total no of nations who participated in each olympics game?
select count(distinct(noc)) from atheletic_event;

-- Which year saw the highest and lowest no of countries participating in olympics?

-- Which nation has participated in all of the olympic games?
    with tot_games as
              (select count(distinct games) as total_games
              from atheletic_event),
          countries as
              (select games, nr.region as country
              from atheletic_event oh
              join noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          countries_participated as
              (select country, count(1) as total_participated_games
              from countries
              group by country)
      select cp.*
      from countries_participated cp
      join tot_games tg on tg.total_games = cp.total_participated_games
      order by 1;

with total_games as
(select count(distinct games) as total_games from atheletic_event),
contries as 
(select games,nr.region as country 
from atheletic_event
join noc_regions as nr on nr.noc = oh.noc
group by games, nr.region),
contries_participated as 
(select country, count(1) as total_participated_games
from contries
group by country)
select cp.* from countries_participated cp
join total_games tg on tg.total_games = cp.total_participated_games
order by 1;

select * from atheletic_event;
   select distinct oh.year,oh.season,oh.city
    from olympics_history oh
    order by year;
select distinct oh.year,oh.season from atheletic_event oh
order by year;

select * from noc_regions;
alter table noc_regions 
drop column ï»¿;

-- 3. Mention the total no of nations who participated in each olympics game?
    
with all_contires as 
    (select games, nr.region from atheletic_event as oh
	join noc_regions as nr on nr.noc = oh.noc
    group by games, nr.region)
select games, count(1) as total_countries
from all_contires
group by games
order by games desc;

-- 4.Which year saw the highest and lowest no of countries participating in olympics

      with all_contries as 
			  (select games, nr.region from atheletic_event as oh
			  inner join noc_regions as nr on nr.noc=oh.noc
			  group by games, nr.region),
		   total_contries as 
			  (select games, count(1) as total_contries from all_contries
			  group by games)
	select distinct
    concat(first_value(games) over(order by total_contries)
    ,' - '
    , first_value(total_contries) over(order by total_contries)) as Lowest_Contries,
    
    concat(first_value(games) over(order by total_contries desc)
    ,' - '
    , first_value(total_contries) over(order by total_contries desc)) as Highest_Contries
    from total_contries
    order by 1;
    
-- 5. Which nation has participated in all of the olympic games

select * from atheletic_event;
with total_games as
(select count(distinct(games)) as total_games from atheletic_event),
contries as
(select games, nr.region as country from atheletic_event oh
inner join noc_regions nr on nr.noc = oh.noc
group by games, nr.region),
parti_con as
(select country, count(1) as total_parti_games
from contries
group by country)
select cp.*
from parti_con cp
join total_games tg on tg.total_games = cp.total_parti_games
order by 1;

-- 6. Identify the sport which was played in all summer olympics.

with t1 as 
(select count(distinct games) as total_games from atheletic_event
where season = 'Summer'),
t2 as 
(select distinct sport, games from atheletic_event 
where season = 'Summer'),
t3 as 
(select sport, count(1) as no_of_games from t2
group by sport)
select * 
from t3
join t1 on t1.total_games = t3.no_of_games;

-- 7.Which Sports were just played only once in the olympics.

with t1 as
(select distinct sport, games from atheletic_event),
t2 as 
(select sport ,count(1) as no_of_games from t1 
group by sport)
select t2.*,t1.games from t2
join t1 on t1.sport = t2.sport
where t2.no_of_games = 1
order by t1.sport;

-- 8. Fetch the total no of sports played in each olympic games.
with t1 as
(select distinct sport, games from atheletic_event),
t2 as 
(select games, count(1) as no_sport_count from t1
group by games)
select * from t2
order by no_sport_count;

-- 9. Fetch oldest athletes to win a gold medal
with t1 as 
(select * from atheletic_event),
t2 as 
(select *, rank() over(order by age desc) as rnk from t1 
where medal_ = "GOld")
select * from t2
where rnk = 1;

-- 10. Find the Ratio of male and female athletes participated in all olympic games.

with t1 as 
(select sex,count(1) as cnt from atheletic_event
group by sex),
t2 as
(select *, row_number() over(order by cnt) as rn from t1),
min_cnt as
(select cnt from t2 where rn = 1),
max_cnt as 
(select cnt from t2 where rn = 2)
select concat('1 : ', round(max_cnt.cnt/min_cnt.cnt, 2)) as ratio
from min_cnt, max_cnt;

-- 11. Fetch the top 5 athletes who have won the most gold medals.
with t1 as
(select name, team,count(1) as total_gold_medal from atheletic_event
where medal_ ="Gold"
group by name,team
order by total_gold_medal desc),
t2 as 
(select *, dense_rank() over(order by total_gold_medal desc) as rnk
from t1)
select name,team,total_gold_medal from t2
where rnk <=5;

-- 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

with t1 as 
(select name ,team,count(1) as total_medals from atheletic_event
where medal_ in ("Gold","Silver","Bronze")
group by name,team
order by total_medals desc),
t2 as 
(select *, dense_rank() over(order by total_medals desc) as rnk from t1)
select name,team,total_medals from t2
where rnk <=5;

-- 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
with t1 as
(select noc, team,count(1) as total_medals from atheletic_event
where medal_ in ("Gold","Silver","Bronze")
group by team, noc
order by total_medals),
t2 as 
(select *, dense_rank() over(order by total_medals desc) as rnk from t1)
select noc,total_medals from t2 
where rnk <= 5;




      
    
    

    
    


            
    



 










      







