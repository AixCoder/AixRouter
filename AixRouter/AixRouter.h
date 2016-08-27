//
//  AixRouter.h
//  AixRouter
//
//  Created by liuhongnian on 16/8/24.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface AixRouter : NSObject

+ (instancetype)sharedInstance;
/**
 *  将URL映射到uiviewcontroller
 简单理解成把每个uiviewcontroller分配一个URL，相当于给uiviewcontroller取一个名字
 *
 *  @param routerUrl
 *  @param controllerClass
 */
- (void)mapUrl:(NSString *)routerUrl toController:(Class)controllerClass;

/**
 *  根据设定的URL匹配到对应的uiviewcontroller
 *
 *  @param url
 *
 *  @return 
 */
- (UIViewController *)matchViewController:(NSString*)url;

@end

@interface UIViewController (AixRouter)

@property (nonatomic,strong) NSDictionary *routerParams;

@end
