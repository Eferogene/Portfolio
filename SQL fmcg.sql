select* from fmcg;

--1 Brewery profit in the last 3 years
select sum(profit) AS total_profit
from fmcg;

--2. Comparing profits between Anglophone and Francophone territories
select sum(profit) AS total_profit_anglophone
from fmcg
where countries = 'Ghana' or countries =  'Nigeria';


select sum(profit) AS total_profit_francophone
from fmcg
where countries = 'Togo' or countries = 'Benin' or countries = 'Senegal';

--3. Country that generated the highest profit in 2019

select countries, sum(profit) as profit_2019
from fmcg
where year = '2019'
Group by countries
order by sum(profit) desc
limit 1;

--4. Year with the highest profit 

select year, sum(profit)
from fmcg
group by year
order by sum(profit)desc
limit 1;

--5. month in the three years with the least profit generated

select sum(profit), month
from fmcg
group by month
order by sum(profit)asc
limit 1;

--specific month with the least profit
select sum(profit), month, year
from fmcg
group by month, year
order by sum(profit)asc
limit 1;

--6. Minimum profit in the month of december 2018
select profit --, month, year
from fmcg
where month ='December' and year= '2018'
order by profit asc
limit 1;


--7. Percentage profit for each month in 2019


--8.Brand that  generated the highest profit in Senegal
select brands, sum(profit) as total_profit
from fmcg
where countries = 'Senegal'
group by brands
order by sum(profit) desc
limit 1;

--9. Profit over the month
select month, year, sum(profit) as profit
from fmcg
group by month,year
order by year

--10. Top 3 brands consumed in francophone countries within the last 2 years
select brands, sum(quantity) as Total_qty
from fmcg
where countries = 'Togo' or countries = 'Benin' or countries = 'Senegal'
and year > 2017
group by brands
order by sum(quantity);

--11. The top two choices of consumer brands in Ghana.
select brands, sum(quantity) as Total_qty
from fmcg
where countries = 'Ghana'
group by brands
order by sum(quantity) desc
LIMIT 2;

--12. Beers consumed in the past three years in the most oil reached country in West Africa (Nigeria). 

select brands, unit_price, region,  sum(quantity) as quantity_consumed
from fmcg
where countries = 'Nigeria'
group by brands, region, unit_price
order by brands

--13. Favorites malt brand in Anglophone region between 2018 and 2019

select brands, sum(quantity) as quantity_consumed
from fmcg
Where countries = 'Ghana' or countries =  'Nigeria'
group by brands
having brands like '%malt';

--14. Brands that sold the highest in 2019 in Nigeria
select brands, sum(quantity) as quantity_sold
from fmcg
Where countries =  'Nigeria' and year = '2019'
group by brands
order by sum(quantity) desc;

--15. Favorite brands in South-South region in Nigeria
select brands, sum(quantity) as quantity_sold
from fmcg
Where countries =  'Nigeria' and region ='southsouth'
group by brands
order by sum(quantity)desc

-- 16. Beer consumption in Nigeria.

select region, brands,  sum(quantity) as quantity_sold, sum(profit) as profit ,year
from fmcg
Where countries = 'Nigeria'
group by brands, region, year
order by year, region;

--17.. Level of consumption of Budweiser in the regions in Nigeria

select region, sum(quantity) as quantity_consumed
from fmcg
Where countries = 'Nigeria' and brands = 'budweiser'
group by region
order by sum(quantity);

--18. Level of consumption of Budweiser in the regions in Nigeria in 2019

select region, sum(quantity) as quantity_consumed
from fmcg
Where countries = 'Nigeria' and brands = 'budweiser' and year = '2019'
group by region
order by sum(quantity);

--19. Country with the highest consumption of beer

select countries, sum(quantity) as quantity_consumed
from fmcg
where brands = 'trophy' or brands = 'budweiser' or brands = 'castle lite' or brands = 'eagle lager' or brands = 'hero'
group by countries
order by sum(quantity)
limit 1;

--20. Highest sales personnel of Budweiser in Senegal 

select sales_rep, sum(cost) as Total_sales_in_Senegal
from fmcg
where countries = 'Senegal'
and brands ='budweiser'
group by sales_rep
order by sum(cost) desc
Limit 1;

--21. Country with the highest profit of the fourth quarter in 2019 

select countries, sum(profit) as profit
from fmcg
where month = 'October' or month = 'November' or month = 'December'
group by countries, year
having year ='2019'
order by sum(profit) desc
limit 1;






