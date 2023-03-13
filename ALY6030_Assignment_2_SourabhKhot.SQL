# ALY 6030 Assignment 2 Sourabh Khot Submission

# PART 1: Database Normalization

# Delete database onlineauction if it already exists
DROP SCHEMA IF EXISTS onlineauction;

# Creating database for this assignment
CREATE DATABASE onlineauction;
# Set up database as the default one
USE onlineauction;

# Creating first empty table to import database
CREATE TABLE bidtxn (
	auctionid BIGINT NOT NULL,
    bidvalue FLOAT NOT NULL,
	bidtime DOUBLE NOT NULL,
	biddername VARCHAR(64) NOT NULL,
	bidderrate INT,
	openbid FLOAT,
	price FLOAT
);

# At this stage, import 'ebay.csv' dataset using 'Table Data Import Wizard' and map columns

# Verify data added into table
SELECT * FROM bidtxn;

# Normalize bidtxn to NF1 by adding PK
# PK is an INT field with auto increment option
ALTER TABLE bidtxn
ADD COLUMN bidid INT PRIMARY KEY AUTO_INCREMENT;

# Verify new column added and filled with data
SELECT * FROM bidtxn;

# For NF2, create new table auction 
# Table will have auctionID, openbid, price
CREATE TABLE auction (
	auctionID BIGINT PRIMARY KEY,
    openbid FLOAT NOT NULL,
    price FLOAT
);

# Insert auctionID, openbid, price into auction from bidtxn table
# Using DISTINCT to eliminate duplicate auctionIDs
INSERT INTO auction
(auctionID, openbid, price)
SELECT DISTINCT auctionID, openbid, price
FROM bidtxn;

# Verify data inserted into auction table
SELECT * FROM auction;

# Remove redundant columns from bidtxn table
ALTER TABLE bidtxn
DROP COLUMN openbid,
DROP COLUMN price;

# Verify redundant columns no longer exist in bidtxn table
SELECT * FROM bidtxn;

# Create 1:M relation between auctions and bidtxn
# by specifying auctionid in bidtxn is FK pointing to auctionid in auction
ALTER TABLE bidtxn
ADD FOREIGN KEY (auctionid) REFERENCES auction(auctionid);

# For NF2, create new table bidder
# Table will have biddername, bidderrate
CREATE TABLE bidder (
	biddername VARCHAR(64) PRIMARY KEY,
	bidderrate INT
);

# Insert bidder, bidderrate into bidder from bidtxn table
# Using DISTINCT to eliminate duplicate bidder
INSERT INTO bidder
(biddername, bidderrate)
SELECT DISTINCT biddername, bidderrate
FROM bidtxn;

# Verify data inserted into auction table
SELECT * FROM bidder;

# Remove redundant columns from bidtxn table
ALTER TABLE bidtxn
DROP COLUMN bidderrate;

# Verify redundant columns no longer exist in bidtxn table
SELECT * FROM bidtxn;

# Create 1:M relation between bidder and bidtxn
# by specifying biddername in bidtxn is FK pointing to biddername in bidder
ALTER TABLE bidtxn
ADD FOREIGN KEY (biddername) REFERENCES bidder(biddername);

# For NF3, create new table bids
# Table will have bidid, bidvalue, bidtime
CREATE TABLE bids (
	bidid INT,
    bidvalue INT NOT NULL,
	bidtime DOUBLE NOT NULL
);

# Insert bidid, bidvalue, bidtime into bids from bidtxn table
# There Using DISTINCT to eliminate duplicate bidid
INSERT INTO bids
(bidid, bidvalue, bidtime)
SELECT DISTINCT bidid, bidvalue, bidtime
FROM bidtxn;

# Verify data inserted into auction table
SELECT * FROM bids;

# Remove redundant columns from bids table
ALTER TABLE bidtxn
DROP COLUMN bidvalue,
DROP COLUMN bidtime;

# Verify redundant columns no longer exist in bids table
SELECT * FROM bidtxn;

# Seting bidid to auto-increment in bids and remove auti-increment in bidtxn table
ALTER TABLE bidtxn
MODIFY COLUMN bidid INT PRIMARY KEY;
ALTER TABLE bids
MODIFY COLUMN bidid INT PRIMARY KEY AUTO_INCREMENT;

# Create 1:1 relation between bidtxn and bids
# by specifying bidid in bidtxn is FK pointing to bidid in bids
ALTER TABLE bidtxn
ADD FOREIGN KEY (bidid) REFERENCES bids(bidid);

# PART 2: SQL Query Design

# Query bidders, value and time for particular auction sorted by time
SELECT n.biddername, b.bidvalue, b.bidtime
FROM bidder n
	JOIN bidtxn t ON n.biddername = t.biddername
    JOIN auction a ON t.auctionid = a.auctionid
    JOIN bids b ON t.bidid = b.bidid
WHERE a.auctionid = '8212590929'
ORDER BY b.bidtime;

# Query 1 to find top 5 auctions & prices having highest number of bids sorted in descending order
SELECT a.auctionid, COUNT(b.bidid) as bidcount, a.price
FROM bidtxn t
    JOIN bids b ON t.bidid = b.bidid
    JOIN auction a ON t.auctionid = a.auctionid
GROUP By a.auctionid
ORDER BY bidcount DESC LIMIT 5;

# Query 2 to find top 5 auctions & prices having highest number of bids sorted in descending order
SELECT a.auctionid, COUNT(b.bidid) as bidcount, a.price
FROM bidtxn t
    JOIN bids b ON t.bidid = b.bidid
    JOIN auction a ON t.auctionid = a.auctionid
GROUP By a.auctionid
ORDER BY bidcount DESC LIMIT 5;

# Query 3 to find per auction opening bid, average bidvalue, closing price, multipler of opening to closing price
SELECT a.auctionid, a.openbid, AVG(b.bidvalue) AS avgbid, a.price,
	CAST(a.price/a.openbid AS decimal(10,1)) AS multipler
FROM bidtxn t
    JOIN bids b ON t.bidid = b.bidid
    JOIN auction a ON t.auctionid = a.auctionid
GROUP By a.auctionid
ORDER BY a.auctionid;