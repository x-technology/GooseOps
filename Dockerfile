############################
# STEP 1 build website
############################
FROM alpine:3.10 as builder

WORKDIR /app

COPY ./src /app

RUN mkdir -p ./build && \
      file="./assets/github-gooseops.png" && \
      b64=$(cat $file | base64 | tr -d \\n) && \
      echo "s|${file}|data:image/png;base64,${b64}|" && \
      sed "s|${file}|data:image/png;base64,${b64}|" ./index.html > ./build/index.html

############################
# STEP 2 build target image with nginx
############################
FROM nginx:1.19.7-alpine

COPY --from=builder /app/build/ /usr/share/nginx/html
