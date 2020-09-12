FROM node:12-alpine as assets

RUN node -v
# v12.18.3
RUN npm -v
# v6.14.6

WORKDIR /var/www/html

# Copy Package json
COPY ./src/package.json ./src/package-lock.json \
     /var/www/html/

# Install dependencies
RUN npm i

# Copy Application Resources
COPY ./src/resources       /var/www/html/resources
COPY ./src/public          /var/www/html/public
COPY ./src/webpack.mix.js  /var/www/html

# Build Assets
RUN npm run prod


# --------------------------
FROM nginx:1.19-alpine

WORKDIR /var/www/html

# Copy Assets
COPY  --from=assets \
  /var/www/html/public \
  /var/www/html/public

CMD ["nginx", "-g", "daemon off;"]
