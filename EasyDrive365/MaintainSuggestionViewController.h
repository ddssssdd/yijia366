//
//  MaintainSuggestionViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"

@interface MaintainSuggestionViewController : NetViewController
@property (weak, nonatomic) IBOutlet UITextField *txtAva_miles;

@property (weak, nonatomic) IBOutlet UITextField *txtMax_ditance;

@property (weak, nonatomic) IBOutlet UITextField *txtMax_time;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrent_distance;
@property (weak, nonatomic) IBOutlet UITextField *txtPre_time;
@property (weak, nonatomic) IBOutlet UITextField *txtPre_distance;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrent_time;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrent_miles;
@end
