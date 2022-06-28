FROM node
RUN npm install
COPY . .
CMD [ "node", "server.js" ]
