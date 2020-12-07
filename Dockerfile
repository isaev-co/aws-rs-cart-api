FROM node:12-alpine as build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run prebuild && npm run build

# clean node_modules from dev dependencies
RUN npm prune --production

FROM node:12-alpine as app

WORKDIR /app

COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules

EXPOSE 4000
CMD ["node", "dist/main.js"]
