FROM centos/systemd:latest

ENV code_root /code
ENV httpd_conf ${code_root}/httpd.conf

RUN yum clean all; \
    yum update -y; \
    yum install epel-release -y \
                httpd \
                nano \
                wget

#install mysql
RUN wget https://repo.mysql.com//mysql57-community-release-el7-7.noarch.rpm; \
    yum localinstall mysql57-community-release-el7-7.noarch.rpm -y; \
    yum install mysql-community-server -y;

#install php
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm; \
    yum install --enablerepo=epel,remi-php71,remi -y \
                              php \
                              php-mcrypt \
                              php-mysqli \
                              php-common \
                              php-mbstring \
                              php-opcache \
                              php-dom \
                              php-mbstring \
                              php-openssl \
                              php-tokenizer

RUN sed -i -e "s|^;date.timezone =.*$|date.timezone = Asia/Tokyo|" \
        -i -e "s|^;expose_php =.*$|expose_php = Off|" \
        -i -e "s|^;allow_url_fopen =.*$|allow_url_fopen = Off|" \
        -i -e "s|^;max_execution_time =.*$|max_execution_time = 2|" \
        -i -e "s|^;zlib.output_compression =.*$|zlib.output_compression = On|" \
        -i -e "s|^;sql.safe_mode =.*$|sql.safe_mode = On|" \
        -i -e "s|^;post_max_size =.*$|post_max_size = 1K|" \
        -i -e "s|^;max_input_time =.*$|max_input_time = 30|" \
        -i -e "s|^;memory_limit =.*$|memory_limit = 40M|" \
        -i -e "s|^;disable_functions =.*$|disable_functions = exec,passthru,shell_exec,system,popen,curl_multi_exec,parse_ini_file,show_source|" \
        /etc/php.ini

ADD . $code_root
RUN test -e $httpd_conf && echo "Include $httpd_conf" >> /etc/httpd/conf/httpd.conf

EXPOSE 80
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
