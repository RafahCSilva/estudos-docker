FROM ubuntu

MAINTAINER RafaelCSilva

# install NGINX
RUN apt-get update -y && apt-get install -y nginx


# Copiando o conf para dentro do container
ADD ./config/nginx.conf /etc/nginx/sites-enabled/default


# Capturando logs do std para arquivo log
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# porta exposta
EXPOSE 8080

# desabilita o modo daemon no config do
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Executavel deste container
#ENTRYPOINT [ "/usr/sbin/nginx" ]
# Params default deste containr
#CMD [ "start", "-g" ]

# outra opcao: somente CMD para executar padrao
CMD service nginx start -g
