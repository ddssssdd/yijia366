//
//  InsuranceStep6Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/27/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep6Controller.h"
#import "AppSettings.h"
#import "InsuranceStep7Controller.h"

@interface InsuranceStep6Controller (){
    BOOL _useDiscount;
    id _pay;
}

@end

@implementation InsuranceStep6Controller

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
    self.title = @"第六步";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    
    _useDiscount = YES;
    [self load_data];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAfterPay:) name:ALIPAY_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)load_data{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0){
        return 3;
    }else{
        return [self.order_data[@"pay"] count];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0){
        return @"结算信息";
    }else{
        return @"付款方式";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    if (indexPath.section==0){
        if (indexPath.row==0){
            cell.textLabel.text = @"保费总额";
            cell.detailTextLabel.text = self.order_data[@"order_total"];
        }else if (indexPath.row==1){
            cell.textLabel.text = @"积分";
            UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 120, 24)];
            label.text = self.order_data[@"bounds"];
            label.font = [UIFont fontWithName:@"Arial" size:12];
            [cell.contentView addSubview:label];
            CGRect rect;
            if ([[AppSettings sharedSettings] isIos7]){
                rect = CGRectMake(250, 10, 50, 24);
            }else{
                rect = CGRectMake(220, 10, 50, 24);
            }
            UISwitch *sw = [[UISwitch alloc] initWithFrame:rect];
            [sw setOn:_useDiscount];
            [sw addTarget:self action:@selector(switchUseDiscount:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sw];
        }else{
            cell.textLabel.text = @"还需支付";
            cell.detailTextLabel.text = self.order_data[_useDiscount? @"order_pay":@"order_pay_2"];
        }
    }else{
        id item = [self.order_data[@"pay"] objectAtIndex:indexPath.row];
        cell.textLabel.text = item[@"bank_name"];
        cell.detailTextLabel.text = item[@"account"];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
}
-(void)switchUseDiscount:(UISwitch *)sender{
    _useDiscount = sender.on;
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        //assume pay succesuss!
        id item = [self.order_data[@"pay"] objectAtIndex:indexPath.row];
        if ([item[@"bank_id"] isEqualToString:@"00001"]){
            _pay = item;
            CGFloat amount = [self.order_data[_useDiscount? @"order_pay":@"order_pay_2"] floatValue];
            [[AppSettings sharedSettings] pay:@"在线购买保险" description:self.order_data[@"order_id"] amount:amount order_no:self.order_data[@"order_id"]];
            //[self handleAfterPay:nil];
        }
    }
}
-(void)handleAfterPay:(NSNotification *)notification{
    NSLog(@"%@",notification);
    InsuranceStep7Controller *vc = [[InsuranceStep7Controller alloc] initWithStyle:UITableViewStyleGrouped];
    vc.orderid = self.order_data[@"order_id"];
    vc.bounds = _useDiscount?self.order_data[@"bounds"]:@"0";
    vc.bankid = _pay[@"bank_id"];
    vc.account = @"";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
