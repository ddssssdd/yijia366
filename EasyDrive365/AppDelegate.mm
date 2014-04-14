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
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "GuideController.h"
#import "WelcomeViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"


#import "ProviderDetailController.h"
#import "GoodsDetailController.h"

#define TAG_HOMEPAGE 0
#define TAG_INSURANCE 1
#define TAG_PROVIDER 2
#define TAG_ARTICLE 3
#define TAG_SETTINGS 4

@interface AppDelegate()<WXApiDelegate,WeiboSDKDelegate>{
    BMKMapManager *_mapManager;
    UINavigationController *menu0;
    UINavigationController *menu1;
    UINavigationController *menu2;
    UINavigationController *menu3;
    UINavigationController *menu4;

    
}
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[AppSettings sharedSettings] get_latest];
    
    _mapManager = [[BMKMapManager alloc] init];  //old:1680f38dadab9089d45bedcca6080876
    BOOL ret = [_mapManager start:@"P1C8dnBtHzd9DL2bGiEOidtl" generalDelegate:nil];
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
    
    self.window.rootViewController = _tabbarController;
    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openGoods) name:OPEN_GOODS object:nil];
    
    [WXApi registerApp:WEIXIN_APPKEY];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:SINAWEIBO_APPKEY];
    if ([AppSettings sharedSettings].isFirst){
        [AppSettings sharedSettings].isFirst=false;
        [[AppSettings sharedSettings] save];
        GuideController *vc = [[GuideController alloc] initWithNibName:@"GuideController" bundle:nil];
        [_tabbarController presentViewController:vc animated:YES completion:^{
            //for now nothing;
            
        }];
    }else{
        [self createControllers];
    }
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
    UITabBarItem *item1=[[UITabBarItem alloc] initWithTitle:@"商品" image:[UIImage imageNamed:@"toolbar/baoxian.png"] tag:TAG_INSURANCE];
    UITabBarItem *item2 =[[UITabBarItem alloc] initWithTitle:@"服务商" image:[UIImage imageNamed:@"toolbar/shanghu.png"] tag:TAG_PROVIDER];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"百科" image:[UIImage imageNamed:@"toolbar/baike.png"] tag:TAG_ARTICLE];
    
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"用户" image:[UIImage imageNamed:@"toolbar/yonghu.png"] tag:TAG_SETTINGS];
    
    menu0 = [[UINavigationController alloc] initWithRootViewController:vcHome];
    menu0.tabBarItem  = item0;

    //UINavigationController *menu1 = [[UINavigationController alloc] initWithRootViewController:vcMap];
    menu1 = [[UINavigationController alloc] initWithRootViewController:vcGoods];
    menu1.tabBarItem  = item1;
    
    menu2 = [[UINavigationController alloc] initWithRootViewController:vcProvider];
    menu2.tabBarItem  = item2;
    
    menu3 = [[UINavigationController alloc] initWithRootViewController:vcArticle];
    menu3.tabBarItem  = item3;

    menu4 = [[UINavigationController alloc] initWithRootViewController:vcUser];
    menu4.tabBarItem  = item4;
    
    _tabbarController.viewControllers =@[menu0,menu1,menu2,menu3,menu4];
    _tabbarController.delegate = self;
    
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSLog(@"%@",viewController);
    if (![AppSettings sharedSettings].isLogin){
        if (viewController == menu4){
             _tabbarController.selectedIndex =0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_First" object:nil];
            return NO;
        }
    }
    return YES;
}
-(void)openGoods{
    _tabbarController.selectedIndex =1;
}
-(void)logout{
    _tabbarController.selectedIndex =0;
    [menu0 popToRootViewControllerAnimated:YES];
    [menu1 popToRootViewControllerAnimated:YES];
    [menu2 popToRootViewControllerAnimated:YES];
    [menu3 popToRootViewControllerAnimated:YES];
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
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSLog(@"%@",url);
    [self parse:url application:application];
	return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"%@",[url scheme]);
    NSString *scheme = [[url scheme] lowercaseString];
    NSString *host =[[url host] lowercaseString];
    if (url != nil && [[url scheme] compare:WEIXIN_APPKEY] == 0) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if (url != nil && [[url scheme] compare:[NSString stringWithFormat:@"wb%@",SINAWEIBO_APPKEY]] == 0){
       return [WeiboSDK handleOpenURL:url delegate:self];
    }else if (url != nil && [scheme compare:@"easydrive366"] == 0 && [host compare:@"open"]==0) {
        NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",query);
        [self handleOpenCallback:query];
    }else if (url != nil && [scheme compare:@"easydrive366"] == 0 && [host compare:@"safepay"]==0){
        [self parse:url application:application];
    }
    
    return YES;
}
- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
            [[[UIAlertView alloc] initWithTitle:AppTitle message:@"支付成功！" delegate:Nil cancelButtonTitle:@"关闭" otherButtonTitles: nil] show];
            [[NSNotificationCenter defaultCenter] postNotificationName:ALIPAY_SUCCESS object:result];
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            /*
            result = {
                statusCode=9000
                statusMessage=支付结束
                signType=RSA
                signString=ZQU+KoRuM3VvkyHbdQE1vqfQmXSw8fLz4weTzinFNDWIA4qZvCplrVEiIKAFZ4h0A4J4FdeHJnvvhs+JjLT7iTlq3fO9lyaqvm6pUjQZn6lCLAs5RsE2su6mFQnHNmiQL/Be3UG0oQuv3SPi9etxfjMJpTLN8y5mxubmzaNPyUc=
            }
             */
            
            //交易成功
            /*
            NSString* key = @"签约帐户后获取到的支付宝公钥";
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
            }
             */
            
        }
        else
        {
            //交易失败
            [[[UIAlertView alloc] initWithTitle:AppTitle message:@"支付没有成功，请联系客服" delegate:Nil cancelButtonTitle:@"关闭" otherButtonTitles: nil] show];
        }
    }
    else
    {
        //失败
        //[[[UIAlertView alloc] initWithTitle:AppTitle message:@"支付没有成功，请联系客服" delegate:Nil cancelButtonTitle:@"关闭" otherButtonTitles: nil] show];
    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	return [[AlixPayResult alloc] initWithString:query];

}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

-(void)onReq:(BaseReq *)req{
    NSLog(@"%@",req);
}
-(void)onResp:(BaseResp *)resp{
    NSLog(@"%@",resp);
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    NSLog(@"%@",request);
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    NSLog(@"%@",response);
}


-(void)handleOpenCallback:(NSString *)query{
    NSArray *items = [query componentsSeparatedByString:@"&"];
    NSString *type;
    NSString *production_id;
    NSString *name;
    for (NSString *item in items) {
        NSArray *temps = [item componentsSeparatedByString:@"="];
        if ([temps count]==2){
            if ([[temps objectAtIndex:0] isEqualToString:@"type"]){
                type=[temps objectAtIndex:1];
                
                
            }else if ([[temps objectAtIndex:0] isEqualToString:@"id"]){
                production_id = [temps objectAtIndex:1];
            }else if ([[temps objectAtIndex:0] isEqualToString:@"name"]){
                name = [temps objectAtIndex:1];
            }
        }
    }
    if (type && production_id){
        if ([type isEqualToString:@"GDS"]){
            GoodsDetailController *vc =[[GoodsDetailController alloc] initWithStyle:UITableViewStylePlain];
            vc.target_id =[production_id intValue];
            vc.title = name;
            [menu1 pushViewController:vc animated:YES];
            _tabbarController.selectedIndex = 1;

        }else if ([type isEqualToString:@"SPV"]){
            ProviderDetailController *vc = [[ProviderDetailController alloc] initWithStyle:UITableViewStylePlain];
            vc.code= production_id;
            
            vc.name = name;
            [self.navigationController pushViewController:vc animated:YES];
        
            [menu2 pushViewController:vc animated:YES];
            _tabbarController.selectedIndex = 2;
            
        }else if ([type isEqualToString:@"ATL"]){
            
        }
    }
}
@end
