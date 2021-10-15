# V_Chat_SDK Micro service
**Quick Review**
![carbon](https://user-images.githubusercontent.com/37384769/137525753-03155709-c903-4b4d-89bf-ee40e0525d63.png)
**Content**
- About V_CHAT_SDK
- About Micro Service
- Featurs
- Requirements
- How V_CHAT_SDK works
- Android installation
- Ios installation
- public apis
- Support new language Or override
- How to get Backend code
- Comman questions
---


# About V_CHAT_SDK
this package which written in pure dart help you to add chat functionality  
unlimited text/image/vedio/record message and notifiactions
to any existing or new flutter mobile  project  with  any **back-end** service you use.
**V_CHAT_SDK** is easy way to integrate advanced real time message chat with 6 public api only 👌
**V_CHAT_SDK** use **Node js** as backend service and **Firebase** for (push notifiactions only) message data base is **Mongo DB**
---
# About Micro Service
1- less load on your main server since chat has high trafic
2- They enable scale. Scalability is about more than the ability to handle more volume. It’s also about the effort involved. Microservices make it easier to identify scaling bottlenecks and then resolve those bottlenecks at a per-microservice level.
3- They are relatively easy to build and maintain. Their single-purpose design means they can be built and maintained by smaller teams. Each team can be cross-functional while also specialise in a subset of the microservices in a solution.

---
# Featurs
| Name          | Android|Ios
| ------------- |:-------------:| -----:|
| online/offline      | 👍 | 👍
| textMessage/typing...      | 👍 |👍 |
| voiceRecord/recording... | 👍 |👍 |
| sned video/file/images | 👍 |👍 |
| cache all media | 👍 |👍 |
| message notifiaction  | 👍 |👍 |
| mute/un mute notifiaction | 👍 |👍 |
| block/un block users | 👍 |👍 |
| smooth performace | 👍 |👍 |
---
# Requirements
login system in your app
and vps server for host node js you can buy it from any provider like degital ocean or hostinger
---
# How V_CHAT_SDK works
vchat connected with your backend service **HOW!**
when you regester new user in your system you should call this public api
```dart
  await VChatController.instance.register(VChatRegisterDto(
    name: name,
    password: password,
    email: email,
    userImage: null,
  ));
```
i just need basic information like unique id and password and your image to identify user in rooms view
email must be unique email is string you can pass phone number or any thing
this api will save the user also in your node js data base to use it later in chats
so when you want to start new chat just send me the peer email becouse its unique in vchat and your system so i can identfy the user
same as login
v chat use access token and save it local it save login sections
so by this way the two systems are in sync
there are alos other public api like change name or password will descuse later
all chats and messages and files images videos saved on node js service
---
#Android installation
in android/app/src/main/AndroidManifest.xml add this permissions.
```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```
then add in application
```
android:requestLegacyExternalStorage="true"
android:usesCleartextTraffic="true"
```
Example
```
    <application
        android:icon="@mipmap/ic_launcher"
        android:label="v_chat_sdk_example"
        android:requestLegacyExternalStorage="true"
        android:usesCleartextTraffic="true">
```
(optional recommended) add
fcm high notifiaction periorty
```
     <meta-data
           android:name="com.google.firebase.messaging.default_notification_channel_id"
           android:value="high_importance_channel" />
```
under
```
    <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
```
finished with AndroidManifest      
open android/build.gradle
update ext.kotlin_version to
this required by **audioplayers** package
```
    ext.kotlin_version = '1.4.32' 
```

this required by video_player
```
     under 
        repositories { 
        add this 
        maven {
            url 'https://google.bintray.com/exoplayer/'
        }
        maven { url 'https://plugins.gradle.org/m2/' }
    }
```

```
     under dependencies {
     update all to  
        classpath 'com.android.tools.build:gradle:4.1.3'
        classpath 'com.google.gms:google-services:4.3.5'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
```
then open android/app/build.gradle
```
     under 
      defaultConfig {
      add or update
        minSdkVersion 18
        targetSdkVersion 30
        multiDexEnabled true 
```
---
# Ios installation
---
# public apis
---
# Support new language Or override
---
# How to get Backend code
---
# Comman questions
---

