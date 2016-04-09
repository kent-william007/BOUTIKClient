//
//  Communication.h
//  BOUTIKClient
//
//  Created by Kent on 15/11/20.
//  Copyright © 2015年 kent. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * 环境设置，缺省值为
 */
typedef enum {
    Product = 0,
    Test,
    Developent
}WorkMode;

@protocol CommicationDelegate <NSObject>

/*
 *  服务端返回数据的回调方法，data为服务端返回的数据，action为对应的actionName
 *  如果返回的数据中包含ReturnCode字段且为444444，则相应的ReturnMessage字段为错误信息（http错误信息）。否则都为服务端返回的数据。
 *  服务端返回的数据若含字段ReturnCode且为000000则为正确的返回数据。
 */
@optional
- (void)getReturnDataFromServer:(id)data withActionName:(NSString *)action;

@end

@interface Communication : NSObject
typedef void (^CommunicationSuccess)(NSString *transName,id respondseObject,int dataType);
typedef void (^CommunicationFailure)(NSString *transName,NSError *error);
/*
 *初始化方法
 */
+ (instancetype)sharedInstance;
@ property (nonatomic,weak)id<CommicationDelegate>  delegate;
- (void)communicationHostName:(NSString *)hostName andpath:(NSString *)path andParameters:(NSDictionary *)params andSuccess:(CommunicationSuccess)success andFailure:(CommunicationFailure)failure;



/*
 *设置环境，默认为生存环境
 */
- (void)getWorkModeState:(WorkMode)mode;

/*
 *  url格式：url=@"http://192.168.0.1:8080/pweb",如果为生产环境，url==nil，其他情况需要url
 *  actionName例如：login.do
 *  json一般为字典类型或者为nil
 *  PostToServerStream获取数据流的时候使用
 */
- (void)postToServer:(id)json actionName:(NSString *)action postUrl:(NSString *)url;
- (void)PostToServerStream:(id)json actionName:(NSString*)action postUrl:(NSString*)url;

//WEB模块 通讯接口
-(void)PostToServer:(id)json  actionName:(NSString*)action method:(NSString*)method;

@end
