//
//  NavigationCell.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NavigationCell.h"
#import "HttpClient.h"
#import "AppSettings.h"

@implementation NavigationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)makeCall:(id)sender {
    
    NSLog(@"I am pressed,i will call:%@",self.phone);
    if(self.phone){
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
   
    
}

-(void)getLatest{
    NSString *keyname=[NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),self.keyname];
    if (![HttpClient sharedHttp].isInternet){
        id json=[[AppSettings sharedSettings] loadJsonBy:keyname];
        [self processData:json];
        return;
    }
    NSString *url = [[AppSettings sharedSettings] url_getlatest];
    //NSLog(@"url=%@",url);
    [[HttpClient sharedHttp] post:url parameters:@{@"keyname":self.keyname} block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            
            [[AppSettings sharedSettings] saveJsonWith:keyname data:json];
            [self processData:json];
            
        }else{
            //get nothing from server;
        }
    }];
    
}
-(void)processData:(id)json{
    self.descriptionLabel.text=json[@"result"][@"latest"];
    self.phone = json[@"result"][@"phone"];
}

@end
