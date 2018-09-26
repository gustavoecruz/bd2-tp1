drop function if exists huboSecuenciales(int);

create or replace function huboSecuenciales(i int) returns boolean as $$
DECLARE
	ultimaPagina int:=-1;
	numPagina RECORD;
BEGIN	
	FOR numPagina IN 
    SELECT nro_disk_page from bufferpool order by last_touch desc limit i LOOP --ORDENO POR MODIFICACION MAS RECIENTE
																								                               --Y RECORRO LOS NUMEROS DE PAGINA
		  IF ultimaPagina = -1 THEN ultimaPagina := numPagina.nro_disk_page;    	--SI LA ULTIMA PAGINA ES -1 ES PRIMER ACCESO,
                                                                              --PONGO LA ACTUAL COMO LA ULTIMA
		  ELSIF numPagina.nro_disk_page=ultimaPagina-1 
        THEN ultimaPagina := numPagina.nro_disk_page;                         --SINO, SI LA ULTIMA PAGINA ERA MAYOR POR 1
																								                              --QUE LA ACTUAL, SIGUE SECUENCIAL 
		ELSE return false;																		                    --SI NO ES MAYOR POR 1 NO ES SECUENCIAL, FALSE
		END IF;
	END LOOP;
	RETURN true;
END;
$$ Language plpgsql;



create or replace function pick_frame_139() returns int as $$
DECLARE
	porcentajeSecuencial int := 100;
	nSecuencial int;
	huboNSecuenciales boolean := true;
	frameRet int;
BEGIN	
	nSecuencial := ((select count(*) from bufferpool)*porcentajeSecuencial) / 100;		--Establezco las N secuencial según el porcentaje N
	huboNSecuenciales := (select huboSecuenciales(nSecuencial));                      --Funcion auxiliar para ver si hubo N secuenciales
	
	IF huboNSecuenciales THEN frameRet := (select pick_frame_MRU());                  --Si hubo N secuenciales Uso MRU
	ELSE frameRet := (select pick_frame_LRU());                                       --Si no hubo N secuenciales uso MRU
	END IF;
												  
	RETURN frameRet;
END;
$$ Language plpgsql;

select pick_frame_139();
