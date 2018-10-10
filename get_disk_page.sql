CREATE OR REPLACE FUNCTION get_disk_page(nro_page integer) RETURNS integer AS $$
DECLARE
    result_frame integer := -1;
	prev_disk_page integer;
	
BEGIN
	SELECT nro_frame INTO result_frame FROM bufferpool WHERE nro_disk_page = $1;
	IF result_frame <> -1 THEN

	UPDATE bufferpool 
	SET nro_frame = result_frame,
		free = false,
		dirty = false,
		nro_disk_page = nro_page,
		last_touch = clock_TIMESTAMP()
	WHERE nro_frame = result_frame;
	
		RAISE NOTICE 'Lectura desde el buffer. Frame Nro: %', result_frame;
		return result_frame;
	END IF;
	
	SELECT * INTO result_frame FROM frameVacio();
	IF result_frame IS NOT NULL THEN

	UPDATE bufferpool 
	SET nro_frame = result_frame,
		free = false,
		dirty = false,
		nro_disk_page = nro_page,
		last_touch = clock_TIMESTAMP()
	WHERE nro_frame = result_frame;
	
		RAISE NOTICE 'Lectura desde disco. No se elimino ningun frame. Almacenada en el Frame Nro: %', result_frame;
		return result_frame;
	END IF;
	
	SELECT * INTO result_frame FROM pick_frame_139();
	
	prev_disk_page := (SELECT nro_disk_page FROM bufferpool WHERE nro_frame = result_frame);
	
	UPDATE bufferpool 
	SET nro_frame = result_frame,
		free = false,
		dirty = false,
		nro_disk_page = nro_page,
		last_touch = clock_TIMESTAMP()
	WHERE nro_frame = result_frame;
	
	RAISE NOTICE 'Lectura desde el disco. Pagina del disco eliminada del buffer: %. Almacenada en el Frame Nro: %', prev_disk_page, result_frame;
	
	return result_frame;
END;
$$ LANGUAGE plpgsql;

drop function if exists frameVacio();

create or replace function 
frameVacio() returns int as
$$

select nro_frame from bufferpool where nro_disk_page IS NULL
order by last_touch asc
limit 1 offset 0

$$
Language SQL;
