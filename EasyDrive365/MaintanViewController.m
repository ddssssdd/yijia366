//
//  MaintanViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "MaintanViewController.h"
#import "DisplayTextCell.h"
#import "DatePickerViewController.h"
#import "PhoneView.h"

@interface MaintanViewController (){
    NSArray *_sections;
    NSArray *_items;
    
    NSMutableDictionary* _result;
}

@end

@implementation MaintanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initData{
    _sections=@[@"保养建议",@"基本信息"];
    _items=@[
    @[ @{@"name":@"下次保养时间",@"key":@"current_date",@"mode":@"",@"description":@"",@"vcname":@"",@"unit":@""},
    @{@"name":@"下次保养里程",@"key":@"current_miles",@"mode":@"",@"description":@"",@"vcname":@"",@"unit":@"公里"}],
    @[ @{@"name":@"每日平均行程",@"key":@"average_mileage",@"mode":@"add",@"description":@"",@"vcname":@"",@"unit":@"公里/天"},
    @{@"name":@"最大保养里程",@"key":@"max_distance",@"mode":@"add",@"description":@"",@"vcname":@"",@"unit":@"公里"},
    @{@"name":@"最大保养间隔",@"key":@"max_time",@"mode":@"add",@"description":@"",@"vcname":@"",@"unit":@"个月"},
    @{@"name":@"上次保养时间",@"key":@"prev_date",@"mode":@"add",@"description":@"",@"vcname":@"",@"unit":@""},
    @{@"name":@"上次保养里程",@"key":@"prev_distance",@"mode":@"add",@"description":@"",@"vcname":@"",@"unit":@"公里"}]
    ];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self; self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    [self setupTableView:self.tableView];
    
    
    
}


-(void)edit:(id)sender{
    EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)saveData:(NSDictionary *)paramters
{
    NSLog(@"%@",paramters);
    NSString *url = [NSString stringWithFormat:@"api/add_maintain_record?user_id=%d&max_distance=%@&max_time=%@&prev_date=%@&prev_distance=%@&average_mileage=%@",
                     [_helper appSetttings].userid,
                     paramters[@"max_distance"],
                     paramters[@"max_time"],
                     paramters[@"prev_date"],
                     paramters[@"prev_distance"],
                     paramters[@"average_mileage"]];
    [[_helper httpClient] get:url block:^(id json) {
       
        if ([[_helper appSetttings] isSuccess:json]){
            
            [self processData:json];
        }
    }];
    return YES;
}
-(int)textFieldCount{
    return 4;
}

-(NSArray *)getSections{
    return @[@"基本信息"];
}
-(NSArray *)getItems{
    return @[@[ @{@"name":@"每日平均行程",@"key":@"average_mileage",@"mode":@"number",@"description":@"",@"vcname":@"",@"unit":@"公里"},
    @{@"name":@"最大保养里程",@"key":@"max_distance",@"mode":@"number",@"description":@"",@"vcname":@"",@"unit":@"公里"},
    @{@"name":@"最大保养间隔",@"key":@"max_time",@"mode":@"number",@"description":@"",@"vcname":@"",@"unit":@"个月"},
    @{@"name":@"上次保养时间",@"key":@"prev_date",@"mode":@"number",@"description":@"",@"vcname":@"DatePickerViewController",@"unit":@""},
    @{@"name":@"上次保养里程",@"key":@"prev_distance",@"mode":@"number",@"description":@"",@"vcname":@"",@"unit":@"公里"}]];
}
-(NSDictionary *)getInitData{
    return @{@"average_mileage":_result[@"average_mileage"],@"max_distance":_result[@"max_distance"],@"max_time":_result[@"max_time"],@"prev_date":_result[@"prev_date"],@"prev_distance":_result[@"prev_distance"]};
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
    DisplayTextCell *cell=nil;
    cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"DisplayTextCell" owner:self.tableView options:nil];
        cell =[cells objectAtIndex:0];
        
        
    }
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *value =[_result objectForKey:item[@"key"]];
    NSLog(@"key=%@",item[@"key"]);
    cell.keyLabel.text = item[@"name"];
    if (value && ![value isKindOfClass:[NSNull class]] ){
        cell.valueLabel.text = [NSString stringWithFormat:@"%@%@",value,item[@"unit"]];
    }
    
    
    if (![item[@"vcname"] isEqualToString:@""]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.tag = indexPath.row;
    cell.valueLabel.tag = indexPath.row;
    
    
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
            
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        PhoneView *phoneView = [[[NSBundle mainBundle] loadNibNamed:@"PhoneView" owner:nil options:nil] objectAtIndex:0];
        [phoneView initWithPhone:_company phone:_phone];
        phoneView.backgroundColor = tableView.backgroundColor;
        return phoneView;
    }else{
        return nil;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 80;
    }else{
        return 44;
    }
}

-(void)setup{
    _helper.url =[_helper appSetttings].url_for_get_maintain_record;
}
-(void)processData:(id)json{
    _company = json[@"result"][@"company"];
    _phone = json[@"result"][@"phone"];
    id temp=[json objectForKey:@"result"][@"data"];
    
    NSLog(@"%@",temp);
    NSEnumerator *enumerator =[temp keyEnumerator];
    id key;
    _result = [[NSMutableDictionary alloc] init];
    while ((key=[enumerator nextObject])) {
        id value = [temp objectForKey:key];
        if ([value isKindOfClass:[NSNull class]]){
            [_result setObject:@"" forKey:key];
            
        }else{
            [_result setObject:value?value:@"" forKey:key];
        }
    }
    [self.tableView reloadData];
    [self endRefresh:self.tableView];
}
@end
