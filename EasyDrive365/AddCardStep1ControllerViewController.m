//
//  AddCardStep1ControllerViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 10/22/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AddCardStep1ControllerViewController.h"
#import "AppSettings.h"

@interface AddCardStep1ControllerViewController ()

@end

@implementation AddCardStep1ControllerViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)init_setup{
    _saveButtonName = @"下一步";
    
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    
    NSString *url = [NSString stringWithFormat:@"api/add_inscard_step0?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        id items=@[
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"card",@"label":@"激活码：",@"default":@"",@"placeholder":@"输入激活码",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":@"" }],
                   
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"button",@"label":@"激活卡片",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"OneButtonCell",@"value":@""}]
                   ];
        id items2 =@[[[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"description",@"label":json[@"result"][@"data"],@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"TextLabelCell",@"value":@""}]];
        _list=[NSMutableArray arrayWithArray: @[
               /*@{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f},*/
               @{@"count" : @2,@"list":items,@"height":@44.0f},
               @{@"count" : @1,@"list":items2,@"height":@300.0f}
               ]];
        [self.tableView reloadData];
    }];
    
    self.title =@"激活卡单";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==1){
        return @"Step1";
    }else{
        return  Nil;
    }
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    
    
    NSString *path =[NSString stringWithFormat:@"api/wizardstep1?userid=%d&car_id=%@&license_id=%@&vin=%@",[AppSettings sharedSettings].userid, @"",@"",@""];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            
        }
    }];
}

@end
