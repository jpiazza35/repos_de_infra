# Build and deploy Svelte nginx container.
#
# Buld arguments:
# NODE_VER: Version of node image to use. See: https://hub.docker.com/_/node (Default: 18)
# ENV: Environment identifier in lowercase i.e dev; stage; prod (Default: Use .local)
#
# Pass build arguments with the --build-arg switch. i.e. --build-arg NODE_VER=18

# Accept a node image version or default to 18-latest
ARG NODE_VER=18

# Build the Svelte app
FROM docker.io/node:${NODE_VER} AS build

# Specify a environment for variable substitution
ARG ENV=false

WORKDIR /build
COPY . .

RUN npm i
# If ENV specified use that build mode.
RUN if [ "$ENV" = "false" ] ; then npm run build ; else npm run build -- --mode ${ENV} ; fi
RUN cp -rf assets/* dist/assets

# Prepare the NGINX container
FROM docker.io/nginx:stable AS nginx

COPY --from=build /build/dist /usr/share/nginx/html
COPY --from=build /build/nginx /etc/nginx

# Inject self-signed cert
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -days 3650 -config /etc/nginx/ssl.conf -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt
RUN chown nginx:nginx /etc/nginx/ssl/*

EXPOSE 80
EXPOSE 443