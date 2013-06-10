//
//  ArticleViewController.h
//  EasyDrive366
//
//  Created by Fu Steven on 6/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

-(void)goto:(id)article;
@end
