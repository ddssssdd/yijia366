//
//  HttpHelper.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/17/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "HttpHelper.h"


@implementation HttpHelper
@synthesize delegate =_delegate;
@synthesize url=_url;

-(id)initWithTarget:(id<HttpClientDelegate>)target{
    self =[super init];
    if (self){
        _delegate = target;
    }
    return self;
}
-(void)loadData{
    /* test offline
     id json= [[AppSettings sharedSettings] loadJsonBy:NSStringFromClass([self class])];
     [self.delegate processData:json];
     return;
     */
    [self.delegate setup];
    //not setup _url;
    if (!_url){
        return;
    }
    [[HttpClient sharedHttp] get:_url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            
            [[AppSettings sharedSettings] saveJsonWith:NSStringFromClass( [self.delegate class]) data:json];
            [self.delegate processData:json];
            
        }else{
            //get nothing from server;
        }
    }];
}
-(HttpClient *)httpClient{
    return [HttpClient sharedHttp];
}

-(AppSettings *)appSetttings{
    return [AppSettings sharedSettings];
}
@end
