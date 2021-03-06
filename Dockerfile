FROM 1and1internet/ubuntu-16-apache
MAINTAINER brian.wojtczak@1and1.co.uk
ARG DEBIAN_FRONTEND=noninteractive
COPY files /
RUN \
    apt-get update && \
    apt-get install -y python-software-properties software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y imagemagick graphicsmagick && \
    apt-get install -y libapache2-mod-php5.6 php5.6-bcmath php5.6-bz2 php5.6-cli php5.6-common php5.6-curl php5.6-dba php5.6-gd php5.6-gmp php5.6-imap php5.6-intl php5.6-ldap php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-odbc php5.6-pgsql php5.6-recode php5.6-snmp php5.6-soap php5.6-sqlite php5.6-tidy php5.6-xml php5.6-xmlrpc php5.6-xsl php5.6-zip && \
    apt-get install -y php-gnupg php-imagick php-mongodb php-streams php-fxsl && \
    sed -i -e 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/5.6/apache2/php.ini && \
    sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 256M/g' /etc/php/5.6/apache2/php.ini && \
    sed -i -e 's/post_max_size = 8M/post_max_size = 512M/g' /etc/php/5.6/apache2/php.ini && \
    sed -i -e 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/5.6/apache2/php.ini && \
    sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' /etc/apache2/mods-available/dir.conf && \
    mkdir -p /usr/src/tmp/ioncube && \
    curl -fSL "http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64_5.1.2.tar.gz" -o /usr/src/tmp/ioncube_loaders_lin_x86-64_5.1.2.tar.gz && \
    tar xfz /usr/src/tmp/ioncube_loaders_lin_x86-64_5.1.2.tar.gz -C /usr/src/tmp/ioncube && \
    cp /usr/src/tmp/ioncube/ioncube/ioncube_loader_lin_5.6.so /usr/lib/php/20131226/ && \
    rm -rf /usr/src/tmp/ && \
    mkdir /tmp/composer/ && \
    cd /tmp/composer && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer && \
    cd / && \
    rm -rf /tmp/composer && \
    apt-get remove -y python-software-properties software-properties-common && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    chmod 777 -R /var/www  && \
    apache2ctl -t && \
    mkdir -p /run /var/lib/apache2 /var/lib/php && \
    chmod -R 777 /run /var/lib/apache2 /var/lib/php /etc/php/5.6/apache2/php.ini
