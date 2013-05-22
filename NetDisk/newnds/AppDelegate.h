//
//  AppDelegate.h
//  newnds
//
//  Created by fengyongning on 13-4-26.
//
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "MYTabBarController.h"
#import "WeiboSDK.h"
//新浪微博微博
#define kAppKey         @"706445160"
#define kRedirectURI    @"http://www.7cbox.cn"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,WXApiDelegate,WeiboSDKDelegate>
{
    NSString *user_name;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MYTabBarController *myTabBarController;
@property (retain, nonatomic) NSString *user_name;

-(void)setLogin;
-(void) sendImageContentIsFiends:(BOOL)bl path:(NSString *)path;
//微博授权
- (void)ssoButtonPressed;
//微博分享
- (WBMessageObject *)messageToShare:(int)type;
@end
