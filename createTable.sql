drop table if exists bufferpool;

CREATE TABLE bufferpool(
	nro_frame int,
	free boolean,
	dirty boolean,
	nro_disk_page int,
	last_touch timestamp
	);

INSERT INTO bufferpool (nro_frame, free, dirty, nro_disk_page, last_touch)
VALUES (1,TRUE,FALSE,null,clock_timestamp());
INSERT INTO bufferpool (nro_frame, free, dirty, nro_disk_page, last_touch)
VALUES (2,TRUE,FALSE,null,clock_timestamp());
INSERT INTO bufferpool (nro_frame, free, dirty, nro_disk_page, last_touch)
VALUES (3,TRUE,FALSE,null,clock_timestamp());
INSERT INTO bufferpool (nro_frame, free, dirty, nro_disk_page, last_touch)
VALUES (4,TRUE,FALSE,null,clock_timestamp());