--non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.

SELECT "FirstName", "Country"
FROM Customer
WHERE Country != "USA";

--brazil_customers.sql: Provide a query only showing the Customers from Brazil.

SELECT "FirstName", "LastName", "Country"
FROM Customer
Where Country = "Brazil";

--brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil.
--The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.

SELECT c.FirstName, c.LastName, i.InvoiceId, i.InvoiceDate, i.BillingCountry
FROM Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
WHERE Country = "Brazil";

--sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.

SELECT "FirstName", "LastName", "Title"
FROM Employee
WHERE Title = "Sales Support Agent";

--unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.

SELECT DISTINCT "BillingCountry"
FROM Invoice

--sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent.
--The resultant table should include the Sales Agent's full name.

SELECT e.FirstName || " " || e.LastName as "Full Name", e.Title,  InvoiceId, InvoiceDate, Total
FROM Customer c
JOIN Employee e
ON c.SupportRepId = e.EmployeeId
JOIN Invoice i
ON c.CustomerId = i.CustomerId

--invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.

SELECT c.FirstName as "Customer First Name", c.LastName as "Customer Last Name", i.Total as "Invoice Total", i.BillingCountry, e.FirstName as "Agent First Name", e.LastName as "Agent Last Name"
FROM Customer c
JOIN Invoice i
ON c.CustomerId = i.CustomerId
JOIN Employee e
ON c.SupportRepId = e.EmployeeId;

--total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?

SELECT SUBSTR(InvoiceDate, 0, 5), COUNT(InvoiceId)
FROM Invoice
WHERE strftime('%Y', InvoiceDate) = "2009" OR STRFTIME('%Y', InvoiceDate) = "2011"
GROUP BY SUBSTR(InvoiceDate, 0, 5);

--select SUBSTR(i.InvoiceDate, 0, 5) as "Year", Count(i.InvoiceId) as "# of Invoices"
--from Invoice i
--where i.InvoiceDate LIKE "2009%" OR i.InvoiceDate LIKE "2011%"
--GROUP BY SUBSTR(i.InvoiceDate, 0, 5);

-- 9 total_sales_{year}.sql: What are the respective total sales for each of those years?

SELECT SUBSTR(InvoiceDate, 0, 5), COUNT(InvoiceId), Round(SUM(Total), 2)
FROM Invoice
WHERE strftime('%Y', InvoiceDate) = "2009" OR STRFTIME('%Y', InvoiceDate) = "2011"
GROUP BY SUBSTR(InvoiceDate, 0, 5);


-- 10 invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(InvoiceId) as "Total Items Sold"
FROM InvoiceLine
WHERE InvoiceId = 37

-- 11 line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT InvoiceId, COUNT(InvoiceLineId) AS "Items Sold"
From InvoiceLine
GROUP BY InvoiceId

--12 line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.
SELECT il.InvoiceLineId, t.name
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
ORDER BY il.InvoiceLineId;

-- 13 line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT il.InvoiceId, t.Name as "Track Name", a.Name "Artist"
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist a ON a.ArtistId = al.ArtistId;

-- 14 country_invoices.sql: Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT BillingCountry, COUNT(InvoiceId)
FROM Invoice
GROUP BY BillingCountry;

-- 15 playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.
SELECT pl.PlaylistId, pl.Name AS "Play List Name", COUNT(TrackId) "Number of Tracks"
FROM PlaylistTrack pt
JOIN Playlist pl ON pl.PlaylistId = pt.PlaylistId
GROUP BY pl.PlaylistId;

-- 16 tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
SELECT t.Name AS "Track Name", al.Title AS "Album Name", mt.Name AS "Media Type", g.Name AS Genre
FROM Track t
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN MediaType mt ON mt.MediaTypeId = t.MediaTypeId
JOIN Genre g ON g.GenreId = t.GenreId;

-- 17 invoices_line_item_count.sql: Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT InvoiceId, COUNT(InvoiceLineId) AS "# of Invoice Line Items"
FROM InvoiceLine
GROUP BY InvoiceId

-- 18 sales_agent_total_sales.sql: Provide a query that shows total sales made by each sales agent.
SELECT e.FirstName || ' ' || e.LastName AS FullName, COUNT(i.InvoiceId)
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY FullName


-- 19 top_2009_agent.sql: Which sales agent made the most in sales in 2009?

SELECT
	MAX(TotalSales),
	EmployeeName
FROM
	(
	SELECT
		"$" || printf("%.2f", SUM(i.Total)) AS TotalSales,
		e.FirstName || ' ' || e.LastName AS EmployeeName,
		STRFTIME ('%Y', i.InvoiceDate) AS InvoiceYear
	FROM
		Invoice i,
		Employee e,
		Customer c
	WHERE
	i.CustomerId = c.CustomerId
		AND c.SupportRepId = e.EmployeeId
		AND InvoiceYear = '2009'
	GROUP BY
		e.FirstName || ' ' || e.LastName,
		InvoiceYear) AS Sales;

-- 20 top_agent.sql: Which sales agent made the most in sales over all?
SELECT
	EmployeeName, MAX(TotalSales) AS TotalSales
FROM
	(
	SELECT e.FirstName || ' ' || e.LastName AS EmployeeName, "$" || Round(SUM(i.Total), 2) AS TotalSales
	FROM Employee e
	JOIN Customer c ON e.EmployeeId = c.SupportRepId
	JOIN Invoice i ON c.SupportRepId = i.CustomerId
	GROUP BY EmployeeName)
--LIMIT 1;

--21 sales_agent_customer_count.sql: Provide a query that shows the count of customers assigned to each sales agent.

SELECT e.FirstName || ' ' || e.LastName AS EmployeeName, COUNT(c.CustomerId) 'Number of Customers'
FROM Employee e
LEFT JOIN Customer c ON e.EmployeeId = c.SupportRepId
WHERE e.Title = "Sales Support Agent"
GROUP BY e.FirstName, e.LastName;

-- 25 top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks over all.
SELECT t.Name, SUM(il.Quantity) NumberPurchased
FROM Track t
JOIN InvoiceLine il ON il.TrackId = t.TrackId
GROUP BY t.Name
ORDER BY NumberPurchased DESC
LIMIT 5;












