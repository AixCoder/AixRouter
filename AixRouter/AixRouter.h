//
//  AixRouter.h
//  AixRouter
//
//  Created by liuhongnian on 16/8/24.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIViewController;

@interface AixRouter : NSObject

+ (instancetype)sharedInstance;

- (void)mapUrl:(NSString *)routerUrl toController:(Class)controllerClass;
- (UIViewController *)matchViewController:(NSString*)url;

@end
