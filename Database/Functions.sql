/*Function check valid id*/
DROP FUNCTION IF EXISTS isValidId;
DELIMITER //
CREATE FUNCTION isValidId(pid varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT pid REGEXP '^[a-zA-Z0-9]+$' INTO result;
RETURN result;
END //
DELIMITER ;

/*Function check valid name*/
DROP FUNCTION IF EXISTS isValidName;
DELIMITER //
CREATE FUNCTION isValidName(pname varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT pname REGEXP '^([a-zA-Z ]+)$' INTO result;
RETURN result;
END //
DELIMITER ;

/*Function check valid email*/
DROP FUNCTION IF EXISTS isValidEmail;
DELIMITER //
CREATE FUNCTION isValidEmail(pemail varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT pemail REGEXP '^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$' INTO result;
RETURN result;
END //
DELIMITER ;

/* Function check overlap booking */
DROP FUNCTION IF EXISTS Overlap_Bookings;
DELIMITER //
CREATE FUNCTION Overlap_Bookings(pdate date,pstart time, pend time,
pcourt int) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT 1 
FROM booking
WHERE court = pcourt
AND date = pdate
AND ((pstart < startTime and pend >= startTime)
	OR (pstart >= startTime and pstart < endTime))
INTO result;
RETURN result;
END //
DELIMITER ;

/* Function check 3 advance bookings */
DROP FUNCTION IF EXISTS Advance_Bookings;
DELIMITER //
CREATE FUNCTION Advance_Bookings(pplayer varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT count(*) 
FROM booking
WHERE player = pplayer
AND  date > date(now())
INTO result;
RETURN result;
END //
DELIMITER ;


/* Function check 1 pending bookings in the past */
DROP FUNCTION IF EXISTS Pending_Booking;
DELIMITER //
CREATE FUNCTION Pending_Booking(pplayer varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
SELECT 1
FROM booking
WHERE player = pplayer
AND  date <= date(now()) 
AND booking_status = 0
INTO result;
RETURN result;
END //
DELIMITER ;


/* Function check 24h booking for cancellation*/
DROP FUNCTION IF EXISTS 24h_Booking;
DELIMITER //
CREATE FUNCTION 24h_Booking(pbooking int,pplayer varchar(50)) 
RETURNS int DETERMINISTIC
BEGIN
DECLARE result int DEFAULT 0;
	SELECT 1
	FROM booking 
	WHERE booking_id = pbooking AND player = pplayer 
    AND TIMESTAMPDIFF(HOUR,now(),addtime(date,startTime)) < 24
    INTO result;
RETURN result;
END //
DELIMITER ;
