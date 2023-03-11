--create table yellevate to import
CREATE TABLE yellevate (
	country varchar,
	customer_id varchar,
	invoice_number numeric,
	invoice_date date,
	due_date date,
	invoice_amount numeric,
	disputed numeric,
	dispute_lost numeric,
	settled_date date,
	days_settled integer,
	days_late integer
);

--check for inconsistencies in the country column
SELECT DISTINCT country
FROM yellevate;

--add column disputed_or_not
ALTER TABLE yellevate
ADD COLUMN disputed_or_not varchar;

--update column disputed_or_not to show if disputed or not
UPDATE yellevate
SET disputed_or_not = (
CASE
	WHEN disputed = 1 THEN 'Disputed'
	ELSE 'Not Disputed'
END
);

--add column dispute_case
ALTER TABLE yellevate
ADD COLUMN dispute_case varchar;

--update column dispute_case to show if dispute is won or lost
UPDATE yellevate
SET dispute_case = (
CASE
	WHEN dispute_lost = 0 THEN 'Won'
	ELSE 'Lost'
END
);

--add column settlement
ALTER TABLE yellevate
ADD COLUMN settlement varchar;

--update column settlement to show if late or not late
UPDATE yellevate
SET settlement = (
CASE
	WHEN days_late > 0 THEN 'Past Due'
	ELSE 'On Time'
END
);

--add column invoice_date_new
ALTER TABLE yellevate
ADD COLUMN invoice_date_new varchar;

--update column invoice_date_new to show new date format
UPDATE yellevate
SET invoice_date_new = (
	(TO_CHAR(invoice_date :: DATE, 'yyyy-Month-dd'))
);

--add column due_date_new
ALTER TABLE yellevate
ADD COLUMN due_date_NEW varchar;

--update column due_date_new to show new date format
UPDATE yellevate
SET due_date_new = (
	TO_CHAR(due_date :: DATE, 'yyyy-Month-dd')
);

--add column settled_date_new
ALTER TABLE yellevate
ADD COLUMN settled_date_new varchar;

--update column settled_date_new to show new date format
UPDATE yellevate
SET settled_date_new = (
	TO_CHAR(settled_date :: DATE, 'yyyy-Month-dd')
);

--create table yellevate_invoices
CREATE TABLE yellevate_invoices AS (
	SELECT 
	country,
	customer_id,
	invoice_number,
	invoice_date AS invoice_date_old,
	REPLACE(invoice_date_new, ' ', '') AS invoice_date,
	due_date AS due_date_old,
	REPLACE(due_date_new, ' ', '') AS due_date,
	invoice_amount,
	disputed_or_not AS disputed,
	dispute_case,
	settled_date AS settled_date_old,
	REPLACE(settled_date_new, ' ', '') As settled_date,
	days_settled,
	days_late,
	settlement
	FROM yellevate
	ORDER BY invoice_date_old ASC
);

--remove column invoice_date_old
ALTER TABLE yellevate_invoices
DROP COLUMN invoice_date_old;

--remove column due_date_old
ALTER TABLE yellevate_invoices
DROP COLUMN due_date_old;

--remove column settled_date_old
ALTER TABLE yellevate_invoices
DROP COLUMN settled_date_old;

--create table yellevate_disputes to show table with only disputes
CREATE TABLE yellevate_disputes AS (
	SELECT
	country,
	customer_id,
	invoice_number,
	invoice_date,
	due_date,
	invoice_amount,
	dispute_case,
	settled_date,
	days_settled,
	days_late,
	settlement
	FROM yellevate_invoices
	WHERE disputed ILIKE 'd%'
);