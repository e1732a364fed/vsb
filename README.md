# vsb

A verysimple board project.

理解：

如果你用过aria2，那么vsb和verysimple的关系，就类似 ariaNG 和 aria2c 的关系

不过最新版本为安卓版本添加了vpn功能, 使用了 verysimple 1.2.5内核 



## 进展截图


<img width="356" alt="s1" src="https://user-images.githubusercontent.com/75717694/206056411-1af3efd2-aa75-4955-99c4-33d49ea1817e.png">
<img width="355" alt="s2" src="https://user-images.githubusercontent.com/75717694/206056414-6a52d410-ec39-480f-8edf-184b5ecb83c0.png">
<img width="359" alt="s3" src="https://user-images.githubusercontent.com/75717694/206056418-2e4d71b6-814f-4df0-bfe4-a7d2dfb4b208.png">


# 设计
主页：显示目前所有proxy的状态, 点击进入编辑页面

vpn模式下，提供导入拨号配置文件、扫码，以及开启vpn的功能

编辑页面：
1. 有一个删除按钮

配置页面：
1. 配置verysimple的apiserver的url
2. 转换面板模式与vpn模式

FAB: 加号，添加新配置，可以自己配置生成，也可以扫码

# 运行

如果你运行web版的话，要注意，web版无法连接使用自签名证书的 vs api server，所以你只能用有效证书，或者使用-sunsafe参数运行 http明文api server

