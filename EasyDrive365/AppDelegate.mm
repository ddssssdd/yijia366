//
//  AppDelegate.m
//  EasyDrive365
//
//  Created by Fu Steven on 1/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AppSettings.h"
#import "BMapKit.h"
#import "ViewController.h"
#import "ShowLocationViewController.h"
#import "ProviderListController.h"
#import "ArticleListController.h"
#import "SettingsViewController.h"
#import "GoodsListController.h"

#define TAG_HOMEPAGE 0
#define TAG_INSURANCE 1
#define TAG_PROVIDER 2
#define TAG_ARTICLE 3
#define TAG_SETTINGS 4

@interface AppDelegate(){
    BMKMapManager *_mapManager;
    UITabBarController *_tabbarController;
    
}
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[AppSettings sharedSettings] get_latest];
    
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"1680f38dadab9089d45bedcca6080876" generalDelegate:nil];
    if (!ret){
        NSLog(@"Start map failure.");
    }
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    if (launchOptions!=nil){
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary !=nil){
            
            [self addMessageFromRemoteNotification:dictionary];
        }
    }
    
    //[self setup_display];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    /*
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationController;
     */
    _tabbarController =[[UITabBarController alloc] init];
    [self createControllers];
    self.window.rootViewController = _tabbarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)createControllers{
    ViewController *vcHome =[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    ShowLocationViewController *vcMap = [[ShowLocationViewController alloc] initWithNibName:@"ShowLocationViewController" bundle:nil];
    vcMap.isFull = YES;
    ProviderListController *vcProvider =[[ProviderListController alloc] initWithStyle:UITableViewStylePlain];
    ArticleListController *vcArticle=[[ArticleListController alloc] initWithStyle:UITableViewStylePlain];
    SettingsViewController *vcUser = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    GoodsListController *vcGoods = [[GoodsListController alloc] initWithStyle:UITableViewStylePlain];
    
    UITabBarItem *item0=[[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"toolbar/zhuye.png"] tag:TAG_HOMEPAGE];
    UITabBarItem *item1=[[UITabBarItem alloc] initWithTitle:@"保险" image:[UIImage imageNamed:@"toolbar/baoxian.png"] tag:TAG_INSURANCE];
    UITabBarItem *item2 =[[UITabBarItem alloc] initWithTitle:@"附近" image:[UIImage imageNamed:@"toolbar/shanghu.png"] tag:TAG_PROVIDER];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"百科" image:[UIImage imageNamed:@"toolbar/baike.png"] tag:TAG_ARTICLE];
    
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"用户" image:[UIImage imageNamed:@"toolbar/yonghu.png"] tag:TAG_SETTINGS];
    
    UINavigationController *menu0 = [[UINavigationController alloc] initWithRootViewController:vcHome];
    menu0.tabBarItem  = item0;
    
    //UINavigationController *menu1 = [[UINavigationController alloc] initWithRootViewController:vcMap];
    UINavigationController *menu1 = [[UINavigationController alloc] initWithRootViewController:vcGoods];
    menu1.tabBarItem  = item1;
    
    UINavigationController *menu2 = [[UINavigationController alloc] initWithRootViewController:vcProvider];
    menu2.tabBarItem  = item2;
    
    UINavigationController *menu3 = [[UINavigationController alloc] initWithRootViewController:vcArticle];
    menu3.tabBarItem  = item3;

    UINavigationController *menu4 = [[UINavigationController alloc] initWithRootViewController:vcUser];
    menu4.tabBarItem  = item4;
    
    _tabbarController.viewControllers =@[menu0,menu1,menu2,menu3,menu4];
    
}
-(void)setup_display{
    UIImage *gradientImage44 = [[UIImage imageNamed:@"surf_gradient_textured_44"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *gradientImage32 = [[UIImage imageNamed:@"surf_gradient_textured_32"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:gradientImage32
                                       forBarMetrics:UIBarMetricsLandscapePhone];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [[AppSettings sharedSettings] check_update:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [AppSettings sharedSettings].deviceToken=[deviceToken description];
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed to get token,error:%@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [self addMessageFromRemoteNotification:userInfo];
}
-(void)addMessageFromRemoteNotification:(NSDictionary *)payload{
    NSLog(@"received notificaiton:%@",payload);
    
}
@end
