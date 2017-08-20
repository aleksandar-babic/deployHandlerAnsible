##
 # DeployHandler NGINX Vhost configuration file
## 

# Expires map
map $sent_http_content_type $expires {
    default                    off;
    text/html                  epoch; #means no cache, as it is not a static page
    text/css                   max;
    application/javascript     max;
    application/woff2          max;
    ~assets/img                    30d; #it is only the logo, so maybe I could change it once a month now
}

server {

	#IPv4
	listen 80;
	#IPv6
	listen [::]:80;

	root /var/www/deployhandler;

	index index.html;

	server_name deployhandler.com;

	location / {
		try_files $uri $uri/ =404;
	}

	expires $expires;
}

