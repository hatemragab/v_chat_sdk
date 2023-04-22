---
sidebar_position: 1
---

# Backend intro

## Requirements for local & production

1. install nodejs and npm and check the versions you should have node version above v16 check node version by `node -v`
2. install cross-env globally `npm i -g cross-env` & `npm install -g @nestjs/cli`
3. install [Redis](https://redis.io) this used for socket.io connection for cluster mode support
4. install [mongodb](https://www.mongodb.com/try/download/community-kubernetes-operator) mim v4.4 or above v6 is
   recommended
5. create aws account and register new S3 bucket make sure to have this data

- S3_ACCESS_KEY_ID="AKIA--------"
- S3_SECRET_KEY="ax2nDid-------"
- BUCKET_REGION="eu------"
- BUCKET="-------"
- Follow this video for more info [Link](https://www.youtube.com/watch?v=NZElg91l_ms&t=585s)

## .env files

1. You have **.env.development** and **.env.production**
2. `.env.development` put the data of development in this file
3. `.env.production` put the data of production in this file

- `DB_URL`="mongodb://127.0.0.1:27017/v_chat_sdk_v2" mongo db full url
- `JWT_SECRET`="a%dyFjcZp*xL$Qbek" very storage password
- `REDIS_URL`="redis://localhost:6379"
- `issuer`="v_chat_sdk_v2@gmail.com"
- `audience`="chat.vchatsdk.com"
- `encryptHashKey`="V_CHAT_SDK_V2_VERY_STRONG_KEY" very storage password this `must` be same as flutter encryptHashKey
- `isOneSignalEnabled` ="true" if you support onesignal
- `isFirebaseFcmEnabled` ="true" if you support firebase fcm then you should update `firebase.adminsdk.json` file by
  your firebase account real file.
- `oneSignalAppId`="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx"
- `oneSignalApiKey`="xxxxxxxxxxxx"
- `S3_ACCESS_KEY_ID`="AKxxxxxxxxxx"
- `S3_SECRET_KEY`="xxxxxx"
- `BUCKET_REGION`="xxxxx"
- `BUCKET`="xxxxxxx"
- `NODE_ENV`=`development` production for `.env.production`
- `EDIT_MODE` ="false"

### How to get `firebase.adminsdk.json`
- if this step not done correctly the notifications of chat will not arrive follow this
  to get your file [Link](https://www.youtube.com/watch?v=cXOzbKDXTh0)
- To start the server in development just run this command in the app root `npm run start:dev`
- if no errors then all done successfully