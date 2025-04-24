-- BBDD PROYECTO

-- Tabla Film

SELECT  *
FROM "film";

-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’

SELECT  "film_id", 
		"title" 
FROM "film"
WHERE "rating" = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

SELECT * 
FROM "actor"
WHERE "actor_id" BETWEEN '30' AND '40';

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.

SELECT *
FROM "film" ;

SELECT "film_id",
		"title" ,
		"language_id" , 
		"original_language_id" 
FROM "film"
WHERE "language_id" = "original_language_id" ;


-- 5. Ordena las películas por duración de forma ascendente.

SELECT "film_id" ,
		"title",
		"length" 
FROM "film" 
ORDER BY "length";


-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.


SELECT "first_name",
		"last_name" 
FROM "actor"
WHERE "last_name" = 'ALLEN'
ORDER BY "last_name";

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.


SELECT count("film_id") AS "Total_peliculas",
		"rating"
FROM "film"
GROUP BY "rating";


-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.

SELECT "film_id", 
		"title"
FROM "film"
WHERE "rating" = 'PG-13' OR "length" >'120';

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.


SELECT ROUND(AVG("replacement_cost"), 2) AS "promedio del coste de reeplazo" 
FROM "film";

SELECT ROUND(STDDEV("replacement_cost"),2) AS "desviacion del coste de reemplazo" 
FROM "film";

SELECT ROUND(VARIANCE("replacement_cost"),2) AS "varianza del coste de reemplazo" 
FROM "film";




-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

SELECT "length" 
FROM "film" 
ORDER BY "length";

SELECT min("length") AS "pelicula_min_duracion", 
	   max("length") AS "pelicula_max_duracion"
FROM "film";


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT "rental_id",
       "customer_id",
       "amount",
       "payment_date",
       EXTRACT(DAY FROM "payment_date") AS "dia_pago"
FROM "payment" AS p
WHERE p."payment_date" = (

    SELECT MAX(p1."payment_date")
    FROM "payment" AS p1
    WHERE p1."payment_date" < (
    
        SELECT MAX(p3."payment_date")
        FROM "payment" AS p3
        WHERE p3."payment_date" < (
        
            SELECT MAX(p4."payment_date")
            FROM "payment" AS p4
        )
    )
);


--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.

SELECT "title", 
		"rating"
FROM "film"
WHERE "rating" NOT IN ('NC-17','G');
 
-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT "rating",
		ROUND(AVG(length),2) AS "duración_media"
FROM "film"
GROUP BY "rating";

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT "title"
FROM "film"
WHERE "length" >'180';


--15. ¿Cuánto dinero ha generado en total la empresa?

SELECT SUM("amount") AS "Total_generado"
FROM "payment";

-- 16. Muestra los 10 clientes con mayor valor de id.

SELECT "customer_id",
		"first_name",
		"last_name"
FROM customer
ORDER BY "customer_id" DESC
LIMIT 10;


-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título “Egg Igby”.


SELECT a."first_name",
	   a."last_name"
FROM "actor" a
INNER JOIN 
	"film_actor" fa ON a."actor_id" = fa."actor_id"
INNER JOIN
	"film" f  ON fa."film_id" = f."film_id"
	WHERE f."title" = 'EGG IGBY';


-- 18. Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT "title" 
FROM film f 

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.


SELECT f."title"
FROM "film" f
INNER JOIN
	"film_category" fc ON f."film_id" = fc."film_id"
INNER JOIN 
	"category" c ON fc."category_id" = c."category_id"
	WHERE c."name" = 'Comedy' AND f."length" > 180;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría
---    junto con el promedio de duración.

SELECT c."name" AS "categoría",
		AVG(f."length") AS "duración media"
FROM "category" c
INNER JOIN 
	"film_category" fc ON c."category_id" = fc."category_id"
INNER JOIN 
	"film" f ON fc."film_id" = f."film_id"
	GROUP BY c."name"
	HAVING ROUND(AVG(f."length"),2) > 110;


-- 21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT ROUND(AVG("rental_duration"),2) AS "promedio alquiler"
FROM "film";


-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT CONCAT("first_name",' ', "last_name") AS "Actor/Actriz"
FROM "actor"
ORDER BY "first_name";

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT EXTRACT(DAY FROM "rental_date") AS "dia",
	   COUNT(*) AS "numero_alquileres"		
FROM "rental"
GROUP BY "dia"
ORDER BY "dia" DESC;

 
 -- 24. Encuentra las películas con una duración superior al promedio.
 
 SELECT "film_id",
 	    "title",
 	    "length"
 FROM film f 
 WHERE "length" > (
 	SELECT AVG("length") 
    FROM "film"
    );
 
 -- 25. Averigua el número de alquileres registrados por mes.
 
 SELECT EXTRACT(MONTH FROM "rental_date") AS "MES",
	   COUNT(*) AS "numero_alquileres"		
FROM "rental"
GROUP BY "MES"
ORDER BY "MES" DESC;

 
 -- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
 

SELECT 
    AVG("amount") AS "promedio",
    STDDEV("amount") AS "desviacion_estandar",
    VARIANCE("amount") AS "varianza"
FROM "payment";
 

-- 27. ¿Qué películas se alquilan por encima del precio medio?

SELECT DISTINCT f.film_id, f."title"
FROM "film" AS f
INNER JOIN 
	"inventory" AS i ON f."film_id"=i."film_id"
INNER JOIN 
	"rental" AS r ON i."inventory_id"=r."inventory_id"
	WHERE "rental_rate" > 
	
		(SELECT AVG("rental_rate") FROM "film")
		
GROUP BY f."film_id";


-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.

SELECT  "actor_id"
FROM "film_actor"
GROUP BY "actor_id"
HAVING COUNT("film_id") > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.


SELECT 
    f."title",
    COUNT(i."inventory_id") AS cantidad_disponible
FROM 
    "film" AS f
LEFT JOIN 
    "inventory" AS i ON f."film_id" = i."film_id"
GROUP BY 
    f."title"
ORDER BY 
    f."title";

-- 30. Obtener los actores y el número de películas en las que ha actuado.

SELECT CONCAT(a."first_name",' ', a."last_name") AS "Actor/Actriz",
		COUNT(f."film_id")
FROM "actor" AS a
INNER JOIN
	"film_actor" AS fa ON a."actor_id" = fa."actor_id"
INNER JOIN 
	film AS f ON fa."film_id" = f."film_id"
GROUP BY 
	a."first_name",
	a."last_name";


--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

SELECT  fa."film_id",
		f."title",
		a."actor_id",
		CONCAT(a."first_name",' ', a."last_name") AS "Actor/Actriz" 
FROM "actor" AS a
RIGHT JOIN 
	"film_actor" AS fa ON a."actor_id" = fa."actor_id"
RIGHT JOIN 
	"film" AS f ON fa."film_id" = f."film_id"
ORDER BY "film_id";


-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.


SELECT  a."actor_id",
		CONCAT(a."first_name",' ', a."last_name") AS "Actor/Actriz" ,
		f."film_id",
		f."title"
FROM "actor" AS a
LEFT JOIN
	"film_actor" AS fa ON a."actor_id" = fa."actor_id"
LEFT JOIN 
	"film" AS f ON fa."film_id" = f."film_id"
ORDER BY "actor_id";


--33. Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT f."film_id",
	   f."title",
	   r."rental_id"  
FROM "rental" AS r
INNER JOIN
	"inventory" AS i ON r."inventory_id" = i."inventory_id"
INNER JOIN
	"film" AS f ON i."film_id" = f."film_id";


-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT c."customer_id", 
		SUM("amount") AS "total_gastado"
FROM "customer" c 
INNER JOIN
	"payment" AS p ON c."customer_id" = p."customer_id"
GROUP BY c."customer_id"
ORDER BY "total_gastado" DESC
LIMIT 5;


--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT *
FROM "actor"
WHERE "first_name" = 'JOHNNY';

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

SELECT "first_name" AS "Nombre",
		"last_name" AS "Apellido"
FROM "actor";

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT MAX("actor_id") AS "Mayor actor_id" ,
	   MIN("actor_id") AS "Menor actor_id"
FROM "actor";


--38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT *
FROM actor a 

SELECT COUNT(*)
FROM "actor";

-- NOMBRES DISTINTOS:
SELECT COUNT(DISTINCT("first_name"))
FROM "actor";

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT "actor_id",
		"first_name" AS "Nombre", 
		"last_name" AS "Apellido" 
FROM "actor"
ORDER BY "Apellido";


--40. Selecciona las primeras 5 películas de la tabla “film”.


SELECT "film_id",
		"title" 
FROM "film"
LIMIT 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre.

SELECT "first_name",
		COUNT(*) AS "num de repes"
FROM "actor" 
GROUP BY "first_name"
ORDER BY "num de repes" DESC;

-- ¿Cuál es el nombre más repetido?

SELECT "first_name",
		COUNT(*) AS "nombre más repetido"
FROM "actor"
GROUP BY "first_name"
ORDER BY "nombre más repetido" DESC
LIMIT 3;


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
-- aqui es sacar cada rental_id con el cliente correspondiente

SELECT r."rental_id", 
		r."customer_id",
		c."first_name",
		c."last_name"
FROM "rental" AS r
INNER JOIN
		"customer" AS c ON r."customer_id" = c."customer_id"
	GROUP BY r."rental_id",
		 r."customer_id",
		 c."first_name",
		 c."last_name"
ORDER BY r."rental_id";


-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT r."rental_id",
		r."customer_id",
		c."first_name",
		c."last_name"
FROM "rental" AS r
RIGHT JOIN 
	"customer" AS c ON r."customer_id" = c."customer_id"
	GROUP BY r."rental_id",
		 r."customer_id",
		 c."first_name",
		 c."last_name"
ORDER BY r."rental_id";


-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

SELECT f."film_id",
		f."title",
		c."category_id", 
		c."name"
FROM "film" AS f
CROSS JOIN "category" AS c;


--No aporta ningún valor ya que estoy haciendo un producto cartesiano con ambas tablas, y una película no puede tener diferentes categorías.

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.


SELECT fa."actor_id",
	   CONCAT(a."first_name",' ', a."last_name") AS "Actor/Actriz",
	   "title" AS "Película",
	   c."name" AS "Categoría"
FROM "film_category" AS fc
	INNER JOIN
		"category" AS c ON fc."category_id"=c."category_id"
	INNER JOIN
		"film" AS f ON fc."film_id"=f."film_id"
	INNER JOIN
		"film_actor" AS fa ON f."film_id"=fa."film_id"
	INNER JOIN
		"actor" AS a ON fa."actor_id"=a."actor_id"
	WHERE c."name" = 'Action'
ORDER BY fa."actor_id";



-- 46. Encuentra todos los actores que no han participado en películas.


SELECT a."actor_id"
FROM "actor" a
	LEFT JOIN 
		"film_actor" fa ON a."actor_id" = fa."actor_id"
	WHERE fa."film_id" IS NULL;

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.


SELECT a."actor_id",
	   a."first_name", 
	   a."last_name",
	   COUNT(fa."film_id") AS "cantidad_películas"
FROM "actor" a
	INNER JOIN 
		"film_actor" fa ON a."actor_id" = fa."actor_id"
	GROUP BY a."actor_id"
ORDER BY a."actor_id";

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

CREATE VIEW actor_num_peliculas AS
SELECT a."first_name", a."last_name", COUNT(fa."film_id") AS "número_películas"
FROM "actor" a
	INNER JOIN 
		"film_actor" fa ON a."actor_id" = fa."actor_id"
	GROUP BY a."first_name", a."last_name";

SELECT * FROM actor_num_peliculas;



-- 49. Calcula el número total de alquileres realizados por cada cliente.

SELECT c."customer_id",
		c."first_name",
		c."last_name",
		COUNT("rental_id") AS "número total de alquileres"
FROM "rental" AS r
INNER JOIN 
	"customer" AS c ON r."customer_id" = c."customer_id"
GROUP BY c."customer_id"


SELECT * FROM rental r 

-- 50. Calcula la duración total de las películas en la categoría 'Action'

SELECT sum(f."length") AS "Duración películas"
FROM "film" AS f
INNER JOIN
	"film_category" AS fc ON f."film_id" = fc."film_id" 
INNER JOIN
	"category" AS c ON fc."category_id" = c."category_id"
WHERE c."name" = 'Action';


-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.


CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT 
    c."customer_id",
    c."first_name",
    c."last_name",
    COUNT(r."rental_id") AS "total alquileres"
FROM "customer" c
LEFT JOIN 
    "rental" r ON c."customer_id" = r."customer_id"
GROUP BY 
    c."customer_id", c."first_name", c."last_name";


SELECT *
FROM cliente_rentas_temporal;

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

CREATE TEMPORARY TABLE películas_alquiladas AS
SELECT f."film_id", f."title", COUNT(r."rental_id") AS "total_alquileres"
FROM "film" AS f
INNER JOIN 
	"inventory" AS i ON f."film_id" = i."film_id"
INNER JOIN 
	"rental" AS r ON i."inventory_id" = r."inventory_id"
GROUP BY f."film_id", f."title"
HAVING COUNT(r."rental_id") >= 10;

SELECT * FROM películas_alquiladas;


-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. 
-- Ordena los resultados alfabéticamente por título de película.

SELECT f."title" AS "Películas no devueltas de Tammy Sanders"
FROM "customer" AS c 
INNER JOIN 
	"rental" AS r ON c."customer_id"=r."customer_id"
INNER JOIN 
	"inventory" AS i ON r."inventory_id" = i."inventory_id" 
INNER JOIN 
	"film" AS f ON i."film_id"=f."film_id"
	WHERE c."first_name" = 'TAMMY' AND c."last_name" = 'SANDERS' AND r."return_date" IS NULL
ORDER BY f."title";

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’.
-- Ordena los resultados alfabéticamente por apellido.


SELECT a."actor_id", a."first_name", a."last_name"
FROM "actor" a
INNER JOIN 
	"film_actor" fa ON a."actor_id" = fa."actor_id"
INNER JOIN 
	"film" f ON fa."film_id" = f."film_id"
INNER JOIN
	"film_category" fc ON f."film_id" = fc."film_id"
INNER JOIN 
	"category" c ON fc."category_id" = c."category_id"
	WHERE c."name" = 'Sci-Fi'
GROUP BY a."actor_id"
ORDER BY a."last_name";


-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus
--     Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

SELECT DISTINCT a."first_name", a."last_name" 
FROM "actor" AS a
INNER JOIN 
	"film_actor" AS fa ON a."actor_id" = fa."actor_id" 
INNER JOIN
	"film" AS f ON fa."film_id"=f."film_id" 
INNER JOIN
	"inventory" AS i ON f."film_id" = i."film_id" 
INNER JOIN 
	"rental" AS r ON i."inventory_id" = r."inventory_id"
        WHERE r."rental_date" > (
	SELECT MIN("rental_date")
	FROM "rental" AS r
	INNER JOIN 
		"inventory" AS i ON r."inventory_id" = i."inventory_id"
	INNER JOIN
		"film" AS f ON i."film_id" = f."film_id"
	WHERE f."title" = 'SPARTACUS CHEAPER'
)
ORDER BY a."last_name";

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

SELECT DISTINCT a."first_name",
			    a."last_name"
FROM "actor" a
INNER JOIN
	"film_actor" fa ON a."actor_id" = fa."actor_id"
INNER JOIN 
	"film" f ON fa."film_id" = f."film_id"
INNER JOIN 
	"film_category" fc ON f."film_id" = fc."film_id"
INNER JOIN
	"category" c ON fc."category_id" = c."category_id"
	WHERE a."actor_id" NOT IN (
	
    SELECT fa2."actor_id"
    	FROM "film_actor" fa2
   		 INNER JOIN 
    			"film" f2 ON fa2."film_id" = f2."film_id"
   		 INNER JOIN
    			"film_category" fc2 ON f2."film_id" = fc2."film_id"
   		 INNER JOIN
    			"category" c2 ON fc2."category_id" = c2."category_id"
    WHERE c2."name" = 'Music'
)
ORDER BY a."last_name";




-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.


SELECT f."title"
FROM "film" f
INNER JOIN
	"inventory" i ON f."film_id" = i."film_id"
INNER JOIN 
	"rental" r ON i."inventory_id" = r."inventory_id"
	WHERE (r."return_date" - r."rental_date") > INTERVAL '8 days';

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.


SELECT f."title" 
FROM "film" AS f
INNER JOIN 
	"film_category" fc ON f."film_id" = fc."film_id"
INNER JOIN
	"category" c ON fc."category_id" = c."category_id"
	WHERE c."name" = 'Animation'
ORDER BY f."title";

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados
--     alfabéticamente por título de película.

SELECT f."title" 
FROM "film" AS f
	WHERE f."length" = 
	
	(SELECT f."length"
	FROM "film" AS f 
	WHERE f."title" = 'DANCING FEVER'
	)
	ORDER BY f."title";

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
	
SELECT c."first_name", 
	   c."last_name" 
FROM "customer" AS c
INNER JOIN 
	"rental" AS r ON c."customer_id"=r."customer_id"
INNER JOIN 
	"inventory" AS i ON r."inventory_id" = i."inventory_id"
GROUP BY c."first_name",
	     c."last_name"
HAVING COUNT(DISTINCT i."film_id") >= '7'
ORDER BY c."last_name";


-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c."name" AS "Categoría",
	   COUNT(r."rental_id") AS "Total_alquileres"
FROM "category" AS c
INNER JOIN
	"film_category" AS fc ON c."category_id" = fc."category_id"
INNER JOIN 
	"film" AS f ON fc."film_id" = f."film_id"
INNER JOIN
	"inventory" AS i ON f."film_id" = i."film_id" 
INNER JOIN 
	"rental" AS r ON i."inventory_id" =r."inventory_id"
GROUP BY c."name";

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.

SELECT c."name" AS "Categoría",
	   COUNT(f."film_id") AS "Total_peliculas"
FROM "category" AS c
INNER JOIN 
	"film_category" AS fc ON c."category_id" = fc."category_id"
INNER JOIN
	"film" AS f ON fc."film_id" = f."film_id"
INNER JOIN 
	"inventory" AS i ON f."film_id" = i."film_id" 
INNER JOIN
	"rental" AS r ON i."inventory_id" = r."inventory_id"
	WHERE f."release_year" = 2006
	GROUP BY c."name";

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

SELECT * FROM store AS s;
SELECT * FROM staff AS st;

SELECT *
FROM "store" AS s
CROSS JOIN "staff" AS st;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
--     su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c."customer_id", 
	   "first_name", 
	   "last_name", COUNT("rental_id") AS "Num películas alquiladas" 
FROM "customer" AS c
INNER JOIN 
	"rental" AS r ON c."customer_id" = r."customer_id" 
GROUP BY c."customer_id";


