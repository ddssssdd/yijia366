//
//  OrderFinishedController.h
//  EasyDrive366
//
//  Created by Steven Fu on 1/28/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFinishedController : UIViewController
@property (nonatomic) NSString * order_id;
@property (nonatomic) NSString * content;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;

@end
