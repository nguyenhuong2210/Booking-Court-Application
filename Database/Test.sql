/*Create City*/
call createCity("CityA",@a);/*success*//*100*/
call createCity("CityB",@a);/*sucess*//*100*/
call createCity("CityC",@a);/*success*//*100*/
call createCity("CityA",@a);/*city existed*//*102*/
call createCity("!@#",@a);/*Invalid city_id*//*101*/

/*Create Center*/
call createCityCenter(2,"Center1",@a);/*Success*//*200*/
call createCityCenter(1,"Center1",@a);/*Success*/ /*200*/
call createCityCenter(1,"Center2",@a);/*Success*/ /*200*/
call createCityCenter(1,"Center1",@a);/*Center existed*//*203*/
call createCityCenter(1,"!@#",@a);/*Invaild center_id*//*201*/
call createCityCenter(4,"Center3",@a);/*City not existed*//*202*/

/*Create Court*/
call createCityCenterCourt("!@$",2,@a);/*Invalid court_id*//*301*/
call createCityCenterCourt("Court1",2,@a);/*Success*//*300*/
call createCityCenterCourt("Court2",2,@a);/*Success*//*300*/
call createCityCenterCourt("Court1",2,@a);/* Court existed*//*302*/
call createCityCenterCourt("Court2",4,@a);/*Center not existed*//*303*/

/*Create PLayer*/
call createPlayer("!@$!@","Huong","huongnguyenquynh2210@gmail.com",@a);/*Invalid player_id*//*401*/
call createPlayer("Player5","124 ","huongnguyenquynh2210@gmail.com",@a);/*Invalid player name*//*402*/
call createPlayer("Player2","Huong","@sdaf ",@a);/*Invalid player_email*//*403*/
call createPlayer("Player2","Nguyen","huongnguyenquynh2210@gmail.com",@a);/*Success*//*400*/
call createPlayer("Player1","Nguyen Quynh Huong","huongnguyenquynh2210@gmail.com",@a);/*Success*//*400*/
call createPlayer("Player1","Nguyen Quynh Huong","huongnguyenquynh2210@gmail.com",@a);/*Player existed*//*404*/
call createPlayer("Player3","Quynh","huongnguyenquynh2210@gmail.com",@a);/*Success*//*400*/

/*Create Booking*/
/*Existed : "Booking1","2020-02-12","7:00:00","8:00:00","Court2","Center3","CityA","Player1",unpaid*/
insert into booking(date,startTime,endTime,court,player,timestamp) values ("2020-02-12","7:00:00","8:00:00",1,"Player1",now());
CALL createBooking("2020-05-10","12:30:00","14:00:00",1,"1@%#",@a);/*Invalid player_id*//*501*/
CALL createBooking("2020-05-12","7:00:00","8:00:00",1,"Player2",@a);/*Success*//*500*/
CALL createBooking("2020-05-12","11:30:00","12:15:00",1,"Player2",@a);/*Success*//*500*/
CALL createBooking("2020-05-12","12:30:00","13:30:00",1,"Player2",@a);/*Success*//*500*/
CALL createBooking("2020-05-12","12:30:00","14:00:00",1,"Player5",@a);/*Player not exist*//*502*/
CALL createBooking("2020-05-12","12:30:00","14:00:00",5,"Player2",@a);/*Court not exist*//*503*/
CALL createBooking("2020-01-09","7:30:00","9:00:00",1,"Player3",@a);/*start time in the past*//*504*/
CALL createBooking("2020-05-12","6:30:00","8:00:00",1,"Player3",@a);/*Start time before opening time*//*505*/
CALL createBooking("2020-05-12","20:30:00","22:00:00",1,"Player3",@a);/*End time after closing time*//*506*/
CALL createBooking("2020-05-12","12:30:00","10:00:00",1,"Player3",@a);/*End time before start time*//*507*/
CALL createBooking("2020-05-12","7:30:00","10:00:00",1,"Player3",@a);/*Booking time must be 45/60/75/90 minutes*//*508*/
CALL createBooking("2020-05-12","7:30:00","8:00:00",1,"Player3",@a);/*Booking time must be 45/60/75/90 minutes*//*508*/
CALL createBooking("2020-05-12","7:00:00","8:20:00",1,"Player3",@a);/*Booking time must be 45/60/75/90 minutes*//*508*/
CALL createBooking("2020-05-12","7:15:00","8:00:00",1,"Player3",@a);/*Overlap booking*//*509*/
CALL createBooking("2020-05-12","11:00:00","12:15:00",1,"Player3",@a);/*Overlap booking*//*509*/
CALL createBooking("2020-05-12","10:45:00","12:15:00",1,"Player3",@a);/*Overlap booking*//*509*/
CALL createBooking("2020-05-17","11:30:00","13:00:00",2,"Player2",@a);/*More than 3 bookings*//*510*/
CALL createBooking("2020-05-15","11:30:00","13:00:00",2,"Player1",@a);/*Pending booking in the past*//*511*/
CALL createBooking("2020-05-06","7:30:00","8:30:00",2,"Player3",@a);/*Success*/

/*Cancel Booking */
call cancelBooking(1,"#$$",@a);/*Invalid player_id*//*601*/
call cancelBooking(2,"Player2",@a);/*Success*//*600*/
call cancelBooking(2,"Player2",@a);/*Booking not existed*//*602*/
call cancelBooking(7,"Player2",@a);/*Booking not existed*//*602*/
call cancelBooking(1,"Player5",@a);/*player not existed*//*603*/
call cancelBooking(1,"Player2",@a);/*Booking NOT belong to Player*//*604*/
call cancelBooking(5,"Player3",@a);/*less than 24h from start time *//*605*/

/*UpdateBookingStatus*/
call updateBookingStatus(1,1,"Player#!@1",@a);/*Invalid player_id*//*701*/
call updateBookingStatus(1,1,"Player1",@a);/*Success*//*700*/
call updateBookingStatus(7,1,"Player2",@a);/*Booking_id not exist*//*702*/
call updateBookingStatus(1,1,"Player6",@a);/*Player_id not exist*//*703*/
call updateBookingStatus(1,1,"Player2",@a);/*Booking NOT belong to center*//*704*/

/*Get all cities*/
call getAllCities(@a);/*Success*//*800*/

/*Get all center in that city*/
call getAllCitiesCenters(1,@a);/*Success*//*900*/
call getAllCitiesCenters(8,@a);/*City not exist*//*901*/
call getAllCitiesCenters(3,@a);/*No center in that city*//*902*/

/*Get all court in that center*/
call getAllCitiesCentersCourts(2,@a);/*Success*//*1000*/
call getAllCitiesCentersCourts(3,@a);/*No court in that center*//*1002*/
call getAllCitiesCentersCourts(5,@a);/*Center not exist*//*1001*/

/*Get  players info */
call getPlayersInfo("Player1",@a);/*Success*//*1100*/
call getPlayersInfo("!@#",@a);/*invalid player id*//*1101*/
call getPlayersInfo("Player4",@a);/*Not exist*//*1102*/

/*Get Booking Info*/
call getBookingInfo(1,"Player1",@a);/*Success*//*1200*/
call getBookingInfo(1,"Player1@!#",@a);/*Invalid player*//*1201*/
call getBookingInfo(1,"Player4",@a);/*Player NOT exist*//*1202*/
call getBookingInfo(6,"Player1",@a);/*Booking_id not existed*//*1203*/
call getBookingInfo(3,"Player1",@a);/*Booking not belong to player*//*1204*/

/*Get Center Booking*/
call getCenterBooking("2020-05-14",5,@a);/* Center id NOT exists*//*1301*/
call getCenterBooking("2020-05-24",2,@a);/*No booking on that date at the center*//*1302*/
call getCenterBooking("2020-05-12",2,@a);/*Success*//*1300*/

/*Get Court Booking*/

call getCourtBooking("2020-05-12",1,@a);/*Success*//*1400*/
call getCourtBooking("2020-05-14",5,@a);/*Court not exist*//*1401*/
call getCourtBooking("2020-02-15",2,@a);/*No booking on that date at the court*//*1402*/

/*Get Player Booking*/
call getPlayerBookings("2020-02-12","!@$",@a);/*invalid player_id*//*1501*/
call getPlayerBookings("2020-02-12","Player5",@a);/*Player not exist*//*1502*/
call getPlayerBookings("2020-02-12","Player2",@a);/*Booking not exist*//*1503*/
call getPlayerBookings("2020-05-12","Player2",@a);/*Success*//*1500*/

