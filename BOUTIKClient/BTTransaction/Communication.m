//
//  Communication.m
//  BOUTIKClient
//
//  Created by Kent on 15/11/20.
//  Copyright © 2015年 kent. All rights reserved.
//

#import "Communication.h"
#import "MKNetworkKit.h"

@implementation Communication

+ (instancetype)sharedInstance
{
    static Communication *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Communication alloc]init];
    });
    return instance;
}

- (void)communicationHostName:(NSString *)hostName andpath:(NSString *)path andParameters:(NSDictionary *)params andSuccess:(CommunicationSuccess)success andFailure:(CommunicationFailure)failure
{
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];

    path  = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc]initWithHostName:hostName customHeaderFields:header];
    MKNetworkOperation *op = [engine operationWithPath:path params:nil httpMethod:@"GET" ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
//        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        success(@"abc",[operation responseJSON],1);
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
//        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
        failure(path,err);
    }];
    
    [engine enqueueOperation:op];

}

@end
