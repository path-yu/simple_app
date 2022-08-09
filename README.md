# simple_app

这是一个好玩的flutter项目, 仅供学习，喜欢的话请点个star。

## 主要有这四大核心应用
  1. 代办事项
  2. 便签
  3. 计算器
  4. 计时器

## 功能点如下

1. 国际化(支持中英文语言环境切换)
2. 夜间模式
3. 下拉加载数据
4. 权限申请和本地通知
5. sqlite持久化储存
6. 启动页
7. 富文本编辑
8. 防误触退出App
9. 便签长按多选删除
10. todo置顶or取消置顶
11. todoList删除新增展开动画
12. todo滑动列表右滑菜单
13. 计算器表达式字体放大缩小动画,字体自动缩放大小
14. 便签列表瀑布流展示
15. 微光背景
16. 新拟物风格ui
17. 音乐播放振动
18. ...

## 环境配置如下

```
 Flutter (Channel stable, 2.10.0, on Microsoft Windows [Version 10.0.19043.1526], locale zh-CN)
    • Flutter version 2.10.0 at D:\software\flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 5f105a6ca7 (3 weeks ago), 2022-02-01 14:15:42 -0800
    • Engine revision 776efd2034
    • Dart version 2.16.0
    • DevTools version 2.9.2
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn

[√] Android toolchain - develop for Android devices (Android SDK version 32.0.0)
    • Android SDK at C:\Users\Admin\AppData\Local\Android\sdk
    • Platform android-32, build-tools 32.0.0
    • Java binary at: D:\software\AndroidStudio\jre\bin\java
    • Java version OpenJDK Runtime Environment (build 11.0.10+0-b96-7249189)
    • All Android licenses accepted.
```
推荐安装 2.10.0 版本 [flutter](https://storage.flutter-io.cn/flutter_infra_release/releases/stable/windows/flutter_windows_2.10.0-stable.zip)
###  Flutter 设定镜像配置环境变量
```shell
 set PUB_HOSTED_URL=https://pub.flutter-io.cn
 set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

## 打包部署命令
```shell
flutter build apk --obfuscate --split-debug-info=splitMap --target-platform android-arm,android-arm64,android-x64 --split-per-abi
```
## 打包arm64架构app
```
flutter build apk --obfuscate --split-debug-info=splitMap --target-platform android-arm64
```

### app相关截图如下
![calculator.png](https://upload-images.jianshu.io/upload_images/20032554-c2a1648a1a6f9a13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![count_down_home.png](https://upload-images.jianshu.io/upload_images/20032554-f4e79de1d8b68b92.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![count_down_ing.png](https://upload-images.jianshu.io/upload_images/20032554-9aaea95e175e65a8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![edit_creae_note_page.png](https://upload-images.jianshu.io/upload_images/20032554-23bf59b5385d5852.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![home.png](https://upload-images.jianshu.io/upload_images/20032554-7382a36eab4379f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![note_page.png](https://upload-images.jianshu.io/upload_images/20032554-f71aa2c730780b19.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![setting.png](https://upload-images.jianshu.io/upload_images/20032554-34701e3d1497d6c8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![startPage.png](https://upload-images.jianshu.io/upload_images/20032554-7c4be9756b500435.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![stick_todoList.png](https://upload-images.jianshu.io/upload_images/20032554-ce7d45c828dbfb45.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![todoList.png](https://upload-images.jianshu.io/upload_images/20032554-f1430f7df3650799.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

