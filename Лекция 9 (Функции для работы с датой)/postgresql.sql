select cast('20211204' as date);


select extract(year from t1.scheduled_departure)
  from bookings.flights as t1;

select extract(month from t1.scheduled_departure)
  from bookings.flights as t1;
  
select extract(day from t1.scheduled_departure)
  from bookings.flights as t1;