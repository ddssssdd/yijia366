//
//  CarRegistrationViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CarRegistrationViewController.h"
#import "IllegallyListViewController.h"
#import "DatePickerViewController.h"
#import "DisplayTextCell.h"

@interface CarRegistrationViewController (){
    NSArray *_sections;
    NSArray *_items;
   
    NSMutableDictionary* result;
}

@end

@implementation CarRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initData{
    _sections=@[@"基本信息",@"违章信息"];
    _items=@[@[ @{@"name":@"车牌号",@"key":@"plate_no",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"车辆类型",@"key":@"car_type",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"类型名称",@"key":@"car_typename",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"品牌",@"key":@"brand",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"型号",@"key":@"model",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"发动机号",@"key":@"engine_no",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"VIN",@"key":@"vin",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"初登日期",@"key":@"registration_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"},
    @{@"name":@"发证日期",@"key":@"issue_date",@"mode":@"add",@"description":@"",@"vcname":@""},],
    @[ @{@"name":@"未处理次数",@"key":@"untreated_number",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"未处理记分",@"key":@"untreated_mark",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"未处理罚款",@"key":@"untreated_fine",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"违章查询",@"description":@"",@"vcname":@"IllegallyListViewController"}]
  ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self; self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    
    
   
    
}


-(void)edit:(id)sender{
    EditInTableViewController *vc = [[EditInTableViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)saveData:(NSDictionary *)paramters
{
    NSLog(@"%@",paramters);
    
    NSString *url =[NSString stringWithFormat:@"api/add_car_registration?user_id=%d&car_id=%@&vin=%@&init_date=%@engine_no=%@",[_helper appSetttings].userid,paramters[@"car_license_no"],paramters[@"vin"],paramters[@"init_date"],paramters[@"car_id"]];
    NSLog(@"%@",url);
    [[_helper httpClient] get:url  block:^(id json) {
        NSLog(@"%@",json);
        if ([[_helper appSetttings] isSuccess:json]){
            [self processData:json];
        }
    }];
}
-(NSArray *)getSections{
    return @[@"基本信息"];
}
-(NSArray *)getItems{
    return @[@[ @{@"name":@"车牌号",@"key":@"car_license_no",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"发动机号",@"key":@"car_id",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"VIN",@"key":@"vin",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"初登日期",@"key":@"init_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"},
   ]];
}
-(NSDictionary *)getInitData{
    return @{@"car_license_no":result[@"plate_no"],@"car_id":result[@"engine_no"],@"vin":result[@"vin"],@"init_date":result[@"registration_date"]};
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)get_illegally:(id)sender {
    IllegallyListViewController *vc =[[IllegallyListViewController alloc] initWithNibName:@"IllegallyListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
    NSString *value =[result objectForKey:item[@"key"]];
    NSLog(@"key=%@",item[@"key"]);
    cell.keyLabel.text = item[@"name"];
    cell.valueLabel.text = [NSString stringWithFormat:@"%@",value];

    
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
            IllegallyListViewController *vc =[[IllegallyListViewController alloc] initWithNibName:@"IllegallyListViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)setup{
    _helper.url =[[_helper appSetttings] url_get_car_registration];
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    id list = json[@"result"];
    if ([list isKindOfClass:[NSArray class]] && [list count]>0){
        result =[list objectAtIndex:0];
        //NSLog(@"%@ is %@",result,[result class]);
    }else{
        result=list[@"data"];
    }
    [self.tableView reloadData];
}
@end
