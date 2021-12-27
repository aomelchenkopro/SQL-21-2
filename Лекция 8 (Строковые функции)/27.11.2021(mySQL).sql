SELECT concat_ws(' ', lower(t1.first_name), lcase(last_name)) as "full_name",
	   length(concat_ws(' ', lower(t1.first_name), lcase(last_name))) as "full_name_length"
  FROM sakila.actor as t1
  order by length(concat_ws(' ', lower(t1.first_name), lcase(last_name)))  desc
;

  SELECT insert(phone,4,4,'****')
  FROM sakila.address;