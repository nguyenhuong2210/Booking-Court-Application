DROP DATABASE booking_app;
CREATE DATABASE booking_app;
USE booking_app;

DROP TABLE IF EXISTS player;
CREATE TABLE player(
	player_id varchar(50) NOT NULL PRIMARY KEY,
    name varchar(50) NOT NULL,
    email varchar(100) NOT NULL
);

DROP TABLE IF EXISTS city;
CREATE TABLE city(
	city_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name varchar(50) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS center;
CREATE TABLE center(
	center_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name varchar(50) NOT NULL,
	city int NOT NULL,
	CONSTRAINT center_city_fk
		FOREIGN KEY (city) REFERENCES city (city_id)
);
    
DROP TABLE IF EXISTS court;
CREATE TABLE court(
	court_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name varchar(50) NOT NULL,
	center int NOT NULL,
	CONSTRAINT court_center_id_fk
		FOREIGN KEY (center) REFERENCES center (center_id)
);

DROP TABLE IF EXISTS booking;
CREATE TABLE booking(
  booking_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date date NOT NULL,
  startTime time NOT NULL,
  endTime time NOT NULL,
  court int NOT NULL,
  player varchar(50) NOT NULL,
  booking_status boolean DEFAULT 0 , -- 0: UNPAID   1:PAID
  timestamp timestamp NOT NULL,
  CONSTRAINT court_fk
     FOREIGN KEY (court) REFERENCES court (court_id),
  CONSTRAINT player_fk
     FOREIGN KEY (player) REFERENCES player(player_id)	 
);

