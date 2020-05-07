FROM node:12-slim

WORKDIR /usr/app

RUN npm install --global http-server

RUN echo "Hello work" > /usr/app/CHECK

CMD ["http-server", "-p 3000"]