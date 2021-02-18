BEGIN TRANSACTION;
DELETE FROM pack_compilers 
WHERE cmp_id in (SELECT c.id 
                 FROM compilers c 
                 WHERE c.name in ('FPC-32', 'FPC-64', 'FPC-32U', 'FPC-64U'));
                
DELETE FROM compilers 
WHERE name in ('FPC-32', 'FPC-64', 'FPC-32U', 'FPC-64U');

COMMIT;

