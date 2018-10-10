CREATE OR REPLACE FUNCTION get_disk_page(nro_page integer) RETURNS integer AS $$
DECLARE
    result_frame integer := -1;
	prev_disk_page integer;
	
BEGIN
	SELECT nro_frame INTO result_frame FROM bufferpool WHERE nro_disk_page = $1;
	IF result_frame <> -1 THEN

		prev_disk_page := (SELECT nro_disk_page FROM bufferpool WHERE nro_frame = result_frame);
		PERFORM actualizarFrame(nro_page, result_frame);
		RAISE NOTICE 'Lectura de la pagina % desde el buffer. Frame Nro: %', prev_disk_page, result_frame;
		
		return result_frame;
	END IF;
	
	SELECT * INTO result_frame FROM frameVacio();
	IF result_frame IS NOT NULL THEN
		
		PERFORM actualizarFrame(nro_page, result_frame);
		RAISE NOTICE 'Lectura desde disco. No se elimino ninguna página. Almacenada en el Frame Nro: %', result_frame;
		
		return result_frame;
	END IF;
	
	SELECT * INTO result_frame FROM pick_frame_MRU();	
	prev_disk_page := (SELECT nro_disk_page FROM bufferpool WHERE nro_frame = result_frame);
	PERFORM actualizarFrame(nro_page, result_frame);
	RAISE NOTICE 'Lectura desde el disco. Pagina del disco eliminada del buffer: %. Almacenada en el Frame Nro: %', prev_disk_page, result_frame;
	return result_frame;
	
END;
$$ LANGUAGE plpgsql;




drop function if exists frameVacio();
create or replace function frameVacio() returns int as $$

	select nro_frame from bufferpool where free IS true
	order by nro_frame asc
	limit 1 offset 0
	
$$
Language SQL;




drop function if exists actualizarFrame();
create or replace function actualizarFrame(nro_page integer, result_frame integer) RETURNS void AS $$

	UPDATE bufferpool 
		SET nro_frame = result_frame,
			free = false,
			dirty = false,
			nro_disk_page = nro_page,
			last_touch = clock_TIMESTAMP()
		WHERE nro_frame = result_frame;

$$ Language SQL;