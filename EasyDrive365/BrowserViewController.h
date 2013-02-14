//
//  BrowserViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webview;


-(void)go:(NSString *)path;
@end
