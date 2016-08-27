//
//  UserViewController.m
//  AixRouter
//
//  Created by liuhongnian on 16/8/25.
//  Copyright © 2016年 liuhongnian. All rights reserved.
//

#import "UserViewController.h"
#import "AixRouter.h"

@interface UserViewController ()

@end

@implementation UserViewController

+ (instancetype)aix_storyBoardWithParams:(NSDictionary *)params
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UserViewController *userVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserViewController"];
    return userVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
