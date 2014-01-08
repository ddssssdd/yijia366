//
//  UserProfileView.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/19/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "UserProfileView.h"
#import "AppSettings.h"
#import "UIImageView+AFNetworking.h"
#import "BoundListController.h"
#import "FriendListController.h"
#import "NeedPayController.h"

@implementation UserProfileView

-(id)initWithController:(UINavigationController *)parent{
    self =[[[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:nil options:nil] objectAtIndex:0];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        _parent = parent;
        self.lblBound.text=@"";
        self.lblExp.text=@"";
        self.lblSignature.text=@"";
        self.lblUsername.text=@"";
        self.imageAvater.image=nil;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBound)];
        [self.lblBound addGestureRecognizer:tap];
        
        [self load_data];
    }
    return self;
    
}

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
- (IBAction)needPayPressed:(id)sender {
    NeedPayController *vc = [[NeedPayController alloc] initWithStyle:UITableViewStylePlain];
    [_parent pushViewController:vc animated:YES];
}
- (IBAction)myInsurancePressed:(id)sender {
}
- (IBAction)myTaskPressed:(id)sender {
}
- (IBAction)myFriendPressed:(id)sender {
    FriendListController *vc =[[FriendListController alloc] initWithStyle:UITableViewStylePlain];
    [_parent pushViewController:vc animated:YES];
}

-(void)load_data{
    NSString *url = [NSString stringWithFormat:@"bound/get_user_set?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            self.lblBound.text=[NSString stringWithFormat:@"积分：%@",json[@"result"][@"bound"]];
            self.lblExp.text=[NSString stringWithFormat:@"%@",json[@"result"][@"exp"]];
            self.lblSignature.text=[AppSettings getStringDefault:json[@"result"][@"signature"] default:@"啥也没有说"];
            self.lblUsername.text=[AppSettings getStringDefault:json[@"result"][@"nickname"] default:@"(未设置)"];
            [self.imageAvater setImageWithURL:[NSURL URLWithString:json[@"result"][@"photourl"]] placeholderImage:[UIImage imageNamed:@"m.png"]];
        }
    }];
}
-(void)openBound{
    BoundListController *vc = [[BoundListController alloc] initWithStyle:UITableViewStylePlain];
    [_parent pushViewController:vc animated:YES];
}

@end
