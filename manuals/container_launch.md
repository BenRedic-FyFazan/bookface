# Main command
sudo docker run [options] [image name (and filepath if nessecary]

# Options

## '-i' interactive
Lar oss samhandle med containerens STDIN, dvs lar oss gi userinput til containeren

## '-t' tty (teletypewriter)
Allokerer en pseudo tty til containeren, som sammen med -i gir oss ett interaktivt shell

## '-p [host:container]'
Knytter en port hos host til en port i containeren.
syntaks: '-p 49001:80'

## '-d' daemon
Kjører container som en daemon

## '-v' volume
Mounter en fil fra host til containeren.
Syntaks: '-v /path/to/host/file:/path/in/container/file'

## '--name [name]'
Gir navn til container prosessen

## '--network [network-name]'
Knytter containeren til et docker-nettverk

# Oppstart for oss (04.02.23)
**Container www1con3**
sudo docker run -it -d \
--name bookface1 \
-v /home/ubuntu/bookface/bookface/code:/var/www/html \
-v /home/ubuntu/bookface/bookface/apache2:/etc/apache2 \
-v /var/log/apache2:/var/log/apache2 \
-p 49001:80 \
bookface

**Container www2con1**
sudo docker run -it -d \
--name bookface1 \
-v /home/ubuntu/bookface/bookface/code:/var/www/html \
-v /home/ubuntu/bookface/bookface/apache2.conf:/etc/apache2/apache2.conf \
-v /var/log/apache2:/var/log/apache2 \
-p 49001:80 \
bookface

