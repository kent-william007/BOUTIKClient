//
//  BTGlobalVariable.h
//  BOUTIKClient
//
//  Created by Kent on 15/11/16.
//  Copyright (c) 2015年 kent. All rights reserved.
//

#ifndef BOUTIKClient_BTGlobalVariable_h
#define BOUTIKClient_BTGlobalVariable_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960),[[UIScreen mainScreen] currentMode].size) : NO)
#define ScreenWidth  [[UIScreen mainScreen]bounds].size.width
#define ScreenHeight [[UIScreen mainScreen]bounds].size.height

#endif
