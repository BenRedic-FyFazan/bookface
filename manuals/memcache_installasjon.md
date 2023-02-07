# Memcache installasjon:
## Memcache server:
 - Start opp ein VM som ska brugas t memcache
 - sudo apt-get update 
 - sudo apt-get install memcached 
 - sudo nano /etc/memcached.conf
       - endre linjen som definerer hvilken ip det lyttes på til 0.0.0.0 (alle IP'er, default er nok localhost/127.0.0.1)
       - endre cachestørrelse til ønsket verdi (kommentarer viser til cache størrelse, ellers starter linja med -m)
 - sudo service memcached restart
       
## Webservere:
 - sudo apt-get update
 - sudo apt-get install php-memcache libmemcached11 libmemcached-dev
 - sudo nano /var/www/html/config.php, legg til følgende linjer:
 
```
$memcache_enabled = 1;  
$memcache_enabled_pictures = 1;  
$memcache_server = “IP til VM'en du satte opp som memcache server”; 

Siden memcache koden allerede e konfigurert trenge du bare enable.
E du nysgjerrig på koden så kan du sjekka showuser.php og showimage.php, der ser du og grunnen t at me ikje definere porten memcache lytte på når me pege webserverne t memcache serveren =)
```
 - sudo service apache2 restart
