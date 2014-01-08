//
//  NewOrderController.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/7/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "NewOrderController.h"
#import "AppSettings.h"
#import "OrderItem.h"
#import "OrderProductCell.h"
#import "OrderQuantityCell.h"
#import "UIImageView+AFNetworking.h"
#import "NewOrderHeader.h"
#import "ButtonViewController.h"
#import "OrderPayController.h"

@interface NewOrderController ()<OrderQuantityCellDelegate,ButtonViewControllerDelegate>{
    id _list;
    NSString *_order_id;
    NSString *_order_total;
    ButtonViewController *_buttonController;
    NewOrderHeader *_header;
}

@end

@implementation NewOrderController

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
    
    [self load_data];
}

-(void)load_data{
    NSString *url;
    if (self.product_id){
        url = [NSString stringWithFormat:@"order/order_new?userid=%d&goodsid=%d",[AppSettings sharedSettings].userid,self.product_id];
    }else if (self.order_id){
        url = [NSString stringWithFormat:@"order/order_edit?userid=%d&orderid=%@",[AppSettings sharedSettings].userid,self.order_id];
    }
    
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _order_id = json[@"result"][@"order_id"];
            _order_total = json[@"result"][@"order_total"];
            _list = [[NSMutableArray alloc] init];
            for (id item in json[@"result"][@"goods"]) {
                OrderItem *orderItem = [[OrderItem alloc] initWithJson:item];
                [_list addObject:orderItem];
            }
            [self.tableView reloadData];
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

    return [_list count]*2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section % 2){
        return 1;
    }else{
        return 3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    int index = indexPath.section / 2;
    OrderItem *item = [_list objectAtIndex:index];
    if (!indexPath.section %2){
        if (cell==Nil){
            cell =[[[NSBundle mainBundle] loadNibNamed:@"OrderProductCell" owner:nil options:nil] objectAtIndex:0];
            
            
        }
        OrderProductCell *productCell = (OrderProductCell *)cell;
        [productCell.imageProduct setImageWithURL:[NSURL URLWithString:item.pic_url]];
        productCell.lblName.text= item.name;
        productCell.lblDescription.text = item.description;
        productCell.lblPrice.text = item.price;
        productCell.lblStand_price.text = item.stand_price;
        productCell.lblDiscount.text = item.discount;
        productCell.lblBuyer.text = item.buyer;
    
    }else{
        if (indexPath.row==0){
            if (cell==nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text=@"price";
            cell.detailTextLabel.text= item.price;
        }else if (indexPath.row==1){
            if (cell==nil){
                cell= [[[NSBundle mainBundle] loadNibNamed:@"OrderQuantityCell" owner:nil options:nil] objectAtIndex:0];
            }
            OrderQuantityCell *quantityCell = (OrderQuantityCell *)cell;
            quantityCell.lblQuantity.text = [NSString stringWithFormat:@"%d",item.quantity];
            quantityCell.delegate = self;
            
        }else if (indexPath.row==2){
            if (cell==nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text=@"total";
            cell.detailTextLabel.text=_order_total;
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.section % 2){
        return 120.0f;
    }else{
        return 44.0f;
    }
}
-(void)quantityChanged:(UITableViewCell *)cell value:(int)value{
    NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];
    NSIndexPath *nextCell = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    int index = indexPath.section / 2;
    OrderItem *orderItem = [_list objectAtIndex:index];
    orderItem.quantity = value;
    _order_total = @"1000000";
    [self.tableView reloadRowsAtIndexPaths:@[nextCell] withRowAnimation:UITableViewRowAnimationTop];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==[_list count]*2-1){
        return 80.0f;
    }
    return 22.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 44.0f;
    }
    return 22.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        if (!_header){
            _header =[[[NSBundle mainBundle] loadNibNamed:@"NewOrderHeader" owner:nil options:nil] objectAtIndex:0];
        }
        return _header;
    }
    return  nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==[_list count]*2-1){
        if (!_buttonController){
            _buttonController =[[ButtonViewController alloc] initWithNibName:@"ButtonViewController" bundle:nil];
            _buttonController.delegate = self;
            _buttonController.buttonText = @"submit";
        }
        return _buttonController.view;
    }
    return nil;
}
-(void)buttonPressed:(NVUIGradientButton *)button{
    NSLog(@"%@",button);
    if ([_list count]==0)
        return;
    OrderItem *item = [_list objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"order/order_save?userid=%d&goodsid=%d&quantity=%d&orderid=%@",
                     [AppSettings sharedSettings].userid,item.orderitem_id,item.quantity,_order_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            OrderPayController *vc =[[OrderPayController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
@end
