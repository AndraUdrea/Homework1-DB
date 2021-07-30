CREATE TABLE partner_places(
 place_id SERIAL PRIMARY KEY,
 place_name VARCHAR(50) NOT NULL,
 region VARCHAR(30) NOT NULL,
 city VARCHAR(20),
 address VARCHAR(50) NOT NULL
)

CREATE TABLE sports(
 sport_id SERIAL PRIMARY KEY,
 sport_name VARCHAR(30) NOT NULL,
 start_date DATE,
 end_date DATE,
 average_cost DECIMAL,
 place_id INTEGER REFERENCES partner_places(place_id)
)

SELECT * FROM partner_places
SELECT * FROM sports

INSERT INTO partner_places(place_name,region,city,address)
VALUES('Aeroclubul Romaniei','Romania','Pitesti','DJ659, Geamăna 117141')
INSERT INTO partner_places(place_name,region,city,address)
VALUES('Zumbaala Wake Park','Romania','Bucuresti','Aleea, Strada Valea Parcului 1A, Mogoșoaia 077135')
INSERT INTO partner_places(place_name,region,city,address)
VALUES('Place122','Switzerland','Zermatt','Schluhmattstrasse 28, 3920 Zermatt')
INSERT INTO partner_places(place_name,region,city,address)
VALUES('Place12','Romania','Brasov','123656,Brasov')
INSERT INTO partner_places(place_name,region,city,address)
VALUES('Partie de ski Azuga','Romania','Azuga',' 3, Azuga 105100')
 INSERT INTO partner_places(place_name,region,city,address)
VALUES('Ballooning4YOU','Hungary','Budapest',' 21555,Budapest')
INSERT INTO partner_places(place_name,region,city,address)
VALUES('Butterfly Balloons','Turkey','Goreme',' 155555,Goreme')
INSERT INTO partner_places(place_name,region,city,address)
VALUES('Aeroact','Turkey','Nevsehir',' 142555,Nevsehir')
INSERT INTO partner_places(place_name,region,city,address)
VALUES('Butterfly Balloons','Turkey','Goreme',' 155555,Goreme')
INSERT INTO partner_places(place_name,region,city,address)
VALUES('Place77','Romania','Bucharest',' 5454543,Bucharest')


INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Skidiving','2020-07-05','2020-08-10',600,1)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Bungee Jumping','2020-05-12','2020-07-01',150,1)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('WakeBoard','2019-10-12','2021-08-13',125.5,2)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Offroad trip','2021-06-11','2021-09-25',140,4)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Mountain bike','2021-06-11','2021-09-17',147,4)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Offroad adventure','2021-04-13','2021-10-2',350,4)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Ski','2019-12-01','2022-03-07',400,3)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Ski','2020-12-01','2022-02-17',163,5)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Zipline','2020-02-04','2021-04-10',100,4)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Zipline2','2020-02-04','2021-01-10',105,4)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Balloon Flight','2021-02-05','2021-10-10',425,6)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Balloon Flight','2020-04-15','2021-12-10',557,7)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Balloon Flight','2021-01-14','2021-11-05',755,8)
INSERT INTO sports(sport_name,start_date,end_date,average_cost,place_id)
VALUES('Balloon Flight','2020-04-17','2021-11-04',1222,9)
 
 --2.Cate sporturi extreme se pot practica in fiecare locatie existenta
SELECT place_id,COUNT(place_id) FROM sports
GROUP BY place_id
ORDER BY place_id

--1. Care sunt locurile unde se poate practica un anumit sport extrem
SELECT sports.place_id,place_name,region,city,address FROM sports
INNER JOIN partner_places
ON sports.place_id=partner_places.place_id
WHERE sport_name='Ski'

--3.Ce sporturi extreme se pot practica in locatia X (la alegere) in luna Y
SELECT sport_name FROM sports
INNER JOIN partner_places
ON sports.place_id=partner_places.place_id
WHERE place_name='Aeroclubul Romaniei' AND 
07 BETWEEN EXTRACT(MONTH FROM start_date) AND EXTRACT(MONTH FROM end_date)



--4.Unde s-ar putea practica X (la alegere) daca as fi intr-o vacanta in tara Y (la alegere) in perioada 1-10 august (luna august)
SELECT place_name FROM partner_places
INNER JOIN sports
ON sports.place_id=partner_places.place_id
WHERE sport_name='Balloon Flight' AND region='Turkey' AND
10 BETWEEN EXTRACT(MONTH FROM start_date) AND EXTRACT(MONTH FROM end_date)

--5.Care sunt cele mai ieftine 5 locatii unde se poate practica X
SELECT place_name FROM partner_places
INNER JOIN sports
ON sports.place_id=partner_places.place_id
WHERE sport_name='Balloon Flight'
ORDER BY average_cost
LIMIT 3

--6.Functie care intoarce pretul mediu pentru un serviciu per tara!
CREATE FUNCTION get_average_price(service varchar,country varchar)
returns decimal
language plpgsql
as
$$
declare 
average_price DECIMAL;
begin
SELECT AVG(average_cost)
INTO average_price
FROM sports
INNER JOIN partner_places
ON sports.place_id=partner_places.place_id
WHERE sport_name=service AND region=country;

RETURN average_price;
END;
$$;

SELECT get_average_price('Balloon Flight','Turkey');


