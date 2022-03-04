# simple_app

这是一个简单的flutter项目

## 主要有这三大核心应用
  1. 代办事项
  2. 便签
  3. 计算器
  4. 计时器

## 功能如下

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
15. ...

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



## 打包部署命令
```shell
flutter build apk --obfuscate --split-debug-info=splitMap --target-platform android-arm,android-arm64,android-x64 --split-per-abi
```
