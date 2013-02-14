//
//  NetViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetViewController : UIViewController{
    NSString *_url;
}
-(void)setup;
-(void)loadData;

-(void)processData:(id)json;
@end
