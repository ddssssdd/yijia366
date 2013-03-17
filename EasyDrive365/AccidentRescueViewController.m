//
//  AccidentRescueViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AccidentRescueViewController.h"

#import "AppSettings.h"

@interface AccidentRescueViewController ()
{
    NSString *_shop_name;
    NSString *_address;
    NSString *_shop_phone;
    NSString *_description;
}
@end

@implementation AccidentRescueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.phoneButton.text=@"咨询电话";
    
}
-(void)makeCall
{

}

-(void)setup{
    _helper.url = [AppSettings sharedSettings].url_for_rescue;
}
-(void)processData:(id)json{
    _company = [json[@"result"] objectForKey:@"company"];
    _phone =[json[@"result"] objectForKey:@"phone"];
    
    id result =[json objectForKey:@"result"][@"data"];
    _shop_name =[result objectForKey:@"shop_name"];
    _address =[result objectForKey:@"address"];
    _shop_phone =[result objectForKey:@"phone"];
    _description =[result objectForKey:@"description"];
    
    
    [self updateData];
}
-(void)updateData{
    self.lblShopName.text = _shop_name;
    self.lblAddress.text =_address;
    self.lblPhone.text = _phone;
    self.textDescription.text =_description;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblShopName:nil];
    [self setLblAddress:nil];
    [self setTextDescription:nil];
    [self setLblPhone:nil];
    [self setPhoneButton:nil];
    [super viewDidUnload];
}
- (IBAction)phoneCall:(id)sender {
}
@end
