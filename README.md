# TD-Weather
Test app for putting some slightly interesting dataset into Treasure Data.

I thought it would be easier to get a free temperature API, but there is a lot of throttling going on!
weatherunderground.com has been unstable.  A modest flurry of queries seems to provoke a lock-out.

Switched to aviationdata.org.  Only parsing out current temperature, but this query is getting METARS
data that can be parsed in raw format for many more observations.
Found some METARS parsing guidelines, but will add that another day...

I have aviationweather.pl running at 10 minute intervals into my Treasure Data test_db.
