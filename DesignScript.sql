DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS persons CASCADE;
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS guests CASCADE;
DROP TABLE IF EXISTS roomCall CASCADE;
DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS roomCallCode CASCADE;
DROP TABLE IF EXISTS shifts CASCADE;
DROP TABLE IF EXISTS shiftDays CASCADE;
DROP TABLE IF EXISTS guestReservation CASCADE;
DROP TABLE IF EXISTS roomCleaning CASCADE;
DROP TABLE IF EXISTS style CASCADE;
DROP TABLE IF EXISTS staffsPosition CASCADE;



/* Location */
CREATE TABLE location (
    zipCode         INTEGER            NOT NULL, 
    city            VARCHAR(50)        NOT NULL,
    state           VARCHAR(2)         NOT NULL,
PRIMARY KEY(zipCode)
);



/* Persons */ 
CREATE TABLE persons (
    pid             INTEGER            NOT NULL,
    firstName       VARCHAR(50)        NOT NULL,
    lastName        VARCHAR(50)        NOT NULL,
    dateOfBirth     TIMESTAMP          NOT NULL,
    phonePrimary    CHAR(15)           NOT NULL,   
    streetAddress   VARCHAR(50)        NOT NULL, 
    zipCode         INTEGER            NOT NULL  REFERENCES location(zipCode),
PRIMARY KEY(pid)   
); 



/* Guests */
CREATE TABLE guests (
    gid             INTEGER         NOT NULL  REFERENCES persons(pid),
    memberStatus    VARCHAR         NOT NULL	 CHECK
    (memberStatus IN ('Bronze', 'Silver','Gold', 'Platinum', 'Diamond')),
PRIMARY KEY(gid)    
);


/* Shifts */
CREATE TABLE shifts (
    shid           INTEGER             NOT NULL,
    startTime      TIME                NOT NULL,
    endTime        TIME                NOT NULL,
    title          VARCHAR,
PRIMARY KEY(shid)
);


/* Staff's Posistion */
CREATE TABLE staffsPosition (
    spid           INTEGER             NOT NULL,
    title          VARCHAR             NOT NULL,
    description    VARCHAR,
PRIMARY KEY(spid)
);

/* Style */
CREATE TABLE style (
    rsid           INTEGER             NOT NULL,
    bedCount       CHAR(1)             NOT NULL,
    bedSize        VARCHAR             NOT NULL,
PRIMARY KEY(rsid)
);


/* Rooms */
CREATE TABLE rooms (
    roomNumber      VARCHAR(5)         NOT NULL,
    rsid            INTEGER            NOT NULL  REFERENCES style(rsid),    
    priceUSD        DECIMAL            NOT NULL,
PRIMARY KEY(roomNumber) 
);


/* Shift Days */
CREATE TABLE shiftDays (
    shid            INTEGER            NOT NULL	 REFERENCES shifts(shid),
    shiftDay        VARCHAR            NOT NULL  CHECK
    (shiftDay IN ('Sunday', 'Monday','Tuesday', 'Wednesday', 'Thursday','Friday','Saturday')), 
PRIMARY KEY(shid, shiftDay)
);


/* Room Call Codes */
CREATE TABLE roomCallCode (
    callCode        INTEGER             NOT NULL,
    title           VARCHAR(50)         NOT NULL,
    description     VARCHAR             NOT NULL,
PRIMARY KEY(callCode)
);


/* Staff */ 
CREATE TABLE staff (
    sid             INTEGER            NOT NULL REFERENCES persons(pid),
    spid            INTEGER            NOT NULL REFERENCES staffsPosition(spid),
    shid            INTEGER            NOT NULL REFERENCES shifts(shid),
    hireDate        TIMESTAMP          NOT NULL, 
    hourlyWageUSD   DECIMAL            NOT NULL,
PRIMARY KEY(sid)
);


/* Room Calls */
CREATE TABLE roomCall (
    gid            INTEGER              NOT NULL REFERENCES guests(gid),
    roomNumber     VARCHAR(5)           NOT NULL REFERENCES rooms(roomNumber),
    callCode       INTEGER              NOT NULL REFERENCES roomCallCode(callCode),
    callTime       TIME   		        NOT NULL,
    sid     	   INTEGER              NOT NULL REFERENCES staff(sid),
PRIMARY KEY(callTime, roomNumber, callCode, gid)
);


/* Room Cleaning */
CREATE TABLE roomCleaning (
    roomNumber    VARCHAR(5)            NOT NULL  REFERENCES rooms(roomNumber),
    timeOfEntry   TIME                  NOT NULL,
    sid           INTEGER               NOT NULL  REFERENCES staff(sid),
    timeOfExit    TIME                  NOT NULL,
PRIMARY KEY(roomNumber, timeOfEntry)
);


/* Guest Reservations */
CREATE TABLE guestReservation (
    gid                 INTEGER     NOT NULL REFERENCES guests(gid),
    roomNumber          VARCHAR(5)  NOT NULL REFERENCES rooms(roomNumber),
    sid                 INTEGER     NOT NULL REFERENCES staff(sid),
    checkInDate         TIMESTAMP,
    checkOutDate        TIMESTAMP,
    discountPercentage  DECIMAL,
PRIMARY KEY(gid,roomNumber,checkInDate)
);





INSERT INTO location (zipCode,city,state)
VALUES 	(37379, 'Soddy Daisy', 'TN'),
		(31021, 'Dublin', 'GA'),
		(09093, 'Eugene', 'OR'),
		(12366, 'Smyra', 'CA'),
		(45431, 'Uniondale', 'NY'),
		(99959, 'Garden City', 'NY'),
		(34343, 'Buffalo', 'NY'),
		(34234, 'Jacksonville', 'FL'),
		(12433, 'Campbell', 'NC'),
		(11533, 'Soddy Daisy', 'TX'),
		(12601, 'Poughkeepsie', 'NY');
        
        

INSERT INTO persons (pid,firstName,lastName,dateOfBirth,phonePrimary,streetAddress,zipCode)
VALUES  (001, 'Dan', 'Smith', '1968-12-08', 231323276, '22 Oak Street', 37379 ),
		(002, 'Will', 'Atkins', '1963-08-30', 8996439355, '654 Glenwood Drive', 31021 ),
		(003, 'Bill', 'Cosby', '1952-02-11', 8442851051, '252 13th Street', 09093 ),
		(004, 'Amy', 'Shummer', '1958-09-19', 8110049929, '396 Grove Street', 12366 ),
		(005, 'Josh', 'Merrick', '1983-09-02', 8554809490, '227 Devonshire Drive', 45431 ),
		(006, 'Randy', 'Queen', '1963-07-02', 8993496951, '138 Devon Court', 99959 ),
		(007, 'Dante', 'Matthew', '1960-05-29', 8553744253, '19 Water Street', 34234 ),
		(008, 'Harry', 'Johnson', '1958-01-09', 8555815117, '125 Spring Street', 11533 ),
		(009, 'Marco', 'Birkshire', '1993-07-02', 8339754754, '440 Canal Street', 11533 ),
		(010, 'Ruben', 'Hathaway', '1971-09-19', 8990479981, '736 3rd Street North', 11533 ),
		(011, 'Mike', 'Forte', '1981-12-08', 8446578110, '529 Laurel Street', 12601 ),
		(012, 'Cameron', 'Nero', '1955-12-27', 8220221397, '595 Parker Street', 12601 ),
		(013, 'Katie', 'Carty', '1992-05-22', 8557264814, '602 6th Street North', 12601 ),
		(014, 'Siobain', 'Rogers', '1978-06-08', 8116286109, '315 Redwood Drive', 12601 ),
		(015, 'Scott', 'Botts', '1977-04-20', 8226757964, '973 Lakeview Drive', 12601 ),
		(016, 'Sarah', 'Rogers', '1969-01-08', 8334068368, '92 Beechwood Drive', 12601 ),
		(017, 'Annie', 'Dumpty', '1988-07-05', 8442569423, '618 Madison Avenue', 12601 ),
		(018, 'Lee', 'Wee', '1998-12-08', 8444814554, '618 Madison Avenue', 12601 ),
		(019, 'Will', 'Williams', '1977-02-08', 8994765763, '944 George Street', 12601 ),
		(020, 'Amanda', 'Scott', '1994-11-08', 8441270429, '644 Marshall Street', 12601 );
        
        

INSERT INTO guests (gid,memberStatus)
VALUES  (001, 'Bronze'),
		(002, 'Bronze'),
		(003, 'Bronze'),
		(004, 'Bronze'),
		(005, 'Silver'),
		(006, 'Bronze'),
		(007, 'Bronze'),
		(008, 'Gold'),
		(009, 'Bronze'),
		(010, 'Platinum');
        
               

INSERT INTO shifts (shid,startTime,endTime,title)
VALUES  (0, '00:00:00', '06:00:00', 'Morning'),
		(1, '06:00:00', '12:00:00', 'Day'),
		(2, '12:00:00', '18:00:00', 'Evening'),
		(3, '18:00:00', '00:00:00', 'Night');
        
        

INSERT INTO staffsPosition (spid,title,description)
VALUES  (1, 'Administration', 'Managerial roll'),
		(2, 'Cleaner', 'Cleans the hotel room');
        
        

INSERT INTO style (rsid,bedCount,bedSize)
VALUES  (1, 1, 'King'),
		(2, 1, 'Queen'),
		(3, 1, 'Full'),
		(4, 2, 'Queen'),
		(5, 2, 'Full'),
		(6, 2, 'Twin'),
		(7, 2, 'King');



INSERT INTO rooms (roomNumber,rsid,priceUSD)
VALUES  (101, 1, 200),
		(102, 2, 150),
		(103, 3, 120),
		(104, 4, 250),
		(105, 5, 200),
		(201, 6, 200),
		(202, 2, 150),
		(203, 3, 120),
		(204, 4, 250),
		(205, 7, 350);
        

INSERT INTO shiftDays (shid,shiftday)
VALUES  (0, 'Monday'),
		(0, 'Tuesday'),
		(0, 'Wednesday'),
		(0, 'Thursday'),
		(0, 'Friday'),
		(0, 'Saturday'),
		(0, 'Sunday'),
		(1, 'Monday'),
		(1, 'Tuesday'),
		(1, 'Wednesday'),
		(1, 'Thursday'),
		(1, 'Friday'),
		(1, 'Saturday'),
		(1, 'Sunday'),
		(2, 'Monday'),
		(2, 'Tuesday'),
		(2, 'Wednesday'),
		(2, 'Thursday'),
		(2, 'Friday'),
		(2, 'Saturday'),
		(2, 'Sunday'),
		(3, 'Monday'),
		(3, 'Tuesday'),
		(3, 'Wednesday'),
		(3, 'Thursday'),
		(3, 'Friday'),
		(3, 'Saturday'),
		(3, 'Sunday');
        

INSERT INTO roomCallCode (callCode,title,description)
VALUES	(1, 'Maintainance', 'If its broke we fix it'),
		(2, 'Cleaning', 'New sheets? No problem'),
		(3, 'Room Service', 'You Hungry?'),
		(4, 'Help Desk', 'You have a question? Well we have answers');
        

INSERT INTO staff (sid,spid,shid,hireDate,hourlyWageUSD)
VALUES  (011, 1, 3, '2015-02-11', 15.25),
		(012, 1, 3, '2015-09-15', 10.25),
		(013, 1, 2, '2015-04-13', 14.25),
		(014, 1, 2, '2015-08-12', 10.25),
		(015, 1, 0, '2015-11-12', 10.25),
		(016, 1, 2, '2015-02-13', 13.25),
		(017, 2, 2, '2015-02-11', 10.25),
		(018, 2, 3, '2015-12-17', 11.25),
		(019, 2, 1, '2015-12-11', 9.25),
		(020, 2, 0, '2015-02-11', 9.25);
        

INSERT INTO roomCall (gid,roomNumber,callCode,callTime,sid)
VALUES 	(001, 101, 4, '20:19:19', 011),
		(001, 101, 4, '18:19:19', 011),
		(003, 103, 2, '19:20:19', 012);
        

INSERT INTO roomCleaning (roomNumber,timeOfEntry,sid,timeOfExit)
VALUES  (101, '12:00:00', 017, '12:30:00'),
		(105, '14:00:00', 017, '14:30:00'),
		(103, '15:00:00', 017, '15:30:00'),
		(201, '20:00:00', 018, '22:30:00');
        


INSERT INTO guestReservation (gid,roomNumber,sid,checkInDate,checkOutDate,discountPercentage)
VALUES	(001, 101, 013, '2016-04-21', '2016-04-23', 0),
        (002, 102, 013, '2016-04-22', '2016-04-23', 0),
        (003, 103, 013, '2016-04-23', '2016-04-24', 0),
        (004, 104, 013, '2016-04-23', '2016-04-25', 0),
        (005, 105, 013, '2016-04-20', '2016-04-23', 5),
        (006, 201, 013, '2016-04-20', '2016-04-23', 0),
        (007, 202, 013, '2016-04-21', '2016-04-23', 0),
        (008, 203, 013, '2016-04-22', '2016-04-26', 10),
        (009, 204, 013, '2016-04-21', '2016-04-23', 0),
        (010, 205, 013, '2016-04-24', '2016-04-27', 12.5);




/* Track what guessed have checked out of the hotel on April 23, 2016*/
CREATE OR REPLACE VIEW GuestRooms AS
SELECT 	DISTINCT per.firstName, per.lastName 
FROM    persons per, guests g, guestReservation gr, rooms r
WHERE   per.pid = g.gid
AND     gr.gid = g.gid
AND     gr.checkOutDate = '2016-04-23'
ORDER BY per.lastname ASC;


/*Keeps a record of each employee throughout the hotel*/
    CREATE OR REPLACE VIEW staffInformation AS
        SELECT per.firstName, per.lastName, s.hireDate, s.hourlyWageUSD
        FROM    persons per, staff s
        WHERE   s.sid = per.pid
        ORDER BY per.pid DESC;



/*Average amount of time each employeeit takes to clean a room*/
SELECT s.sid As Cleaner,
    avg(rc.timeOfExit - rc.timeOfEntry) AS AverageCleaningTime
FROM    staff s, roomCleaning rc
WHERE rc.timeOfExit IS NOT NULL
AND   s.sid = rc.sid
GROUP BY s.sid;


/*Average amount of time guest stays in hotel*/
SELECT gr.gid as GuestStay,
    avg(gr.checkOutDate - gr.checkInDate)  AS AverageTimeStay
FROM    guestReservation gr, guests g, rooms r
WHERE   gr.checkOutDate IS NOT NULL
AND     r.roomNumber = gr.roomNumber
GROUP BY GuestStay;


/*Stored Procedure*/
CREATE OR REPLACE FUNCTION insertStaff() RETURNS trigger AS $$
    BEGIN
    IF NEW.sid IS NULL THEN 
        RAISE EXCEPTION 'Invalid sid given';
    END IF;
    IF NEW.spid IS NULL THEN
        RAISE EXCEPTION 'What is staff members position?';
    END IF;
    IF NEW.shid IS NULL THEN
        RAISE EXCEPTION 'Employee must choose a shift to work.';
    END IF;
    IF NEW.hireDate IS NULL THEN
        RAISE EXCEPTION 'When was this employee hired?';
    END IF;
     IF NEW.hourlyWageUSD IS NULL THEN
        RAISE EXCEPTION 'Employee must recieve a wage.';
    END IF;
    INSERT INTO staff (sid,spid,shid,hireDate,hourlyWageUSD)
            VALUES (NEW.sid, NEW.spid, NEW.shid, 'now', NEW.hourlyWageUSD);
    RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


/*Trigger*/
CREATE TRIGGER insertStaff
AFTER UPDATE ON staff
FOR EACH ROW 
EXECUTE PROCEDURE  insertRoomCleaning();



/*Security*/

/*guest*/
GRANT INSERT ON roomCalls TO guests; 

/*administration*/
GRANT SELECT ON location TO administration;
GRANT SELECT, UPDATE ON rooms TO Administration;
GRANT SELECT, UPDATE ON style TO Administration;
GRANT SELECT, UPDATE ON roomCleaning TO Administration;
GRANT SELECT, INSERT, UPDATE ON shiftDays TO Administration;
GRANT SELECT, INSERT, UPDATE ON roomCalls TO Administration;
GRANT SELECT, INSERT, UPDATE ON callCodes TO Administration;
GRANT SELECT, INSERT, UPDATE ON persons TO Administration;
GRANT SELECT, INSERT, UPDATE ON guests TO Administration;
GRANT SELECT, INSERT, UPDATE ON staff TO Administration;
GRANT SELECT, INSERT, UPDATE, DELETE ON staffPosition TO Administration;
GRANT SELECT, INSERT, UPDATE, DELETE ON shifts TO Administration;
GRANT SELECT, INSERT, UPDATE ON, DELETE ON guestReservation TO Administration;

/*house*/
GRANT SELECT, INSERT, UPDATE ON roomCleaning TO cleaner;
