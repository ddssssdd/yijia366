//
//  AddCardStep2Controller.m
//  EasyDrive366
//
//  Created by Fu Steven on 10/23/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AddCardStep2Controller.h"
#import "AppSettings.h"
#import "CardViewController.h"


@interface AddCardStep2Controller (){
    id bf1;
    id bf2;
}

@end

@implementation AddCardStep2Controller

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
    _saveButtonName = @"保存";
    
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    id items=@[
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"name",@"label":@"姓名",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":@"" }],
               
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"identity",@"label":@"身份证",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":@"" }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"cell",@"label":@"手机号",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":@"" }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"address",@"label":@"保险地址",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":@"" }]
               ];
    bf1 =@[[[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"bf",@"label":@"约定受益人",@"default":@"0",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"SwitchCell",@"value":@"0"}],
                 [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"bf2",@"label":@"",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"default",@"value":@"法定受益人作为受益人"}]];
    bf2 =@[[[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"bf",@"label":@"约定受益人",@"default":@"0",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"SwitchCell",@"value":@"1"}],
           [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"bf_name",@"label":@"姓名",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":@"" }],
           
           [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"bf_identity",@"label":@"身份证",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":@"" }]];
    _list=[NSMutableArray arrayWithArray: @[
           /*@{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f},*/
           [[NSMutableDictionary alloc] initWithDictionary:@{@"count" : @4,@"list":items,@"height":@44.0f}],
           [[NSMutableDictionary alloc] initWithDictionary:@{@"count" : @2,@"list":bf1,@"height":@44.0f}]
           ]];
    [self.tableView reloadData];
    self.title =@"卡激活";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==1){
        return @"Step2";
    }else{
        return  Nil;
    }
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    
    NSString *name = parameters[@"name"];
    NSString *identity = parameters[@"identity"];
    NSString *cell = parameters[@"cell"];
    NSString *address = parameters[@"address"];
    BOOL bf = [parameters[@"bf"] boolValue];
    NSString *bf_name = @"";
    NSString *bf_identity = @"";
    if (bf){
        bf_name = parameters[@"bf_name"];
        bf_identity = parameters[@"bf_identity"];
    }
    
    
    NSString *path =[NSString stringWithFormat:@"api/add_inscard_step2?userid=%d&number=%@&insured_name=%@&insured_idcard=%@&insured_phone=%@&insured_address=%@&is_agreed_bf=%@&bf_name=%@&bf_id=%@",[AppSettings sharedSettings].userid, self.number,name,identity,cell,address,bf?@"true":@"false",bf_name,bf_identity];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            CardViewController *vc =[[CardViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

-(void)buttonPress:(OneButtonCell *)sender{
    [self done];
}
-(void)switchChanged:(UISwitch *)aSwitch cell:(SwitchCell *)cell{

    if (aSwitch.isOn) {
        [_list objectAtIndex:1][@"list"]=bf2;
        [_list objectAtIndex:1][@"count"]=@3;
    }else{
        [_list objectAtIndex:1][@"list"]= bf1;
        [_list objectAtIndex:1][@"count"]=@2;
    }
    [self.tableView reloadData];
    
}
@end
