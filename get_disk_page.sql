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
	
	SELECT * INTO result_frame FROM pick_frame_MRU();
	
	prev_disk_page := (SELECT nro_disk_page FROM bufferpool WHERE nro_frame = result_frame);
	
	UPDATE bufferpool 
	SET nro_frame = result_frame,
		free = false,
		dirty = false,
		nro_disk_page = nro_page,
		last_touch = clock_TIMESTAMP()
	WHERE nro_frame = result_frame;
	
	RAISE NOTICE 'Lectura desde el disco. Pagina del disco eliminada del buffer: %', prev_disk_page;
	
	return result_frame;
END;
$$ LANGUAGE plpgsql;