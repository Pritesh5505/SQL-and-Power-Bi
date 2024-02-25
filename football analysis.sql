use football_db;	

alter table players
add column age int;

update players
set age = timestampdiff(year, date_of_birth, curdate())
where date_of_birth is not null;

SELECT position, age, name
FROM (
    SELECT position, age, name,
        ROW_NUMBER() OVER (PARTITION BY position ORDER BY age DESC) AS rn
    FROM players) AS ranked_players
WHERE rn = 1 and position is not null and age is not null;

select distinct player_name, sum(goals) as toatl_goals, sum(assists), sum(minutes_played) from apperance
WHERE player_name IS NOT NULL AND player_name <> ''  
group by player_name
order by sum(goals) desc
limit 5;

SELECT home_club_name, SUM(home_club_goals) as total_goals, sum(away_club_goals) AS total_away_goals 
FROM games 
WHERE home_club_name IS NOT NULL AND home_club_name <> '' 
GROUP BY home_club_name 
ORDER BY total_goals DESC 
LIMIT 5;

select distinct p.name ,pv.market_value_in_eur, pv.player_id from player_valuations pv
join players p on pv.player_id=p.player_id
order by pv.market_value_in_eur desc
limit 10;

select own_manager_name, sum(own_goals)as total_goals, sum(is_win) as total_winning,
sum(case when is_win = 0 then 1 else 0 end) as total_loss from club_games
where own_manager_name is not null and own_manager_name <> '' 
group by own_manager_name
order by total_goals desc
limit 5;

select player_name, sum(yellow_cards) as total_yellow, sum(red_cards) as total_red 
from apperance 
group by player_name
order by total_yellow desc
limit 5;

select a.player_name, 
 sum(a.yellow_cards) as total_yellow,
 sum(a.red_cards) as total_red, 
 sum(a.minutes_played) as total_min_played,
 max(p.position) from apperance a
join players p on a.player_name = p.name
where minutes_played > 5 and position not like 'Goalkeeper'
group by player_name
order by total_yellow asc, total_min_played desc
limit 5;
