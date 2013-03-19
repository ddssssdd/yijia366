//
//  PhoneView.m
//  EasyDrive366
//
//  Created by Fu Steven on 3/16/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "PhoneView.h"
#import "AppSettings.h"

@implementation PhoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)initWithPhone:(NSString *)text phone:(NSString *)phone{
    self.text = text;
    self.phone = phone;
    self.phoneButton.text = @"咨询电话";
    
    self.phoneButton.textColor = [UIColor whiteColor];
	self.phoneButton.textShadowColor = [UIColor darkGrayColor];
	self.phoneButton.tintColor = [UIColor colorWithRed:0   green:1.0 blue:0 alpha:1];
	self.phoneButton.highlightedTintColor = [UIColor colorWithRed:(CGFloat)190/255 green:0 blue:0 alpha:1];
	
    
    /*
    self.phoneButton.textColor = [UIColor whiteColor];
	self.phoneButton.textShadowColor = [UIColor darkGrayColor];
	self.phoneButton.tintColor = [UIColor colorWithRed:(CGFloat)120/255 green:0 blue:0 alpha:1];
	self.phoneButton.highlightedTintColor = [UIColor colorWithRed:(CGFloat)190/255 green:0 blue:0 alpha:1];
	self.phoneButton.rightAccessoryImage = [UIImage imageNamed:@"arrow"];
     */
}
- (IBAction)makeCall:(id)sender {
    if (self.phone){
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"请确定您要打电话到--%@",self.phone ] otherButtonTitles:nil];
        [sheet showInView:self];
    
}


}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0){
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

@end
