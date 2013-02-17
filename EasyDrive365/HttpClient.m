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
-(BOOL)online{
    AFHTTPClient *httpClient =[[AFHTTPClient alloc] init];
    NSLog(@"network status=%d",httpClient.networkReachabilityStatus);
    return httpClient.networkReachabilityStatus==AFNetworkReachabilityStatusReachableViaWWAN || httpClient.networkReachabilityStatus==AFNetworkReachabilityStatusReachableViaWiFi;
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
        NSLog(@"get Result=%@",jsonResult);
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
