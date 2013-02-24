//
//  HttpClient.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "Reachability.h"

@implementation HttpClient

+(HttpClient *)sharedHttp
{
    static HttpClient *instnace;
    static dispatch_once_t run_once;
    dispatch_once(&run_once,^{
        instnace =[[HttpClient alloc] init];
    });
    return instnace;
}
-(void)online{
    //Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    reach.reachableBlock = ^(Reachability *reach){
        NSLog(@"Internet");
        self.isInternet = YES;
    };
    reach.unreachableBlock=^(Reachability *reach){
        NSLog(@"no internet");
        self.isInternet = NO;
    };
    [reach startNotifier];
    /*
    AFHTTPClient *client =[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==AFNetworkReachabilityStatusNotReachable){
            //not reachable
            NSLog(@"no internet");
        }else{
            //reachable
            NSLog(@"internet");
        };
        if (status==AFNetworkReachabilityStatusReachableViaWiFi){
            // on wifi;
            NSLog(@"wifi");
        }
    }];
     */
    
    /*
    AFHTTPClient *httpClient =[[AFHTTPClient alloc] init];
    
    NSLog(@"network status=%d",httpClient.networkReachabilityStatus);
    return httpClient.networkReachabilityStatus==AFNetworkReachabilityStatusReachableViaWWAN || httpClient.networkReachabilityStatus==AFNetworkReachabilityStatusReachableViaWiFi;
     */
}
-(void)request:(NSString *)path method:(NSString *)method parameter:(NSDictionary *)parameter block:(void (^)(id json))processJson{
    NSURL *url = [NSURL URLWithString:ServerUrl];
    AFHTTPClient *httpClient =[[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request=[httpClient requestWithMethod:method  path:path parameters:parameter];
   // NSLog(@"Request=%@",request.URL);
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"success");
        NSError *error = nil;
        id jsonResult =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
        //NSLog(@"get Result=%@",jsonResult);
        processJson(jsonResult);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Access server error:%@,because %@",error,operation.request);
        
    }];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}
-(void)get:(NSString *)path block:(void (^)(id json))processJson
{
    [self request:path method:@"GET" parameter:nil block:processJson];
}
-(void)post:(NSString *)path parameters:(NSDictionary *)parameters block:(void (^)(id json))processJson
{
    [self request:path method:@"POST" parameter:parameters block:processJson];
}
@end
