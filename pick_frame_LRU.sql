﻿drop function if exists pick_frame_LRU();

create or replace function 
pick_frame_LRU() returns int as
$$

/*select nro_frame from (
	select nro_frame, max(last_touch) from bufferpool
	group by nro_frame
	order by max desc
	limit 4 offset 0
	) as bp
limit 1 offset 3
*/

/*LA FUNCION DE ARRIBA NO ME FUNCIONA, SI PUEDEN VEANLO A VER SI A USTEDES SI*/

select nro_frame from bufferpool
order by last_touch asc
limit 1 offset 0


$$
Language SQL;

select pick_frame_LRU();
