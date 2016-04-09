//
//  CommunicationConfig.m
//  BOUTIKClient
//
//  Created by Kent on 15/11/24.
//  Copyright © 2015年 kent. All rights reserved.
//

#import "CommunicationConfig.h"


#if ENVIROMENT
NSString *url = @"120.24.69.76:8983/solr/collection2";//test
//NSString *url = @"10.14.37.85:8088/Loan";
//NSString *url = @"10.14.36.221:8080/Loan";


NSString *fixUrl = @"?_locale=zh_CN&BankId=9999";
NSString *raccept = @"application/mobilejson";
NSString *userAgent = @"CSII_PA_IPHONE LoanBankApp/";
NSString *contentType = @"application/mobilejson";
BOOL isValidSSLCertificate = YES;
BOOL isSSL = YES;
NSString *method = @"POST";
//测试公钥
NSString *encryptionPlatformModulus=@"c979990c2eb208766dd25e450f1adbebdab9f1bd77d6eafcc6ce801ded11ae37c0c90c93fce2d0adc04cb006ffc4ef561de00b7cb24487861cb835304aaddeb5c6af2fcbdd829edfb9f822cfc2d8042f7179e2d96075f42b3787c864983b16b06c7a0085fe319b52877ceeb82a3eedaf362319698b6e203bd4a4f41e253da7c3";

//贷贷网银跳转地址
//NSString *daidaiRequestUrl = @"https://ibp-stg3.pingan.com.cn:8443/ibp/WAPEBank/DDpingan/www/DDApp.html#outlogin/DDVerify/index";
NSString *daidaiRequestUrl = @"http://ibp-stg4.pingan.com.cn:8080/ibp/WAPEBank/DDpingan/www/DDApp.html#outlogin/DDVerify/index";
//在线客服配置
NSString *g_onlineChat_WeAppNo = @"ORANGE_09";
NSString *g_onlineChat_BusinessType = @"ORANGE_WEB";
NSString *g_onlineChat_host = @"eim-talk-stg.dmzstg.pingan.com.cn";
NSInteger g_onlineChat_port = 8141;
NSString *g_onlineChat_endPoint = @"/appim-pir";



#else

//生产公钥fa
//NSString *url = @"ebank.sdb.com.cn/loanbankapp";
NSString *url = @"emcbol.orangebank.com.cn/loanbankapp";
NSString *fixUrl = @"?_locale=zh_CN&BankId=9999";
NSString *raccept = @"application/mobilejson";
NSString *userAgent = @"CSII_PA_IPHONE LoanBankApp/1.0";
NSString *contentType = @"application/mobilejson";
BOOL isValidSSLCertificate = NO;
BOOL isSSL = YES;
NSString *method = @"POST";
NSString *daidaiRequestUrl = @"https://bank.pingan.com.cn/ibp/WAPEBank/DDpingan/www/DDApp.html#outlogin/DDVerify/index";
NSString *encryptionPlatformModulus =  @"D34E8935D58322F7D26F9F234F32367C4ABE364DFA0476D1711FD46DF7326FA86B94D728858377AA967CC2C1778AA2ED738F1F9FB91B0E7E8CD02671B033204330FB074C6E32F41B8AC6AE8EE0F0BCFDCBC820982BB477D4DF43C18B5005BFE8770A5353075C357107535ACB39AF95156349D6F705E770181A0034B1D2393F1B";

//在线客服配置
NSString *g_onlineChat_WeAppNo = @"ORANGE_09";
NSString *g_onlineChat_BusinessType = @"ORANGE_WEB";
NSString *g_onlineChat_host = @"eim.pingan.com.cn";
NSInteger g_onlineChat_port = 8141;
NSString *g_onlineChat_endPoint = @"/appim";

#endif

