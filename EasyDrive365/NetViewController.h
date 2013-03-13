//
//  NetViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpClientDelegate.h"
#import "HttpHelper.h"

@interface NetViewController : UIViewController<HttpClientDelegate>{
    HttpHelper *_helper;
    NSString *_phone;
    NSString *_company;
}
-(void)setup;
-(void)processData:(id)json;


@end
