//
//  BusinessInsViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "BusinessInsViewController.h"
#import "BusinessInsuranceViewController.h"
#import "ItemDetailCell.h"
#import "Insurance4ColumnsCell.h"
#import "InsuranceFooterView.h"
#import "HttpClient.h"
#import "AppSettings.h"


@interface BusinessInsViewController (){
    NSMutableArray *_list;
    id _curr;
    id _renew;
}

@end

@implementation BusinessInsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    _curr = nil;
    _renew = nil;
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _list = [[NSMutableArray alloc] init];
    [[HttpClient sharedHttp] get:[AppSettings sharedSettings].url_get_count_of_suggestions block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            
            NSNumber *count = json[@"result"];
            if ([count intValue]>0){
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"建议" style:UIBarButtonSystemItemAction target:self action:@selector(suggestBusiness:)];
            }else{
                
            }
            
        }else{
            //get nothing from server;
        }
    }];
    
}
-(void)setup{
    _helper.url=[_helper appSetttings].url_get_business_insurance;
}
-(void)processData:(id)json{
    NSLog(@"%@",json[@"result"]);
    id result = json[@"result"];
    _curr=[self parseData:result key:@"curr"];
    NSNumber *total = json[@"result"][@"renew"][@"total"];
    if ([total intValue]>0){
        _renew=[self parseData:result key:@"renew"];
    }else{
        _renew=nil;
    }
    [self.tableView reloadData];
    
    
}
-(id)parseData:(id)result key:(NSString *)key{
    id curr = result[key];
    /*
    NSMutableArray *sum=[[NSMutableArray alloc] init];
    [sum addObject:@{@"name":@"商业险",@"price":[NSString stringWithFormat:@"%@",curr[@"biz"]]}];
    [sum addObject:@{@"name":@"车船税",@"price":[NSString stringWithFormat:@"%@",curr[@"tax"]]}];
    [sum addObject:@{@"name":@"交强险",@"price":[NSString stringWithFormat:@"%@",curr[@"com"]]}];
    [sum addObject:@{@"name":@"合计",@"price":[NSString stringWithFormat:@"%@",curr[@"total"]]}];
     */
    NSMutableArray *items=[[NSMutableArray alloc] init];
    for (id item in curr[@"list"]) {
        [items addObject:item];
    }
    
    //[_list addObject:sum];
    [_list addObject:items];
    return curr;
}
-(void)parseData_old:(id)result key:(NSString *)key{
    id curr = result[key];
    NSMutableArray *sum=[[NSMutableArray alloc] init];
    [sum addObject:@{@"name":@"商业险",@"price":[NSString stringWithFormat:@"%@",curr[@"biz"]]}];
    [sum addObject:@{@"name":@"车船税",@"price":[NSString stringWithFormat:@"%@",curr[@"tax"]]}];
    [sum addObject:@{@"name":@"交强险",@"price":[NSString stringWithFormat:@"%@",curr[@"com"]]}];
    [sum addObject:@{@"name":@"合计",@"price":[NSString stringWithFormat:@"%@",curr[@"total"]]}];
    NSMutableArray *items=[[NSMutableArray alloc] init];
    for (id item in curr[@"list"]) {
        [items addObject:item];
    }
    //id section=@{@"sum":sum,@"items":items};
    [_list addObject:sum];
    [_list addObject:items];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_list count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_list objectAtIndex:section] count]+1;
    /*if (section==1 || section==3){
        return [[_list objectAtIndex:section] count]+1;
    }else{
        return [[_list objectAtIndex:section] count];
    }
     */
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0){
        return @"当前保单";
    }else {
        return @"新续保单";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier2 = @"cell2";
    Insurance4ColumnsCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    if (cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"Insurance4ColumnsCell" owner:nil options:nil] objectAtIndex:0];
    }
    if (indexPath.row==0){
        
        cell.nameLabel.text = @"";
        cell.item1Label.text= @"保额";
        cell.item2Label.text =@"保费";
        cell.item3Label.text = @"不计免赔保费";
        
    }else{
        id item=[[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
        cell.nameLabel.text = item[@"InsuName"];
        cell.item1Label.text= [NSString stringWithFormat:@"%@",item[@"Amount"]];
        cell.item2Label.text =[NSString stringWithFormat:@"%@",item[@"Fee"]];
        cell.item3Label.text = [NSString stringWithFormat:@"%@",item[@"DeductibleFee"]];
    }
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
-(void)suggestBusiness:(id)sender{
    BusinessInsuranceViewController *vc= [[BusinessInsuranceViewController alloc] initWithNibName:@"BusinessInsuranceViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0){
        InsuranceFooterView *fv = [[[NSBundle mainBundle] loadNibNamed:@"InsuranceFooterView" owner:nil options:nil] objectAtIndex:0];
        fv.backgroundColor = [self.tableView backgroundColor];
        fv.summaryLabel.text=[NSString stringWithFormat:@"%@",_curr[@"total"]];
        fv.companyLabel.text=@"平安保险";
        fv.noLabel.text=@"ADS9232749878989SDFSDF";
        fv.dateLabel.text=@"2012-10-21 至 2013-10-20 止";
        return fv;
        
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0){
        return 200;
    }
    return 0;
}
@end
