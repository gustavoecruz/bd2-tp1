drop function if exists pick_frame_MRU();

create or replace function 
pick_frame_MRU() returns int as
$$

select nro_frame from bufferpool
order by last_touch desc
limit 1 offset 0

$$
Language SQL;

select pick_frame_MRU();