# V_Chat_SDK Micro service


**Quick Review**
![carbon](https://user-images.githubusercontent.com/37384769/137525753-03155709-c903-4b4d-89bf-ee40e0525d63.png)
**Content**
- About V_CHAT_SDK
- About Micro Service
- Features
- Requirements
- How V_CHAT_SDK works
- Android installation
- Ios installation
- public apis
- Support new language Or override
- How to get Backend code
- Common questions
---


# About V_CHAT_SDK
<ul>
  <li>this package which written in pure dart help you to add chat functionality</li>
  <li>unlimited text/image/video/record message and notifications</li>
  <li>to any existing or new flutter mobile  project  with  any **back-end** service you use</li>
  <li>**V_CHAT_SDK** is easy way to integrate advanced real time message chat with 6 public api only 👌</li>
  <li>**V_CHAT_SDK** use **Node js** as backend service and **Firebase** for (push notifications only) message data base is **Mongo DB**</li>
</ul> 

---
# About Micro Service
<ul>
  <li>
    1- less load on your main server since chat has high traffic
  </li>
  <li>
    2- They enable scale. Scalability is about more than the ability to handle more volume. It’s also about the effort involved. Microservices make it easier to identify scaling bottlenecks and then resolve those bottlenecks at a per-microservice level.
  </li>
  <li>
   3- They are relatively easy to build and maintain. Their single-purpose design means they can be built and maintained by smaller teams. Each team can be cross-functional while also specialise in a subset of the microservices in a solution.
  </li>
</ul>  




---
# Featurs
<table>
  <tr>
    <th>Name</th>
    <th>Android</th>
    <th>Ios</th>
  </tr>

  <tr>
    <td>online/offline</td>
    <td>👍</td>
    <td>👍</td>
  </tr>

  <tr>
    <td>textMessage/typing...</td>
    <td>👍</td>
    <td>👍</td>
  </tr>


  <tr>
    <td>voiceRecord/recording...</td>
    <td>👍</td>
    <td>👍</td>
  </tr>


  <tr>
    <td>saned video/file/images</td>
    <td>👍</td>
    <td>👍</td>
  </tr>

  <tr>
    <td>cache all media</td>
    <td>👍</td>
    <td>👍</td>
  </tr>

  <tr>
    <td>message notification</td>
    <td>👍</td>
    <td>👍</td>
  </tr>


  <tr>
    <td>mute/un mute notification</td>
    <td>👍</td>
    <td>👍</td>
  </tr>

 <tr>
    <td>block/un block users</td>
    <td>👍</td>
    <td>👍</td>
  </tr>

 <tr>
    <td>message status/read/unread</td>
    <td>👍</td>
    <td>👍</td>
  </tr>

 <tr>
    <td>smooth performance</td>
    <td>👍</td>
    <td>👍</td>
 </tr>
</table>
 
---
# Requirements

>login system in your app
and vps server for host node js you can buy it from any provider like digital ocean or hostinger


---
# How V_CHAT_SDK works
vchat connected with your backend service **HOW!** <br />
when you register new user in your system you should call this public api <br />
```dart
  await VChatController.instance.register(VChatRegisterDto(
    name: name,
    password: password,
    email: email,
    userImage: null,
  ));
```
<ul>
  <li>i just need basic information like unique id and password and your image to identify user in rooms view</li>

  <li>email must be unique email is string you can pass phone number or any thing</li>
  <li>this api will save the user also in your node js data base to use it later in chats</li>
  <li>so when you want to start new chat just send me the peer email because its unique in vchat and your system so i can identify the user
same as login</li>
  <li>v chat use access token and save it local it save login sections</li>
  <li>so by this way the two systems are in sync</li>
  <li>there are also other public api like change name or password will discussed later</li>
  <li>all chats and messages and files images videos saved on node js service</li>

</ul>


# Android installation
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
fcm high notification priority
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
finished with AndroidManifest <br />       
open android/build.gradle <br />
update ext.kotlin_version to <br />
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
     compileSdkVersion 31
     
     under 
      defaultConfig {
      add or update
        minSdkVersion 18
        targetSdkVersion 31
        multiDexEnabled true 
```
---
# Ios installation
---
# public apis and installion
## 1- install
first you need to await v chat init in main.dart
```dart
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();
  await VChatController.instance.init(
    baseUrl: Uri.parse("http://10.0.2.2:3000"),
    appName: "test_v_chat",
    isUseFirebase: true,
    lightTheme: vChatLightTheme,
    darkTheme: vChatDarkTheme,
    enableLogger: true,
    navigatorKey: navigatorKey,
    maxMediaUploadSize: 50 * 1000 * 1000, //~ 50 mb
  );
```
<ol>
  <li>
    baseUrl => your node js server ip  
    </li>
  <li>
    appName => to save files in internal storage with this folder name internalStorage/documents/{appName} 
    </li>
  <li>
    isUseFirebase => set to true if firebase supported in your country and your project connected to firebase project  
    </li>
  <li>
    lightTheme => overrideTheCustomTheme for light 
    </li>
  <li>
    darkTheme => overrideTheCustomTheme for dark  
    </li>
  <li>
   enableLogger => if true vchat will print the warning in console in release mode it will disable automatically 
    </li>
  <li>
     navigatorKey => add this key also in MaterialApp 
    </li>
</ol>

```
MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: SplashScreen(),
);
```
don't forget to enable BotToast in MaterialApp
and add it in your pubspec.yaml

## 2- Register
First register on your system (your backend)
then register in vChat
```
  try{
        await VChatController.instance.register(
        VChatRegisterDto(
          name: name,
          userImage: imagePath == null ? null : File(imagePath!),
          email: email,
          password: password,
        ),
      );
  } on VChatSdkException catch(err){
     // handle vchat exception here
      rethrow;
  }
```
if your system allow users to register without image pass it null <br />
it will user the default image you can change it in backend public/profile/default_user_image.png  
name => user full name <br />
Email => can be phone number or any unique id not validation on it <br />
Note this function throw this exceptions <br />
1- User already in v chat data base <br />
2- No internet connection <br />
## 2- Login
```
      try {
        await VChatController.instance
            .login(VChatLoginDto(email: email, password: password));
      } on VChatSdkException catch (err) {
        //handle v chat login exception
        rethrow;
      }
```
Note this function throw this exceptions <br />
1- User not in v chat data base Or wrong password <br />
2- No internet connection <br />

## 3- set user online
make sure to use this function only if user already authorized in vchat system and your system <br />
other will throw "You must login or register to v chat first delete the app and login again !" <br />
wrap it with if condition
```
if(isAuth){
   // make sure to auth
   VChatController.instance.bindChatControllers(); 
}
```
**call this method in home page because it will make the user online and start notifications service** <br />
## 4- create Single Chat
this method will show alert dialog if there is no rooms and ask for first message <br />
if there chat will open the change page direct <br />
```
  try {
      await VChatController.instance
          .createSingleChat(ctx: context, peerEmail: widget.user.email);
    } on VChatSdkException catch (err) {
      //handle create chat exceptions
      rethrow;
    }
```
**peerEmail => is the unique identifier that  you pass to vchat when register**
this function throw
1- you cant start chat if you start chat your self <br />
2- Exception if peer Email Not in v chat Data base ! so first you must (migrate all users only if aready in production and need to add chat) new project all will be fine <br />
3- No internet connection <br />

## 4- change user name
when user change his name then you need to update his name in v chat also to change his name in rooms <br />
```
    try {
      await VChatController.instance.updateUserName(name: "new name");
    } on VChatSdkException catch (err) {
      //handle Errors
    }
```
## 5- change user password
```
    try {
      await VChatController.instance.updateUserPassword(newPassword: "new",oldPassword: "old");
    } on VChatSdkException catch (err) {
      //handle Errors
    }
```

## 6- change user image
```
    try {
      await VChatController.instance.updateUserImage( imagePath: file.path!);
    } on VChatSdkException catch (err) {
      //handle Errors
    }
```
## 7- stop/enable notifiactions
```
  await VChatController.instance.stopAllNotification();
  await VChatController.instance.enableAllNotification();
```
## 8- logOut
```
await VChatController.instance.logOut();
```
---
# Support new language Or override .
to support new language create new class and extend VChatLookupString  
and ovrride all
```
class ArEg extends VChatLookupString {
  @override
  String areYouSure() => "هل انت نتاكد؟";

  @override
  String cancel() => "الغاء";

  @override
  String chatHasBeenClosed() => "انتهت المحادثه !";
  
```
then in main.dart after vchat.init define the new language
```
  VChatController.instance.setLocaleMessages(languageCode: "ar", countryCode: "EG", lookupMessages: ArEg());
```
by defauld english Us and arabic Eg supported you can override it with the same way <br />
when you chage app laguage vchat will automtic chage but you must put the countryCode

---
# How to get Backend code
---
# Common questions
1- image compress
2- video compress
3- migrate old users
4- vchat auth
---

