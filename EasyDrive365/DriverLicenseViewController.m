//
//  DriverLicenseViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "DriverLicenseViewController.h"
#import "LicenseTypeViewController.h"
#import "DatePickerViewController.h"
#import "EditTableCell.h"

@interface DriverLicenseViewController (){
    NSArray *_sections;
    NSArray *_items;
    BOOL _isEditing;
    NSMutableDictionary* result;
}

@end

@implementation DriverLicenseViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 216, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit_license:)];
    _isEditing = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listen_driver_type:) name:@"driver_type" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listen_init_date:) name:@"init_date" object:nil];
    
}
-(void)listen_init_date:(NSNotification *)notification{
    [result setObject:notification.userInfo[@"result"] forKey:@"init_date"];
    
}
-(void)listen_driver_type:(NSNotification *)notification{
    
    [result setObject:notification.userInfo[@"result"] forKey:@"driver_type"];
   
    [self.tableView reloadData];
}
-(void)edit_license:(id)sender{
    _isEditing = YES;
    for (UIView *v in [self.tableView subviews]) {
        if ([v isKindOfClass:[EditTableCell class]]){
            EditTableCell *cell = (EditTableCell *)v;
            [cell setEditable:YES];
        }
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save_license:)];
}

-(void)save_license:(id)sender{
    _isEditing =NO;
    NSMutableDictionary *parameter =[[NSMutableDictionary alloc] init];
    for (UIView *v in [self.tableView subviews]) {
        if ([v isKindOfClass:[EditTableCell class]]){
            EditTableCell *cell = (EditTableCell *)v;
            NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];
            id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSString *key =[NSString stringWithFormat:@"%@", item[@"key"]];
            if ([item[@"mode"] isEqualToString:@"add"]){
                //item[key]=cell.valueText.text;
                [parameter setObject:cell.valueText.text forKey:key];
            }
            [cell endEdit];
        }
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit_license:)];
    NSString *url =[NSString stringWithFormat:@"api/add_driver_license?user_id=%d",[_helper appSetttings].userid];
    NSLog(@"parameter=%@",parameter);
    [[_helper httpClient] post:url parameters:parameter block:^(id json) {
        if ([[_helper appSetttings] isSuccess:json]){
            [self processData:json];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)initData{
    _sections=@[@"基本信息",@"计分情况",@"提醒"];
    _items=@[@[ @{@"name":@"证件号码",@"key":@"license_id",@"mode":@"add",@"description":@"",@"vcname":@""},
                @{@"name":@"姓名",@"key":@"driver_name",@"mode":@"add",@"description":@"",@"vcname":@""},
                @{@"name":@"准驾车型",@"key":@"driver_type",@"mode":@"add",@"description":@"",@"vcname":@"LicenseTypeViewController"},
                @{@"name":@"初领日期",@"key":@"init_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"}],
             @[ @{@"name":@"有效期限",@"key":@"expired_date",@"mode":@"",@"description":@"",@"vcname":@""},
                @{@"name":@"计分到期日",@"key":@"score_end_date",@"mode":@"",@"description":@"",@"vcname":@""},
                @{@"name":@"计分情况",@"key":@"score",@"mode":@"",@"description":@"",@"vcname":@""}],
             @[@{@"name":@"提醒日期",@"key":@"alert_date",@"mode":@"",@"description":@"",@"vcname":@""}]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_items objectAtIndex:section] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sections objectAtIndex:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    /*
    UITableViewCell *cell=nil;
    cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
     */
    EditTableCell *cell =nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"EditTableCell" owner:self.tableView options:nil];
        cell =[cells objectAtIndex:0];
        

    }
    
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *value =[result objectForKey:item[@"key"]];
    //NSLog(@"result=%@,key=%@,value=%@",result,item[@"key"],value);
    [cell setValueByKey:item[@"key"] value:value];
    //[cell setValueByKey:item[@"key"] value:@""];
    cell.displayLabel.text = item[@"name"];
    cell.valueText.delegate= self;
    if (![item[@"vcname"] isEqualToString:@""]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell start_listen];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.tag = indexPath.row;
    cell.valueText.tag = indexPath.row;
    
    [cell setEditable:_isEditing];
       
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *vcname=item[@"vcname"];
    if (![vcname isEqualToString:@""]){
        if ([vcname isEqualToString:@"DatePickerViewController"]){
            DatePickerViewController *vc = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
            vc.keyname = @"init_date";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            LicenseTypeViewController *vc = [[LicenseTypeViewController alloc] initWithNibName:vcname bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    /*
    EditTableCell *cell =(EditTableCell *)[self.tableView viewWithTag:textField.tag];
    NSIndexPath *path =[self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
     */
    return YES;
}



-(void)setup{
    _helper.url =[[_helper appSetttings] url_get_driver_license];
}
-(void)processData:(id)json{
    id list = json[@"result"];
    if ([list isKindOfClass:[NSArray class]] && [list count]>0){
        result =[list objectAtIndex:0];
        //NSLog(@"%@ is %@",result,[result class]);
    }
    [self.tableView reloadData];
}

@end
