---
sidebar_position: 1
id: intro
title: vchat-sdk-V2
---

`Vchat-sdk` is a `SaaS` (Software as a Service) chat system that offers `real-time` messaging capabilities for web and
mobile
applications. It consists of two parts: the server-side and the client-side. The server-side is built using `Node.js`
and
Socket.IO for real-time communication, while MongoDB is used for data storage.

A unique feature of vchat-sdk is its independence from `Firebase` for data storage. However, it does provide the option
to
enable push notifications using Firebase Cloud Messaging `(FCM)` or `OneSignal`.

Create a new app or integrate with an existing production app to get started.

## About V_CHAT_SDK

- V_CHAT_SDK is a package written in pure Dart and NestJS for the server-side. It helps you add chat functionality to
  any existing or new Flutter mobile project, regardless of the back-end service you use.
- V_CHAT_SDK offers unlimited text, image, video, record, location, push notifications, and data control.
- With only 6 public APIs, V_CHAT_SDK is an easy way to integrate advanced real-time messaging into your chat.
- V_CHAT_SDK uses Node.js for its backend service and Firebase for push notifications. MongoDB is used as the message
  database, while the client-side is powered by `Flutter`.

## About Microservices

1. Reduced load on your main server, as chat traffic can be high.
2. Improved scalability: Microservices make it easier to identify and resolve scaling bottlenecks at a per-microservice
   level.
3. Easy to build and maintain: Their single-purpose design enables smaller, cross-functional teams to specialize in a
   subset of the microservices within a solution.

## Use Cases

1. Perfect for social media apps that require a chat system similar to `WhatsApp` or `Facebook`.
2. Ideal for e-commerce apps looking to add chat features, such as delivery or marketplace communication, like `OLX` or
   `Facebook Marketplace`.
3. Can be used for real-time user chat `support`.

## How V_CHAT_SDK Works

`V_CHAT_SDK` connects with your backend service, regardless of the language or framework it uses. It communicates with
your system through public APIs and runs separately, yet remains connected via these APIs.

When you register a new user in your system, call the `V_CHAT_SDK` public API to create a separate database for saving
user information like names, images, and identifiers. Once the user is successfully connected in your client app (
typically after successful authentication), you need to connect the user to the `V_CHAT_SDK` system to enable
communication with other users this done through using of flutter packages already build. If you have an existing
production app and wish to integrate `V_CHAT_SDK`, you can
migrate
old users, as explained in the backend section.

## Technologies

1. [Nestjs](https://nestjs.com) is used for server-side code.
2. [MongoDB](https://www.mongodb.com/) stores chat texts and user data.
3. [Socket.IO](https://socket.io) enables real-time communication.
4. [FCM](https://firebase.google.com/docs/cloud-messaging) or [OneSignal](https://onesignal.com) provide push
   notifications. You can choose between them or enable both, and V_CHAT_SDK will manage the user's platform
   availability.
5. Amazon AWS [S3](https://aws.amazon.com/s3) securely stores user media with access restrictions using pre-signed URLs.
6. [WebRTC](https://webrtc.org) is used for video and voice calls, but it's not 100% stable and requires a
   paid [TURN](https://webrtc.org/getting-started/turn-server) server. Support for [Agora.io](https://www.agora.io/en)
   will be added.
7. Client-side SDK supports [Flutter](https://flutter.dev) for Android, iOS, web, Windows, and Mac.

## Server Requirements for V_CHAT_SDK

V_CHAT_SDK is a lightweight SaaS chat system with minimal server resource requirements:

- 1 CPU core
- 1 GB RAM
- Fast SSD storage
- Ubuntu version 18 or higher
- Recommended hosting: [DigitalOcean](https://www.digitalocean.com/)
- Domain name: recommended provider is [NameCheap](https://www.namecheap.com)

Additionally, you need a MongoDB database for data storage. You can host a free MongoDB database on MongoDB Atlas, a
cloud-based database service offering simple and secure data management.

With these minimum server requirements, you can easily set up V_CHAT_SDK and start enabling real-time messaging in your
web or mobile applications.

## Features

vchat-sdk supports the following features:

V_CHAT_SDK supports a wide range of features, including:

| Feature                                                   | Description                                                                                                                                                                                                                                                                   |
|-----------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Text, image, video, voice note, documents, location share | V_CHAT_SDK supports various message types, such as text, images, videos, voice notes, documents, and location sharing (pin share only). Files, videos, and images can be downloaded.                                                                                          |
| Direct, group, broadcast, order, system chats             | V_CHAT_SDK supports different chat types, including direct messages, group chats, broadcast messages, order messages, and system messages with group system management (admin, superAdmin, members) similar to WhatsApp.                                                      |
| Message status                                            | V_CHAT_SDK supports different message statuses, including pending, sent, error, sending, delivered, and seen. It provides good support for weak connections and auto-resend for failed messages with offline storage.                                                         |
| Compress images and edit                                  | V_CHAT_SDK supports image compression and editing for optimized size and quality.                                                                                                                                                                                             |
| See message status for all room types                     | V_CHAT_SDK allows viewing message status for all room types.                                                                                                                                                                                                                  |
| Video call and voice for single rooms                     | V_CHAT_SDK supports video calls and voice messages for single rooms using `WebRTC` (not 100% stable, requires a paid [TURN](https://webrtc.org/getting-started/turn-server) server). Support for `agora.io` will be added, allowing users to choose the most suitable option. |
| Last seen and group (total online, total members count)   | V_CHAT_SDK shows user last seen status and group statistics, including total online and total members count, with support for typing and recording statuses.                                                                                                                  |
| Good voice player support                                 | V_CHAT_SDK provides a high-quality voice player with seeking, auto-playing next message, and variable playback speeds.                                                                                                                                                        |
| Multi-platform support                                    | V_CHAT_SDK ensures all functions work on various platforms, including Android, iOS, web, macOS, and Windows.                                                                                                                                                                  |
| Offline message and chat storage                          | V_CHAT_SDK supports offline message and chat downloads for fast loading. Chat texts are saved, while media files are stored for only 7 days before being auto-downloaded and saved again to reduce phone storage.                                                             |
| Public APIs ready to integrate                            | V_CHAT_SDK offers easy-to-use public APIs for seamless integration into your system.                                                                                                                                                                                          |
| In-app notifications                                      | V_CHAT_SDK fully supports in-app notifications using `FCM` or `OneSignal`. It detects unsupported FCM devices and registers them with OneSignal if enabled. Notifications clicks are handled to direct users to the chat page.                                                |
| Almost full customization                                 | V_CHAT_SDK allows theme and action customization through the package.                                                                                                                                                                                                         |
| Prebuilt admin panel APIs                                 | V_CHAT_SDK includes APIs for building your control panel to manage users and chats.                                                                                                                                                                                           |
| Records, emojis, and GIF support                          | V_CHAT_SDK supports banning users, muting chats, leaving groups, deleting chats, deleting messages for oneself and all receivers.                                                                                                                                             |
| Message features                                          | V_CHAT_SDK enables message forwarding to multiple rooms, replying with auto-highlight, sharing messages externally, message info tracking, deletion for oneself and all receivers, media sharing from external apps, and more.                                                |
| Room features                                             | V_CHAT_SDK supports single room (direct chat), group, broadcast, order room for managing chats like OLX or Facebook Market, and system chat for admin notifications or live support chat. Users can delete rooms, search, and more.                                           |
| i18n                                                      | you can support any language to translate the app                                                                                                                                                                                                                             |
| configurations                                            | you can set max limit for group members and broadcast and max forward,share message limit,max media upload size                                                                                                                                                               |

With vchat-sdk, you can easily integrate real-time messaging into your applications without the need to build your own
chat system from scratch.

## Information

1. V_CHAT_SDK is not a full app, but a set of APIs designed to make chat development faster and easier. If you're
   looking for a full app, consider **[SuperUp](https://github.com/hatemragab/superup)**.
2. While there's no prebuilt admin panel UI, V_CHAT_SDK provides prebuilt Postman APIs for integrating the chat panel
   into your system. See the [admin_apis](./backend/apis.md) section.
3. You can view all APIs before purchasing the source code: see
   the [PostmanCollection](https://documenter.getpostman.com/view/24524392/2s93Jox6Dq).
4. To see an example of the current features, check out the open-source client app that uses
   V_CHAT_SDK: **[SuperUp](https://github.com/hatemragab/superup)**.
5. For a web version, you can use Flutter web, as all packages support Flutter web. To integrate with other projects
   like React or Angular, you can build your components using
   the [PostmanCollection](https://documenter.getpostman.com/view/24524392/2s93Jox6Dq), read the docs for API params,
   and follow the [socket.io](./backend/socket_io_apis.md) events.
6. Purchasing this project from `codecanyou` allows for one-time use per project. For multi-project usage,
   contact `hatemragapdev@gmail.com`.

## Contact

- You can reach out via email at `hatemragapdev@gmail.com` or on Skype at `live:.cid.607250433850e3a6`.
- For server deployment assistance and more
  information, [visit](https://v-chat-sdk.github.io/vchat-v2-docs/docs/backend/intro#still-need-more-support).