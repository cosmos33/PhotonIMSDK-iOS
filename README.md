PhotonIMSDK OC 层代码及demo
接入暂时关注以下几个头文件:

PhotonIMClient     im连接相关

PhotonIMClient+HandleSendMessage   im消息发送相关

PhotonIMClient+HandleReceiveMessge  im消息接收相关

PhotonIMClient+HandleDB     im消息存储相关

2.2.14.8

内部实现了httpdns

2.2.14.6

去除referee部分依赖,保留原本port策略,通过回调方式实现httpdns,如果有httpdns库冲突问题可以使用此版本
