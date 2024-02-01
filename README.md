### OpenIM
A OpenIM flutter demo, only support android and ios.



### 当前项目运行环境：flutter stable3.7.12



### 源码使用

##### 1，替换 app icon

- ###### 将你的应用的icon设计图放到launcher_icon文件夹中，命名为app-icon.png

- ###### 执行命令:

```dart
  flutter pub get
  flutter pub run flutter_launcher_icons:main
```

##### 2， 替换 app 的名称

- ###### Android：修改 openim/android/app/src/main/res/AndroidManifest.xm文件里 android:label的值

```xml
  <application
    android:icon="@mipmap/ic_launcher"
    android:label="您的应用名"
    android:requestLegacyExternalStorage="true"
    android:usesCleartextTraffic="true"
    tools:replace="android:label">
</application>
```
- ###### ios：用xcode打开工程修改应用名

##### 3，替换 openim/openim_common/lib/src/config.dart 文件里的服务器地址为自己的服务器地址

##### 4，连接并选择真机

##### 5，执行  flutter pub get

##### 6，执行 flutter run



### Issues

##### 1，flutter版本是？

答：stable分支3.7.12

##### 2，支持哪些平台？

答：因为sdk的原因demo目前只能运行在android跟ios设备上

##### 3，android安装包debug可以运行但release启动白屏？

答：flutter的release包默认是开启了混淆，可以使用命令：flutter build release --no -shrink，如果此命令无效可如下操作

在android/app/build.gradle配置的release配置加入以下配置

```
release {
    minifyEnabled false
    useProguard false
    shrinkResources false
}
```

##### 4，代码必须混淆怎么办？

答：在混淆规则里加入以下规则

```
-keep class io.openim.**{*;}
-keep class open_im_sdk.**{*;}
-keep class open_im_sdk_callback.**{*;}
```

##### 5，android安装包不能安装在模拟器上？

答：因为Demo去掉了某些cpu架构，如果你想运行在模拟器上请按以下方式：

在android/build.gradle配置加入

```
ndk {
    abiFilters "arm64-v8a", "armeabi-v7a", "armeabi", "x86", "x86_64"
}
```

##### 6，ios构建release包报错

答：请将cpu架构设置为arm64，然后依次如下操作

- flutter clean
- flutter pub get
- cd ios
- pod install
- 连接真机后运行Archive

![ios cpu](https://user-images.githubusercontent.com/7018230/155913400-6231329a-aee9-4082-8d24-a25baad55261.png)

##### 7，ios运行的最低版本号？

答：13.0

#### 8， 有开发者遇到以下问题：
```
Could not build the precompiled application for the device.
Error (Xcode): Signing for "TOCropViewController-TOCropViewControllerBundle" requires a development team. Select a development team
in the Signing & Capabilities editor.

Error (Xcode): Signing for "DKImagePickerController-DKImagePickerController" requires a development team. Select a development team
in the Signing & Capabilities editor.

Error (Xcode): Signing for "DKPhotoGallery-DKPhotoGallery" requires a development team. Select a development team in the Signing &
Capabilities editor.
```
在Podfile添加以下代码：
```ruby
post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
        config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
        config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"      end
   end
end
```
