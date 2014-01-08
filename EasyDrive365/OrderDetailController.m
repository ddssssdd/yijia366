//
//  OrderDetailController.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/8/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderDetailController.h"
#import "ButtonViewController.h"
#import "OrderProductCell.h"
#import "AppSettings.h"
#import "UIImageView+AFNetworking.h"
#import "NewOrderController.h"

@interface OrderDetailController ()<ButtonViewControllerDelegate>{
    id _list;
    id _sectionList;
    NSString *_order_status;
    NSString *_order_status_name;
    ButtonViewController *_buttonView;
    int _footer_index;
}

@end

@implementation OrderDetailController

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

    self.title = @"订单详情";
    [self load_data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_list objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (item[@"pic_url"]){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderProductCell" owner:nil options:nil] objectAtIndex:0];
        OrderProductCell *productCell = (OrderProductCell *)cell;
        [productCell.imageProduct setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
        productCell.lblName.text= item[@"name"];
        productCell.lblDescription.text = item[@"description"];
        productCell.lblPrice.text = item[@"price"];
        productCell.lblStand_price.text = item[@"stand_price"];
        productCell.lblDiscount.text = item[@"discount"];
        productCell.lblBuyer.text = item[@"buyer"];
        productCell.lblStatus.text = _order_status_name;
    }else{
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.text = item[@"title"];
        cell.detailTextLabel.text = item[@"detail"];
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (item[@"pic_url"]){
        return 120.0f;
    }else{
        return 44.0f;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sectionList objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([_order_status isEqualToString:@"notpay"] &&  section==_footer_index){
        if (!_buttonView){
            _buttonView = [[ButtonViewController alloc] initWithNibName:@"ButtonViewController" bundle:nil];
            _buttonView.delegate = self;
            _buttonView.buttonText = @"pay";
        }
        return _buttonView.view;
    }
    return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([_order_status isEqualToString:@"notpay"] &&  section==_footer_index){
        return 80.0f;
    }
    return  22.0f;
}
-(void)buttonPressed:(NVUIGradientButton *)button{
    NewOrderController *vc = [[NewOrderController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.order_id = self.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)load_data{
    NSString *url = [NSString stringWithFormat:@"order/order_detail?userid=%d&orderid=%@",[AppSettings sharedSettings].userid,self.order_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = [[NSMutableArray alloc] init];
            _sectionList = [[NSMutableArray alloc] init];
            _footer_index = -1;
            _order_status = json[@"result"][@"order_status"];
            _order_status_name =json[@"result"][@"order_status_name"];
            int order_count=0;
            //goods information
            for (id good in json[@"result"][@"goods"]) {
                [_sectionList addObject:@""];
                [_list addObject:@[good]];
                order_count = order_count + [good[@"quantity"] intValue];
                _footer_index ++;
            }
            // order informaiton
            [_sectionList addObject:@"订单信息"];
            
            [_list addObject:@[@{@"title":@"订单号",@"detail":json[@"result"][@"order_id"]},
                               @{@"title":@"下单时间",@"detail":json[@"result"][@"order_time"]},
                               @{@"title":@"数量",@"detail":[NSString stringWithFormat:@"%d",order_count]},
                               @{@"title":@"总价",@"detail":json[@"result"][@"order_total"]}]];
            //if else depends on order_status
            if ([_order_status isEqualToString:@"notpay"]){
                //price
                [_sectionList addObject:@"应付款"];
                [_list addObject:@[@{@"title":@"会员折扣",@"detail":json[@"result"][@"discount"]},
                                   @{@"title":@"可用积分抵扣",@"detail":json[@"result"][@"bounds"]},

                                   @{@"title":@"应付总额",@"detail":json[@"result"][@"order_pay"]}]];
                
                //pay
                [_sectionList addObject:@"付款方式"];
                NSMutableArray *paylist =[[NSMutableArray alloc] init];
                for (id pay  in json[@"result"][@"pay"]) {
                    [paylist addObject:@{@"title":pay[@"bank_name"],@"detail":pay[@"account"]}];
                }
                [_list addObject:paylist];
            }else{
                //nothing for now;
            }
            [self.tableView reloadData];
            
        }
    }];
}

@end
