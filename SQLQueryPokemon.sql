

--Total of each type

Select 
	[Type 1],
	Count([Type 1]) as CountType,
	CAST((CAST(Count([Type 1])*100 AS decimal(10,2))/(Select CAST(Count(*) AS decimal(10,2)) 
	From PokemonProject..Pokemon)) AS decimal(10,2)) as PercentageOfTotal
FROM PokemonProject..Pokemon
GROUP BY [Type 1]
ORDER BY PercentageOfTotal DESC

--top 5 strongest

SELECT TOP(5) *
FROM PokemonProject..Pokemon
--WHERE Legendary <> 1 and [Name] not like '%mega%'
ORDER BY Total desc

--Top 3 of each type

WITH cte_ranking_all AS 
(
    SELECT 
     [Name], 
     [Type 1],
     Total,
	 Hp,
	 Attack,
	 Defense,
	 Speed,
     rank() OVER(partition by [Type 1] order by Total desc ,Hp desc,Attack desc ,Defense desc,Speed desc,# desc) AS Ranking
    FROM PokemonProject..Pokemon
)    
 SELECT *
 FROM cte_ranking_all
 WHERE Ranking <= 3

 --Total by generation

Select 
	Generation,
	Count(Generation) as CountGeneration,
	CAST((CAST(Count(Generation)*100 AS decimal(10,2))/(Select CAST(Count(*) AS decimal(10,2)) 
	From PokemonProject..Pokemon)) AS decimal(10,2)) as PercentageOfTotal
FROM PokemonProject..Pokemon
GROUP BY Generation
ORDER BY PercentageOfTotal DESC

--Ranking by generation

WITH cte_ranking_gen AS 
(
    SELECT 
     [Name], 
     [Type 1],
     Total,
	 Hp,
	 Attack,
	 Defense,
	 Speed,
	 Generation,
     rank() OVER(partition by Generation order by Total desc ,Hp desc,Attack desc ,Defense desc,Speed desc,# desc) AS Ranking
    FROM PokemonProject..Pokemon
)    
 SELECT *
 FROM cte_ranking_gen
 WHERE Ranking <= 3

 --Strongest
 WITH cte_strongest_Gen AS 
(
    SELECT 
     [Name], 
     [Type 1],
     Total,
	 Hp,
	 Attack,
	 Defense,
	 Speed,
	 Generation,
     rank() OVER(partition by Generation order by Total desc ,Hp desc,Attack desc ,Defense desc,Speed desc,# desc) AS Ranking
    FROM PokemonProject..Pokemon
)    
 SELECT *
 FROM cte_strongest_Gen
 WHERE Ranking <= 1

 --Total by Type
 
 SELECT [Type 1], 
		Generation, 
		COUNT([Type 1]) as CountGen,
		CAST((CAST(Count([Type 1])*100 AS decimal(10,2))/(Select CAST(Count(*) AS decimal(10,2)) 
		From PokemonProject..Pokemon WHERE [Type 1] = 'Electric')) AS decimal(10,2)) as PercentageOfTotal
 FROM PokemonProject..Pokemon
 WHERE [Type 1] = 'Electric'
 GROUP BY [Type 1], Generation
 ORDER BY [Type 1]

 --Total legendaries

 SELECT Legendary, 
		count(Legendary) as count_of_total, 
		CAST((CAST(Count(Legendary)*100 AS decimal(10,2))/(Select CAST(Count(*) AS decimal(10,2)) 
	From PokemonProject..Pokemon)) AS decimal(10,2)) as PercentageOfTotal
 FROM PokemonProject..Pokemon
 GROUP BY Legendary

 --Max HP Min HP
 SELECT [Name], [Type 1], [Type 2], MAX(HP)
 FROM PokemonProject..Pokemon
 group by MAX(HP)

SELECT (select MAX(HP) as maxim, [Name]  from PokemonProject..Pokemon)
from PokemonProject..Pokemon pp
GROUP BY [Name]



