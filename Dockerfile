FROM centos:latest

ENV code_root /code
ENV httpd_conf ${code_root}/httpd.conf


RUN yum -y install epel-release

RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

RUN yum clean all
RUN yum update -y

RUN yum install nano -y

RUN yum --enablerepo=epel,remi install httpd -y

RUN yum install --enablerepo=epel,remi-php71,remi -y \
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

RUN sed -i -e "s|^;date.timezone =.*$|date.timezone = Asia/Tokyo|" /etc/php.ini
RUN sed -i -e "s|^;expose_php =.*$|expose_php = Off|" /etc/php.ini
RUN sed -i -e "s|^;allow_url_fopen =.*$|allow_url_fopen = Off|" /etc/php.ini
RUN sed -i -e "s|^;max_execution_time =.*$|max_execution_time = 2|" /etc/php.ini
RUN sed -i -e "s|^;zlib.output_compression =.*$|zlib.output_compression = On|" /etc/php.ini
RUN sed -i -e "s|^;sql.safe_mode =.*$|sql.safe_mode = On|" /etc/php.ini
RUN sed -i -e "s|^;post_max_size =.*$|post_max_size = 1K|" /etc/php.ini
RUN sed -i -e "s|^;max_input_time =.*$|max_input_time = 30|" /etc/php.ini
RUN sed -i -e "s|^;memory_limit =.*$|memory_limit = 40M|" /etc/php.ini
RUN sed -i -e "s|^;disable_functions =.*$|disable_functions = exec,passthru,shell_exec,system,popen,curl_multi_exec,parse_ini_file,show_source|" /etc/php.ini

ADD . $code_root
RUN test -e $httpd_conf && echo "Include $httpd_conf" >> /etc/httpd/conf/httpd.conf

EXPOSE 80
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
