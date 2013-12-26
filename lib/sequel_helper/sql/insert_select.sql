#
# INSERT SELECT
#
# query that compares two tables off 2 params and figures out what
# has not been inserted. then it actually inserts what's missing.
#

CREATE TABLE foo
(id INT(11) NOT NULL AUTO_INCREMENT
, price_date DATETIME
, symbol VARCHAR(255)
, open DOUBLE
, high DOUBLE
, low DOUBLE
, close DOUBLE
, adj_close DOUBLE
, volume INT(32),
PRIMARY KEY (id)
);

INSERT INTO foo (price_date, symbol, open, high, low, close, adj_close, volume)
VALUES ("2013-12-03", "GILD", 13.05, 13.10, 13.00, 13.04, 13.06, 200000);
INSERT INTO foo (price_date, symbol, open, high, low, close, adj_close, volume)
VALUES ("2013-12-02", "GILD", 12.05, 12.10, 12.00, 12.04, 12.06, 100000);
INSERT INTO foo (price_date, symbol, open, high, low, close, adj_close, volume)
VALUES ("2013-12-01", "GILD", 12.05, 12.10, 12.00, 12.04, 12.06, 100000);


CREATE TABLE bar LIKE foo;

INSERT INTO bar (price_date, symbol, open, high, low, close, adj_close, volume)
VALUES ("2013-12-01", "GILD", 12.05, 12.10, 12.00, 12.04, 12.06, 100000);

INSERT INTO bar 
  (price_date
   , symbol
   , open
   , high
   , low
   , close
   , adj_close
   , volume)
SELECT 
  f.price_date
  , f.symbol
  , f.open
  , f.high
  , f.low
  , f.close
  , f.adj_close
  , f.volume
FROM foo f LEFT JOIN bar b
ON f.price_date=b.price_date AND f.symbol=b.symbol
WHERE b.symbol IS NULL;