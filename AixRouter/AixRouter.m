//
//  AixRouter.m
//  AixRouter
//
//  Created by liuhongnian on 16/8/24.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "AixRouter.h"
#import <objc/runtime.h>
@import UIKit;

@interface AixRouter ()

@property (nonatomic,strong)NSMutableDictionary *routers;
@property (nonatomic,strong)NSMutableDictionary *cacheRouters;

@end

@implementation AixRouter

+ (instancetype)sharedInstance
{
    static AixRouter *router = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        router = [[AixRouter alloc] init];
    });
    
    return router;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _routers      = @{}.mutableCopy;
        _cacheRouters = @{}.mutableCopy;
    }
    return self;
}

- (void)mapUrl:(NSString *)routerUrl toController:(Class)controllerClass
{
    NSDictionary *param = @{@"UIViewControllerClass":controllerClass};
    
    _routers[routerUrl] = param;
    
}

- (UIViewController *)matchViewController:(NSString *)url
{
    UIViewController *viewController;
    
    NSArray *pathComponents = [self pathComponentsFromRouterUrl:url];
    
    NSDictionary *params = self.cacheRouters[url];
    if (!params) {
        params = [self paramsFromPathComponents:pathComponents];
    }
    //根据参数生成viewcontroller
    if (params) {
        viewController = [self controllerForParams:params];
        _cacheRouters[url] = params;
    }else{
        NSAssert(0, @"URL未匹配成功,");
    }
    return viewController;
}

- (NSArray *)pathComponentsFromRouterUrl:(NSString *)routerUrl
{
    NSMutableArray *pathComponents = @[].mutableCopy;
    
    NSURL *pathURL = [NSURL URLWithString:[routerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSArray *urlComponents = pathURL.pathComponents;
    
    for (NSString *component in urlComponents)
    {
        //把/过滤掉，在后期url参数匹配的时候少循环计算一次
        if ([component isEqualToString:@"/"]) continue;
        
        [pathComponents addObject:[component stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return pathComponents;
}

/**
 *  根据pathComponents匹配到对应的参数
 *
 *  @param pathComponents
 *
 *  @return 参数字典
 */
- (NSDictionary *)paramsFromPathComponents:(NSArray*)pathComponents
{
    NSArray *routerURLKeys = _routers.allKeys;
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    __block BOOL find = NO;
    for (NSString *routerUrl in routerURLKeys) {
        
        NSArray *routerComponents = [self pathComponentsFromRouterUrl:routerUrl];
        
        if (routerComponents.count != pathComponents.count) continue;
        
        [routerComponents enumerateObjectsUsingBlock:^(id  _Nonnull routerComponent, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *pathComponent = pathComponents[idx];
            if ([routerComponent hasPrefix:@":"]){
                NSString *key   = [routerComponent substringFromIndex:1];
                params[key]     = pathComponent;
            }else if (![pathComponent isEqualToString:routerComponent]){
                find = NO;
                *stop = YES;
            }else{
                find = YES;
            }
        }];
        //匹配成功了就停止继续循环匹配
        if (YES == find)
        {
            Class controllerClass = _routers[routerUrl][@"UIViewControllerClass"];
            params[@"viewController_class"] = controllerClass;
            break;
        }
        
    }
    
    return params;
    
}

- (UIViewController *)controllerForParams:(NSDictionary*)routerParams
{
    SEL CLASS_SEL = NSSelectorFromString(@"aix_storyBoardWithParams:");
    SEL INSTANCE_SEL = NSSelectorFromString(@"aix_initWithParams:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    Class controllerClass = routerParams[@"viewController_class"];
    UIViewController *viewController;
    
    if (class_isMetaClass(object_getClass(controllerClass))) {
        if ([controllerClass isSubclassOfClass:[UIViewController class]]) {
            if([controllerClass respondsToSelector:CLASS_SEL]){
                
                viewController = [controllerClass performSelector:CLASS_SEL withObject:routerParams];
            }else if ([controllerClass instancesRespondToSelector:INSTANCE_SEL]){
                viewController = [controllerClass performSelector:INSTANCE_SEL withObject:routerParams];
            }else{
                viewController = [[controllerClass alloc] init];
            }

        }
    }
#pragma clang diagnostic pop
    return viewController;
}

@end
