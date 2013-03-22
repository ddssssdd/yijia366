//
//  TaxForCarShipViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "TaxForCarShipViewController.h"
#import "PhoneView.h"


@interface TaxForCarShipViewController (){
    NSMutableArray *_listType;
    NSMutableArray *_listItems;
    NSMutableArray *_listRemarks;
    
}

@end

@implementation TaxForCarShipViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    _listType =@[@"乘用车",@"商用车",@"挂车",@"其他车辆",@"摩托车"];
    _listItems = [NSArray arrayWithObjects:
                  @[
                  @{@"price" : @"240元",@"unit":@"每辆",@"description":@"1.0升（含）以下的"},
                  @{@"price" : @"360元",@"unit":@"每辆",@"description":@"1.0升以上至1.6升（含）的"},
                  @{@"price" : @"420元",@"unit":@"每辆",@"description":@"1.6升以上至2.0升（含）的"},
                  @{@"price" : @"900元",@"unit":@"每辆",@"description":@"2.0升以上至2.5升（含）的"},
                  @{@"price" : @"1800元",@"unit":@"每辆",@"description":@"2.5升以上至3.0升（含）的"},
                  @{@"price" : @"3000元",@"unit":@"每辆",@"description":@"3.0升以上至4.0升（含）的"},
                  @{@"price" : @"4500元",@"unit":@"每辆",@"description":@"4.0升以上"}],
                  @[
                  @{@"price" : @"720元",@"unit":@"每辆",@"description":@"大型客车"},
                  @{@"price" : @"600元",@"unit":@"每辆",@"description":@"中型客车"},
                  @{@"price" : @"72元",@"unit":@"整备质量每吨",@"description":@"货车"}],
                  @[
                  @{@"price" : @"36元",@"unit":@"整备质量每吨",@"description":@"挂车"}],
                  @[@{@"price" : @"72元",@"unit":@"整备质量每吨",@"description":@"专用作业车"},
                  @{@"price" : @"72元",@"unit":@"整备质量每吨",@"description":@"轮式专用机械车"}],
                  @[
                  @{@"price" : @"60元",@"unit":@"每辆",@"description":@"摩托车"}],
                  nil];
    //增加了_listRemarks
    _listRemarks =
    @[@"核定载客人数9人（含）以下;按发动机汽缸容量(排气量)分档〕",@"大型客车核定载客人数20人（含）以上，包括电车;中型客车核定载客人数9人以上，20人以下，包括电车;货车包括半挂牵引车、三轮汽车和低速载货汽车等",@"挂车无备注",@"不包括拖拉机",@"摩托车无说明"];
    */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_listType count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[_listItems objectAtIndex:section] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_listType objectAtIndex:section];
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [_listRemarks objectAtIndex:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSArray *items =[_listItems objectAtIndex:indexPath.section];
    id item =[items objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [item objectForKey:@"description"];
    cell.detailTextLabel.text = [item objectForKey:@"price"];
  
    
    return cell;
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
    if (section==0)
        return 80;
    else
        return 22;
}

-(void)setup{
    _helper.url=[NSString stringWithFormat:@"api/get_taxforcarship?userid=%d",[_helper appSetttings].userid];
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _company = json[@"result"][@"company"];
    _phone = json[@"result"][@"phone"];
    _listType = [[NSMutableArray alloc] init];
    _listItems =[[NSMutableArray alloc] init];
    _listRemarks =[[NSMutableArray alloc] init];
    NSMutableDictionary *result = json[@"result"][@"data"];
    NSArray *allKeys =[result allKeys];
    
    NSArray *newList =[allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        return [s1 compare:s2];
    }];
    for(int i=0;i<[newList count];i++){
        NSString *key =[newList objectAtIndex:i];
        [_listType addObject:key];
        [_listItems addObject:result[key][@"list"]];
        [_listRemarks addObject:result[key][@"marks"]];
    }
    /*
    NSEnumerator *enumerator= [result keyEnumerator];
    id key;
    while (key=[enumerator nextObject]) {
        NSLog(@"%@",key);
        [_listType addObject:key];
        [_listItems addObject:result[key][@"list"]];
        [_listRemarks addObject:result[key][@"marks"]];
    }
     */
    [self.tableView reloadData];
    
}
@end
