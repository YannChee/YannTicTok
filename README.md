# YannTicTok
使用swift5.x版本仿写TicTok

使用方法:
下载完成项目后执行 pod install 命令


效果图:


![1.骨架搭建-黑白tab切换](https://upload-images.jianshu.io/upload_images/1216368-6ca68eb8241fea4e.gif?imageView2/0/w/400)
![2.底部loading.gif](https://upload-images.jianshu.io/upload_images/1216368-506c0827f1da31c2.gif?imageMogr2/auto-orient/strip%7CimageView2/0/w/440)
![3.滑动播放视频](https://upload-images.jianshu.io/upload_images/1216368-e451693eb455712e.gif?imageMogr2/auto-orient/strip%7CimageView2/0/w/440) 

###  获取资源文件
- 下载TicTok的安装包.ipa文件
- 提取安装包里面图片资源 (i我用的是OS Images Extractor,也可以用cartool,M1芯片的mac无法运行,只能使用intel芯片的mac)

# 编码部分:

1.由于我这个项目最低适配iOS13,最新Xcode 新建iOS项目时候会新增SceneDelegate文件. 这是因为iOS13之后,Appdelegate不再负责UI生命周期相关方法,交给SceneDelegate处理.所以window rootViewController设置方法写在Appdelegate里面不起作用了,应该写在SceneDelegate 的func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) 方法里
```
 func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow.init(windowScene: windowScene)
        window?.frame = windowScene.coordinateSpace.bounds
        window?.rootViewController = UINavigationController.init(rootViewController: MainTabBarController.init())
        window?.makeKeyAndVisible() 
    }
```



### 2.设置swift 项目的条件编译:
标识可以自定义,例如我的是 MyDebug
在 Build Settings -> Swift Compiler - Custom Flags -> Other Swift Flags -> Debug项 中添加 -D Debug

![](https://upload-images.jianshu.io/upload_images/1216368-187d3bb0129cb0cf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

项目中编写代码使用如下:
```
#if MyDebug
    print("==========这个是debug模式")
#else
    print("==========这个是release模式")
#endif
```

