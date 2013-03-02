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
    _sections=@[@"基本信息",@"保养建议"];
    _items=@[@[ @{@"name":@"每日平均行程",@"key":@"average_mileage",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"最大保养里程",@"key":@"max_distance",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"最大保养间隔",@"key":@"max_time",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"当前里程",@"key":@"current_distance",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"前次保养时间",@"key":@"prev_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"},
    @{@"name":@"前次保养里程",@"key":@"prev_distance",@"mode":@"add",@"description":@"",@"vcname":@""}],
    @[ @{@"name":@"本次保养时间",@"key":@"current_date",@"mode":@"",@"description":@"",@"vcname":@""},
    @{@"name":@"本次保养里程",@"key":@"current_miles",@"mode":@"",@"description":@"",@"vcname":@""}]
    ];
    /*
    self.txtMax_ditance.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"max_distance"]];
    self.txtMax_time.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"max_time"]];
    self.txtCurrent_distance.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"current_distance"]];
    self.txtPre_time.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"prev_date"]];
    self.txtPre_distance.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"prev_distance"]];
    self.txtCurrent_time.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"current_date"]];
    self.txtCurrent_miles.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"current_miles"]];
    self.txtAva_miles.text =[NSString stringWithFormat:@"%@", [result objectForKey:@"average_mileage"]];
     */
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
    
    [[_helper httpClient] post:[_helper appSetttings].url_for_post_maintain_record parameters:paramters block:^(id json) {
        if ([[_helper appSetttings] isSuccess:json]){
            NSLog(@"return=%@",json);
        }
    }];
}
-(NSArray *)getSections{
    return @[@"基本信息"];
}
-(NSArray *)getItems{
    return @[@[ @{@"name":@"每日平均行程",@"key":@"average_mileage",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"最大保养里程",@"key":@"max_distance",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"最大保养间隔",@"key":@"max_time",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"当前里程",@"key":@"current_distance",@"mode":@"add",@"description":@"",@"vcname":@""},
    @{@"name":@"前次保养时间",@"key":@"prev_date",@"mode":@"add",@"description":@"",@"vcname":@"DatePickerViewController"},
    @{@"name":@"前次保养里程",@"key":@"prev_distance",@"mode":@"add",@"description":@"",@"vcname":@""}]];
}
-(NSDictionary *)getInitData{
    return @{@"average_mileage":_result[@"average_mileage"],@"max_distance":_result[@"max_distance"],@"max_time":_result[@"max_time"],@"current_distance":_result[@"current_distance"]};
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
            
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)setup{
    _helper.url =[_helper appSetttings].url_for_get_maintain_record;
}
-(void)processData:(id)json{
    _result=[json objectForKey:@"result"];
    [self.tableView reloadData];
    
}
@end
