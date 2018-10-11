/*
            TRAZA MAS EFICIENTE CON 139
LECTURAS:
          139 = 6
          MRU = 7
          LRU = 7
*/
select get_disk_page (101);
select get_disk_page (102);
select get_disk_page (103);
select get_disk_page (104);
select get_disk_page (105);
select get_disk_page (106);
select get_disk_page (102);
select get_disk_page (105);

select * from bufferpool order by nro_frame asc;


/*
            TRAZA MAS EFICIENTE CON LRU
LECTURAS:
          139 = 6
          MRU = 7
          LRU = 5
*/
select get_disk_page (101);
select get_disk_page (102);
select get_disk_page (103);
select get_disk_page (104);
select get_disk_page (105);
select get_disk_page (104);

select * from bufferpool order by nro_frame asc;


/*
            TRAZA MAS EFICIENTE CON MRU
LECTURAS:
          139 = 6
          MRU = 5
          LRU = 6
*/
select get_disk_page (101);
select get_disk_page (102);
select get_disk_page (103);
select get_disk_page (105);
select get_disk_page (106);
select get_disk_page (101);

select * from bufferpool order by nro_frame asc;
