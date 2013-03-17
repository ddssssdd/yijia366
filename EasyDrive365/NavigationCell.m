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
    if (![AppSettings sharedSettings].isLogin)
        return;
    if (!self.keyname){
        return;
    }
    
    NSString *keyname=[NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),self.keyname];
    if (![HttpClient sharedHttp].isInternet){
        NSLog(@"%@",keyname);
        id json=[[AppSettings sharedSettings] loadJsonBy:keyname];
        [self processData:json];
        return;
    }
    NSString *url = [[AppSettings sharedSettings] url_getlatest:self.keyname];
    NSLog(@"url=%@",url);
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd"];
            json[@"result"][@"updated_time"]=[formatter stringFromDate:[NSDate date]];
            NSLog(@"%@",keyname);
            [[AppSettings sharedSettings] saveJsonWith:keyname data:json];
            [self processData:json];
            
        }else{
            NSLog(@"%@",json);
            //get nothing from server;
        }
    }];
    
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    
    self.descriptionLabel.text=json[@"result"][@"latest"];
    self.phone = json[@"result"][@"phone"];
    

    self.dataLabel.text =  [NSString stringWithFormat:@"最后更新:%@", json[@"result"][@"updated_time"]  ];
}
-(void)setKeyname:(NSString *)keyname{
    _keyname = keyname;
    /* old way
    NSString *key=[NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),keyname];
    id json=[[AppSettings sharedSettings] loadJsonBy:key];
    [self processData:json];
     */
    Information *infor =[[AppSettings sharedSettings] getInformationByKey:keyname];
    if (infor){
        self.descriptionLabel.text = infor.latest;
        self.dataLabel.text = infor.updateTime;
        self.phone = infor.phone;
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:[NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),_keyname] object:nil];
}
-(void)updateData:(NSNotification *)noti{
    Information *infor =[noti object];
    self.descriptionLabel.text = infor.latest;
    self.dataLabel.text = infor.updateTime;
    self.phone = infor.phone;
}
-(void)empty{
    
}
@end
