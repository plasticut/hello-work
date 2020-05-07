# HELLO WORK

Usage:

Specify domain in file ./DOMAIN

Include apps folder into nginx.conf

```nginx
  include /usr/docker-deployment/apps/**/*.conf
```

Start or restart application:

```shell
./app-update.sh VIRUAL_HOST_NAME IMAGE_NAME PORT_INSIDE_CONTAINER? NGINX_CONFIG_TEMPLATE_PATH?
```

Stop application:

```shell
./app-update.sh VIRUAL_HOST_NAME
```

Testing:

1. Build test image

```shell
  ./test/build.sh
```

2. Start test application on subdomain hello-world.domain.com

```shell
  ./app-update.sh hello-world hello-world:latest
```

3. Make request:

```shell
  curl hello-world.domain.com/CHECK
```

4. Stop test application on subdomain hello-world.domain.com

```shell
  ./app-stop.sh hello-world
```
