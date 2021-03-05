/*Create new City*/
DROP PROCEDURE IF EXISTS createCity;
DELIMITER //
CREATE PROCEDURE createCity(in pcity varchar(50), out result int)
BEGIN
/*Invalid city*/
IF isValidId(pcity) = 0 
THEN SET result = 101;

/*City existed*/
ELSEIF pcity IN (SELECT name FROM city)
THEN SET result = 102;

ELSE INSERT INTO city (name) values (pcity);
SELECT city_id FROM city WHERE name = pcity;
SET result = 100;
END IF;
SELECT result;
END //
DELIMITER ;

/*Create new Center*/
DROP PROCEDURE IF EXISTS createCityCenter;
DELIMITER //
CREATE PROCEDURE createCityCenter(in pcity int, in pcenter varchar(50), out result int)
BEGIN

/*Invalid center*/
IF isValidId(pcenter) = 0 
THEN SET result = 201;

/* city NOT exists */
ELSEIF pcity NOT IN (SELECT city_id FROM city)
THEN SET result = 202;

/*Center existed*/
ELSEIF pcenter IN (SELECT name FROM center WHERE city = pcity)
THEN SET result = 203;

ELSE INSERT INTO center (name,city) value (pcenter,pcity);
SELECT center_id FROM center WHERE name = pcenter AND city = pcity; 	
SET result = 200;
END IF;
SELECT result;
END //
DELIMITER ;


/*Create new court*/
DROP PROCEDURE IF EXISTS createCityCenterCourt;
DELIMITER //
CREATE PROCEDURE createCityCenterCourt(in pcourt varchar(50), in pcenter int, out result int)
BEGIN
/*Invalid court*/
IF isValidId(pcourt) = 0 
THEN SET result = 301;

/* court existed */
ELSEIF EXISTS (SELECT * FROM court WHERE name = pcourt AND center = pcenter) 
THEN SET result = 302;

/*Center not existed*/
ELSEIF NOT EXISTS ( SELECT * FROM center WHERE center_id = pcenter)
THEN SET result = 303;

ELSE INSERT INTO court (name,center) values (pcourt,pcenter);
SELECT court_id FROM court WHERE center = pcenter AND name = pcourt;	
SET result = 300;
END IF;
SELECT result;
END //
DELIMITER ;

/*Create new Player*/
DROP PROCEDURE IF EXISTS createPlayer;
DELIMITER //
CREATE PROCEDURE createPlayer(in pplayer varchar(50),in pname varchar(50), in pemail varchar(100), out result int)
BEGIN
/*Invalid player_id*/
IF isValidId(pplayer) = 0 
THEN SET result = 401;

/*Invalid player email*/
ELSEIF isValidName(pname) = 0 
THEN SET result = 402;

/*Invalid player email*/
ELSEIF isValidEmail(pemail) = 0 
THEN SET result = 403;

/* player existed */
ELSEIF pplayer IN (SELECT player_id FROM player)
THEN SET result = 404;

ELSE INSERT INTO player (player_id,name,email) values (pplayer,pname,pemail);
SELECT player_id FROM player WHERE player_id = pplayer;
SET result = 400;
END IF;
SELECT result;
END //
DELIMITER ;

/* Create Booking*/
DROP PROCEDURE IF EXISTS createBooking;
DELIMITER //
CREATE PROCEDURE createBooking(in pdate date, in pstart time, in pend time,in pcourt int, in pplayer varchar(50),out result int)
BEGIN
DECLARE openTime datetime;
DECLARE closeTime datetime;

SELECT 
  MAKETIME(7,0,0) into openTime;
SELECT 
  MAKETIME(21,0,0) into closeTime;  

/*Invalid player*/
IF isValidId(pplayer) = 0 
THEN SET result =501;

/* player NOT exists */
ELSEIF pplayer NOT IN (SELECT player_id FROM player)
THEN SET result =502;

/* court NOT exists */
ELSEIF NOT EXISTS (SELECT * FROM court WHERE court_id = pcourt)
THEN SET result = 503;

/* start time in the past */
ELSEIF addtime(pdate,pstart) < now()
THEN SET result = 504;

/* start time before opening time */
ELSEIF  pstart < openTime 
THEN SET result = 505;

/* end time after closing time */
ELSEIF  pend > closeTime 
THEN SET result = 506;

/*start time after end time */
ELSEIF pend < pstart
THEN SET result = 507;

/*Booking must be 45/60/90 minutes*/
ELSEIF TIMESTAMPDIFF(MINUTE,pstart,pend) NOT IN (45,60,75,90)
THEN SET result = 508;

/* Booking overlap*/
ELSEIF Overlap_Bookings (pdate,pstart,pend,pcourt)
THEN SET result = 509;

/*More than 3 bookings in advance*/
ELSEIF Advance_Bookings (pplayer) >= 3
THEN SET result = 510;

/*Unpaid*/
ELSEIf Pending_Booking (pplayer)
THEN SET result = 511;

ELSE INSERT INTO booking (date,startTime,endTime,court,player,timestamp) 
values (pdate,pstart,pend,pcourt,pplayer,now());
SELECT booking_id FROM booking WHERE date = pdate AND startTime = pstart AND endTime = pend AND court = pcourt AND player = pplayer;
	SET result = 500;
END IF;
SELECT RESULT;
END //
DELIMITER ;

/* Cancel Booking */
DROP PROCEDURE IF EXISTS cancelBooking;
DELIMITER //
CREATE PROCEDURE cancelBooking(in pbooking int,in pplayer varchar(50),out result int)
BEGIN

/*Invalid player*/
IF isValidId(pplayer) = 0 
THEN SET result =601;

/* Booking id NOT exists */
ELSEIF pbooking NOT IN (SELECT booking_id FROM booking)
THEN SET result =602; 

/* Player id NOT exists */
ELSEIF pplayer NOT IN (	SELECT player_id FROM player)
THEN SET result =603;

/* Booking NOT belong to Player*/
ELSEIF NOT EXISTS (SELECT booking_id FROM booking WHERE booking_id = pbooking AND player = pplayer)
THEN SET result =604;

/* less than 24h booking */
ELSEIF 24h_Booking (pbooking,pplayer)
THEN SET result =605;

ELSE DELETE FROM booking WHERE booking_id = pbooking AND player = pplayer ;
	SET result =600;
END IF;
SELECT result;
END //
DELIMITER ;

/*Update Booking Status*/
DROP PROCEDURE IF EXISTS updateBookingStatus;
DELIMITER //
CREATE PROCEDURE  updateBookingStatus(in pbooking int,in pstatus int, in pplayer varchar(50),out result int)
BEGIN

/*Invalid city*/
IF isValidId(pplayer) = 0 
THEN SET result =701;

/* Booking id NOT exists */
ELSEIF pbooking NOT IN (
	SELECT booking_id
    FROM booking)
THEN SET result =702;

/* player id NOT exists */
ELSEIF pplayer NOT IN (SELECT player_id FROM player)
THEN SET result = 703;

/*Booking not belong to player*/
ELSEIF NOT EXISTS (SELECT * FROM booking WHERE booking_id = pbooking AND player = pplayer)
THEN SET result =704;
    
ELSE UPDATE booking
	SET booking_status = pstatus
    WHERE booking_id = pbooking;
    SET result =700;
END IF;
SELECT result;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS getAllCities;
DELIMITER //
CREATE PROCEDURE getAllCities(out result int)
BEGIN
/*There is no city */
IF NOT EXISTS (SELECT * FROM city)
THEN SET result = 801;

ELSE SELECT * FROM city;
SET result = 800;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getAllCitiesCenters;
DELIMITER //
CREATE PROCEDURE getAllCitiesCenters(in pcity int,out result int)
BEGIN

/*city NOT exist */
IF pcity NOT IN (SELECT city_id FROM city)
THEN SET result = 901;

/*There is no center in that city */
ELSEIF NOT EXISTS ( SELECT * FROM center WHERE city = pcity)
THEN SET result = 902;

ELSE SELECT center_id, name FROM center WHERE city = pcity;
SET result = 900;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getAllCitiesCentersCourts;
DELIMITER //
CREATE PROCEDURE getAllCitiesCentersCourts(in pcenter int,out result int)
BEGIN
/*Center Not exist*/
IF NOT EXISTS ( SELECT * FROM center WHERE center_id = pcenter)
THEN SET result = 1001;

/*No court in that center*/
ELSEIF NOT EXISTS ( SELECT * FROM court WHERE center = pcenter)
THEN SET result = 1002;

ELSE SELECT court_id, name FROM court WHERE center = pcenter;
SET result = 1000;
END IF;
 SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getPlayersInfo;
DELIMITER //
CREATE PROCEDURE getPlayersInfo(in pplayer varchar(50),out result int)
BEGIN
/*Invalid player*/
IF isValidId(pplayer) = 0 
THEN SET result =1101;

/*Player do not exist*/
ELSEIF pplayer NOT IN (SELECT player_id FROM player)
THEN SET result = 1102;

ELSE SELECT * FROM player WHERE player_id = pplayer;
SET result = 1100;
END IF;
SELECT result;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS getBookingInfo;
DELIMITER //
CREATE PROCEDURE getBookingInfo(in pbooking int,in pplayer varchar(50),out result int)
BEGIN

/*Invalid player*/
IF isValidId(pplayer) = 0 
THEN SET result = 1201;

/*Player NOT exist*/
ELSEIF pplayer NOT IN (SELECT player_id FROM player)
THEN SET result = 1202;

/*booking_id not exist */
ELSEIF pbooking NOT IN (SELECT booking_id FROM booking)
THEN SET result = 1203;

/*Booking not belong to player*/
ELSEIF NOT EXISTS (SELECT * FROM booking WHERE booking_id = pbooking AND player = pplayer)
THEN SET result = 1204;

ELSE SELECT booking_id, player, date,startTime , endTime ,court
FROM booking WHERE booking_id = pbooking;
SET result = 1200;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getCenterBooking;
DELIMITER //
CREATE PROCEDURE getCenterBooking(in pdate date, in pcenter int,out result int)
BEGIN

/* Center id NOT exists in that city */
IF pcenter NOT IN (SELECT center_id FROM center)
THEN SET result =1301;

/*There is no booking in that center on that date*/
ELSEIF NOT EXISTS (SELECT * 
				FROM booking AS B
                JOIN court as CO on CO.court_id = B.court
				JOIN center as CE on CE.center_id = CO.center
				WHERE B.date = pdate AND CE.center_id = pcenter )
THEN SET result = 1302;

ELSE SELECT B.booking_id,CE.name,B.date,B.startTime ,B.endTime, P.name ,B.court 
	FROM booking AS B
	JOIN court as CO on CO.court_id = B.court
	JOIN center as CE on CE.center_id = CO.center
    JOIN player as P on P.player_id = B.player
	WHERE B.date = pdate AND CE.center_id = pcenter  ;
SET result = 1300;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getCourtBooking;
DELIMITER //
CREATE PROCEDURE getCourtBooking(in pdate date,in pcourt int,out result int)
BEGIN

/*court NOT exist */
IF pcourt NOT IN (SELECT court_id FROM court)
THEN SET result = 1401;

/*There is no booking in that center on that date*/
ELSEIF NOT EXISTS (SELECT * FROM booking WHERE date = pdate AND court = pcourt )
THEN SET result = 1402;

ELSE SELECT booking_id,date , startTime ,endTime ,player,court
	FROM booking 
	WHERE date = pdate AND court = pcourt ;
SET result = 1400;
END IF;
SELECT result;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS getPlayerBookings;
DELIMITER //
CREATE PROCEDURE getPlayerBookings(in pdate date, in pplayer varchar(50),out result int)
BEGIN
/*Invalid player*/
IF isValidId(pplayer) = 0 
THEN SET result =1501;

/*player_Id NOT exist */
ELSEIF pplayer NOT IN (SELECT player_id FROM player)
THEN SET result = 1502;

/*There is no booking in that date of that player */
ELSEIF NOT EXISTS (SELECT *
	FROM booking
	WHERE player = pplayer AND date = pdate)
THEN SET result = 1503;

ELSE SELECT booking_id, date ,startTime,endTime ,player,court
	FROM booking 
	WHERE player = pplayer AND date = pdate;
    SET result = 1500;
END IF;
SELECT result;
END//
DELIMITER ;



