//
//  OrderAccidentController.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/19/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderAccidentController.h"
#import "AppSettings.h"
#import "OrderFinishedController.h"

@interface OrderAccidentController (){
    UITextField *_txtName;
    UITextField *_txtId;
    UITextField *_txtPhone;
    id _type;
}

@end

@implementation OrderAccidentController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"配送信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finished)];
    _type = @{@"label":self.ins_data[@"type_name"],@"value":self.ins_data[@"type"]};
}
-(void)finished{
    //complete
    NSLog(@"%@",self.ins_data);
    if([@"" isEqualToString:self.ins_data[@"name"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"收件人不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    if([@"" isEqualToString:self.ins_data[@"idcard"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"手机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    if([@"" isEqualToString:self.ins_data[@"phone"]]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"手机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    if (!_type){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"请选择职业类别！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"order/order_ins_accident?userid=%d&orderid=%@&name=%@&idcard=%@&phone=%@&type=%@",[AppSettings sharedSettings].userid,self.ins_data[@"order_id"], self.ins_data[@"name"],self.ins_data[@"idcard"],self.ins_data[@"phone"],_type[@"value"]];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            OrderFinishedController *vc = [[OrderFinishedController alloc] initWithNibName:@"OrderFinishedController" bundle:Nil];
            vc.content_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return 3;
    else
        return [self.ins_data[@"list_type"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (indexPath.section==0){
        if (indexPath.row==0){
            cell.textLabel.text= @"姓名";
            if (!_txtName){
                _txtName = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 36)];
                [_txtName addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
                _txtName.placeholder =@"姓名";
                _txtName.returnKeyType = UIReturnKeyNext;
                _txtName.clearButtonMode =UITextFieldViewModeAlways;
                _txtName.tag =0;
                [_txtName addTarget:self action:@selector(completeValue:) forControlEvents:UIControlEventEditingDidEndOnExit];
            }
            _txtName.text = self.ins_data[@"name"];
            [_txtName removeFromSuperview];
            [cell.contentView addSubview:_txtName];
            
        }else if (indexPath.row==1){
            cell.textLabel.text= @"身份证号";
            if (!_txtId){
                _txtId = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 36)];
                [_txtId addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
                _txtId.placeholder =@"身份证号";
                _txtId.returnKeyType = UIReturnKeyNext;
                _txtId.keyboardType = UIKeyboardTypeNamePhonePad;
                _txtId.clearButtonMode =UITextFieldViewModeAlways;
                _txtId.tag =1;
                [_txtId addTarget:self action:@selector(completeValue:) forControlEvents:UIControlEventEditingDidEndOnExit];
            }
            _txtId.text = self.ins_data[@"idcard"];
            [_txtId removeFromSuperview];
            [cell.contentView addSubview:_txtId];
        }else if (indexPath.row==2){
            cell.textLabel.text= @"手机";
            if (!_txtPhone){
                _txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(100, 4, 200, 36)];
                [_txtPhone addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
                _txtPhone.placeholder =@"手机";
                _txtPhone.returnKeyType = UIReturnKeyNext;
                _txtPhone.keyboardType = UIKeyboardTypeNamePhonePad;
                _txtPhone.clearButtonMode =UITextFieldViewModeAlways;
                _txtPhone.tag=2;
                [_txtPhone addTarget:self action:@selector(completeValue:) forControlEvents:UIControlEventEditingDidEndOnExit];
            }
            _txtPhone.text = self.ins_data[@"phone"];
            [_txtPhone removeFromSuperview];
            [cell.contentView addSubview:_txtPhone];
        }
    }else if (indexPath.section==1){
        id item = [self.ins_data[@"list_type"] objectAtIndex:indexPath.row];
        cell.textLabel.text = item[@"label"];
        if ([item[@"value"] isEqualToString: _type[@"value"]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    
    return cell;
}

-(void)valueChanged:(UITextField *)sender{
    int index = sender.tag;
    self.ins_data[@[@"name",@"idcard",@"phone"][index]]= sender.text;
}
-(void)completeValue:(UITextField *)sender{
    int index = sender.tag;
    if (index<2){
        [@[_txtId,_txtPhone][index] becomeFirstResponder];
    }else{
        [sender resignFirstResponder];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        id item = [self.ins_data[@"list_type"] objectAtIndex:indexPath.row];
        if ([item[@"value"] isEqualToString:  _type[@"value"]]){
            _type =nil;
        }else{
            _type = item;
        }

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1){
        return [NSString stringWithFormat:@"职业类别 选择 －[%@]",_type?_type[@"label"]:@"未选择"];
    }
    return nil;
}
@end
