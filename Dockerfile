############################
# STEP 1 build website
############################
FROM 15.10.0-alpine3.10 as builder

WORKDIR /app

COPY ./package.* /app

RUN npm install

COPY ./src /app

RUN npm run-script build


############################
# STEP 2 build target image with nginx
############################
FROM nginx:1.19.7-alpine

COPY --from=builder ./build/ /usr/share/nginx/html
