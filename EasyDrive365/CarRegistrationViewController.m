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
#import "PhoneView.h"
#import "OneButtonCell.h"

@interface CarRegistrationViewController ()<OneButtonCellDelegate>{
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
    _sections=@[@"提醒",@"违章信息",@"基本信息"];
    _items=@[
    @[@{@"name":@"年审日期",@"key":@"check_date",@"mode":@"",@"description":@"",@"vcname":@""}],
    @[ @{@"name":@"未处理次数",@"key":@"untreated_number",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"未处理记分",@"key":@"untreated_mark",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"未处理罚款",@"key":@"untreated_fine",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"违章查询",@"key":@"",@"description":@"",@"vcname":@"IllegallyListViewController"}],
    @[ @{@"name":@"车牌号",@"key":@"plate_no",@"mode":@"add",@"description":@"",@"vcname":@""},
    
    @{@"name":@"车辆类型",@"key":@"car_typename",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"品牌",@"key":@"brand",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"型号",@"key":@"model",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"发动机号",@"key":@"engine_no",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"VIN",@"key":@"vin",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"初登日期",@"key":@"registration_date",@"mode":@"add",@"description":@"",@"vcname":@""},
    ]
  ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self; self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    
    
   
    
}


-(void)edit:(id)sender{
    EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)saveData:(NSDictionary *)paramters
{
    NSLog(@"%@",paramters);
    
    NSString *url =[NSString stringWithFormat:@"api/add_car_registration?user_id=%d&car_id=%@&vin=%@&init_date=%@&engine_no=%@",[_helper appSetttings].userid,paramters[@"car_id"],paramters[@"vin"],paramters[@"init_date"],paramters[@"engine_no"]];
    NSLog(@"%@",url);
    [[_helper httpClient] get:url  block:^(id json) {
        NSLog(@"%@",json);
        if ([[_helper appSetttings] isSuccess:json]){
            [self processData:json];
        }
    }];
}
-(int)textFieldCount{
    return 4;
}
-(NSArray *)getSections{
    return @[@"基本信息"];
}
-(NSArray *)getItems{
    return @[@[ @{@"name":@"车牌号",@"key":@"car_id",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"发动机号",@"key":@"engine_no",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"VIN",@"key":@"vin",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"初登日期",@"key":@"init_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"},
   ]];
}
-(NSDictionary *)getInitData{
    if (!result){
        result =[[NSMutableDictionary alloc] init];
        [result setObject:@"" forKey:@"plate_no"];
        [result setObject:@"" forKey:@"engine_no"];
        [result setObject:@"" forKey:@"vin"];
        [result setObject:@"" forKey:@"registration_date"];
    }
    return @{@"car_id":result[@"plate_no"],@"engine_no":result[@"engine_no"],@"vin":result[@"vin"],@"init_date":result[@"registration_date"]};
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
    
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (![item[@"vcname"] isEqualToString:@""]){
        OneButtonCell *cell =[[[NSBundle mainBundle] loadNibNamed:@"OneButtonCell" owner:tableView options:nil] objectAtIndex:0];
        cell.button.text=item[@"name"];
        cell.delegate=self;
        return cell;
        
    }else{
        DisplayTextCell *cell=nil;
        NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"DisplayTextCell" owner:self.tableView options:nil];
        cell =[cells objectAtIndex:0];
        cell.keyLabel.text = item[@"name"];
        if (![item[@"key"] isEqualToString:@""]){
            NSString *value =[result objectForKey:item[@"key"]];
            if (value){
                cell.valueLabel.text = [NSString stringWithFormat:@"%@",value];
            }
        }else{
            cell.valueLabel.text=@"";
        }
        cell.tag = indexPath.row;
        cell.valueLabel.tag = indexPath.row;
        return cell;
    }
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        PhoneView *phoneView = [[[NSBundle mainBundle] loadNibNamed:@"PhoneView" owner:nil options:nil] objectAtIndex:0];
        [phoneView initWithPhone:_company phone:_phone];
        phoneView.backgroundColor = tableView.backgroundColor;
        phoneView.phoneButton.text=@"预约年审";
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
    _helper.url =[[_helper appSetttings] url_get_car_registration];
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _company = json[@"result"][@"company"];
    _phone = json[@"result"][@"phone"];
    id list = json[@"result"];
    if ([list isKindOfClass:[NSArray class]] && [list count]>0){
        result =[list objectAtIndex:0];
        //NSLog(@"%@ is %@",result,[result class]);
    }else{
        result=list[@"data"];
    }
    [self.tableView reloadData];
}
-(void)buttonPress:(id)sender{
    IllegallyListViewController *vc =[[IllegallyListViewController alloc] initWithNibName:@"IllegallyListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
