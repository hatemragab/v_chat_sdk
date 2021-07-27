# vchat_package
this package which written in pure dart help you to add chat functionality  
make sure to star and watch all activity on github to get notify about updates. 
to any existing flutter mobile project with any state management and any back-end service. 
NOTE this package depend on firebase on notifications only Data saved on your vps server which run node js on it. 
this package provide public api such createSingleChat login register etc.  
to make it easy to integrate. 
HOW this package works. 
vchat connected with node js which will be uploaded to your host this will create mongodb to store the chats ont it. 
all data saved one your host not firebase. 
Full customizable you can change  any text or theme this package support dark mode this because it Embedded as files on the project to make it easy to customize
i have create test node js server and uploaded it to test only in this test the notifications doesn't work since it need to add your firebase. 
cloud key in the node js but when run your own server it will works. 

flutter app requirements:  

you need to have login system on your project and support null safety. 

backend requirements:

create new vps at digital ocean or any provider and install node js v v14.17.1 and any mongodb v above 3.6. 

HOW TO TEST with not backend serve just with  (there another example to integrate with laravel api). 
first we need to add sum configurations for android. 
1 - create new flutter project project. 

in android/app/src/main/AndroidManifest.xml add this permissions. 

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

    and in application
    under android:label="app-name" add this 
    
    android:requestLegacyExternalStorage="true"
    android:usesCleartextTraffic="true"
    
    (optional recommended) and under
    <meta-data
            android:name="flutterEmbedding"
            android:value="2" />

    add this for high notifications priority
     <meta-data
           android:name="com.google.firebase.messaging.default_notification_channel_id"
           android:value="high_importance_channel" />
     finished with AndroidManifest      
     
     open android/build.gradle
     
     update ext.kotlin_version to =>>> '1.4.32'
     
     under 
        repositories { 
        add this 
        maven {
            url 'https://google.bintray.com/exoplayer/'
        }
        maven { url 'https://plugins.gradle.org/m2/' }
        
     under dependencies {
     update all to  
        classpath 'com.android.tools.build:gradle:4.1.3'
        classpath 'gradle.plugin.com.onesignal:onesignal-gradle-plugin:[0.12.10, 0.99.99]'
        classpath 'com.google.gms:google-services:4.3.5'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        
     then open android/app/build.gradle  
     under 
      defaultConfig {
      add 
        minSdkVersion 18
        targetSdkVersion 30
        multiDexEnabled true 
        
  -------------   android configuration finished   -----------  
  
  add dependency to pubspec.yaml. 
  ```
  #V_CHAT_PACKAGES DON'T UPDATE ANY VERSION IT IS ON YOUR OWN I WILL UPDATE IT AND PUSH TO GITHUB
  http: ^0.13.3
  textless: ^6.6.6
  get: 4.1.4
  get_storage: ^2.0.2
  dio: 4.0.0
  firebase_core: ^1.3.0
  firebase_messaging: ^10.0.2
  image_picker: ^0.8.1+4
  sqflite: ^2.0.0+3
  path_provider: ^2.0.2
  socket_io_client: ^1.0.1
  intl: ^0.17.0
  clipboard: ^0.1.3
  file_picker: ^3.0.3
  flutter_native_image: ^0.0.6+1
  permission_handler: ^8.1.2
  flutter_video_info: ^1.2.0
  video_thumbnail: ^0.3.3
  video_player: ^2.1.10
  record: ^3.0.0
  stop_watch_timer: ^1.3.1
  audioplayers: ^0.19.0
  open_file: ^3.2.1
  photo_view: ^0.11.1
  chewie: ^1.2.2
  cached_network_image: ^3.0.0
  timeago: ^3.1.0
  auto_direction: ^0.0.5
  flutter_local_notifications: ^6.0.0
  bot_toast: ^4.0.1
  readmore: ^2.1.0
  google_fonts: ^2.1.0
  ```
Use VChatRoomsView widget to view user rooms 
Use public api 
```
 call this with your register system you have to register 2 times one on your system another on my vchat system
 VChatController.instance.register(VchatRegisterDto())
 if your system not fource the user to add image then pass image parapater null and it will add the defualt user image to it
 this api throw exception if data is missing all required except image can be null you have tp pass null if no image and throw if email exist  should try and catch 

 if you aready have account then login you need to login two times in your system and vchat system 
 this api throw exception if your not exist on db or wrong password 
 VChatController.instance.login(VChatLoginDto())

 if you want to start chat from any where just call this api 
 VChatController.instance.createSingleChat(VChatLoginDto()) and pass the user email which is uniqe on your system and vchat system 
 this api throw exception if you start chat your self you should try and catch 
 if first time to chat with this user dialog will appear and ask for first message else will open chat page 
 

```