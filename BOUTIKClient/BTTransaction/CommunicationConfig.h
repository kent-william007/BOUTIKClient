//
//  CommunicationConfig.h
//  BOUTIKClient
//
//  Created by Kent on 15/11/24.
//  Copyright © 2015年 kent. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ENVIROMENT 1    //是否是测试环境
#define USE_LOCAL_MENU 1  //是否使用本地菜单

extern NSString *url;//请求的基本url
extern NSString *fixUrl;//请求的后面拼接的东西，可以为空
extern NSString *raccept;//请求头的信息
extern NSString *userAgent;
extern NSString *contentType;
extern BOOL isValidSSLCertificate;
extern NSString *encryptionPlatformModulus;//加密的公钥
extern BOOL isSSL;
extern NSString *method;
extern NSString *zxzkRequestUrl;//在线智库访问地址
extern NSString *daidaiRequestUrl;//贷贷网银跳转地址

extern NSString *g_onlineChat_WeAppNo;
extern NSString *g_onlineChat_BusinessType;
extern NSString *g_onlineChat_host;
extern NSInteger g_onlineChat_port ;
extern NSString *g_onlineChat_endPoint;

