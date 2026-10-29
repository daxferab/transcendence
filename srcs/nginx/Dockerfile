FROM nginx

RUN	mkdir /etc/nginx/ssl && \
	openssl req \
		-x509 \
		-noenc \
		-keyout /etc/nginx/ssl/private.key \
		-out /etc/nginx/ssl/public.crt \
		-subj "/C=/ST=/L=/O=/OU=/CN=localhost"

COPY ./conf/server.conf /etc/nginx/conf.d/server.conf

EXPOSE 443
