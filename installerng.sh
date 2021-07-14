#!/bin/env bash

sudo yum groupinstall -y "Development Tools"
sudo yum install unzip
sudo yum install rpmdevtools

sudo useradd hueitor
sudo usermod -aG hueitor hueitor

sudo su hueitor <<EOSU
cd ~
rpmdev-setuptree

cd /home/hueitor/rpmbuild/SRPMS
wget https://nginx.org/packages/mainline/centos/8/SRPMS/nginx-1.19.3-1.el8.ngx.src.rpm
wget https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v0.3.1.tar.gz
wget https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/get/08a395c66e42.zip

tar -xzvf v0.3.1.tar.gz
unzip 08a395c66e42.zip

echo '%_topdir /home/hueitor/rpmbuild'> ~/.rpmmacros

rpm -Uvh nginx-1.19.3-1.el8.ngx.src.rpm


cd ~/rpmbuild/SPECS/
sed -i '72c\%define BASE_CONFIGURE_ARGS $(echo "--prefix=%{_sysconfdir}/nginx --sbin-path=%{_sbindir}/nginx --modules-path=%{_libdir}/nginx/modules --conf-path=%{_sysconfdir}/nginx/nginx.conf --error-log-path=%{_localstatedir}/log/nginx/error.log --http-log-path=%{_localstatedir}/log/nginx/access.log --pid-path=%{_localstatedir}/run/nginx.pid --lock-path=%{_localstatedir}/run/nginx.lock --http-client-body-temp-path=%{_localstatedir}/cache/nginx/client_temp --http-proxy-temp-path=%{_localstatedir}/cache/nginx/proxy_temp --http-fastcgi-temp-path=%{_localstatedir}/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=%{_localstatedir}/cache/nginx/uwsgi_temp --http-scgi-temp-path=%{_localstatedir}/cache/nginx/scgi_temp --user=%{nginx_user} --group=%{nginx_group} --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --add-module=/home/hueitor/rpmbuild/SRPMS/ngx_devel_kit-0.3.1 --add-module=/home/hueitor/rpmbuild/SRPMS/nginx-goodies-nginx-sticky-module-ng-08a395c66e42")' nginx.spec



rpmbuild -ba nginx.spec
chmod -R 777 /home/hueitor
chmod 777 /home/hueitor/rpmbuild/RPMS/x86_64/nginx-1.19.3-1.el8.ngx.x86_64.rpm
EOSU

sudo yum localinstall /home/hueitor/rpmbuild/RPMS/x86_64/nginx-1.19.3-1.el8.ngx.x86_64.rpm
