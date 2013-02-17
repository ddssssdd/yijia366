//
//  TaxForCarShipViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "TaxForCarShipViewController.h"


@interface TaxForCarShipViewController (){
    NSArray *_listType;
    NSArray *_listItems;
    NSArray *_listRemarks;
    
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
    _listType =@[@"乘用车（按发动机汽缸容量（排气量）分档）",@"商用车",@"挂车",@"其他车辆",@"摩托车"];
    _listItems = [NSArray arrayWithObjects:
                  @[@{@"price" : @"240元",@"unit":@"每辆",@"description":@"1.0升以上至1.6升（含）的"},
                  @{@"price" : @"360元",@"unit":@"每辆",@"description":@"1.0升以上至1.6升（含）的"},
                  @{@"price" : @"420元",@"unit":@"每辆",@"description":@"1.6升以上至2.0升（含）的"},
                  @{@"price" : @"900元",@"unit":@"每辆",@"description":@"2.0升以上至2.5升（含）的"},
                  @{@"price" : @"1800元",@"unit":@"每辆",@"description":@"2.5升以上至3.0升（含）的"},
                  @{@"price" : @"3000元",@"unit":@"每辆",@"description":@"3.0升以上至4.0升（含）的"},
                  @{@"price" : @"4500元",@"unit":@"每辆",@"description":@"4.0升以上"}],
                  @[@{@"price" : @"720元",@"unit":@"每辆",@"description":@"大型客车（核定载客人数20人（含）以上，包括电车）"},
                  @{@"price" : @"600元",@"unit":@"每辆",@"description":@"中型客车（核定载客人数9人以上，20人以下，包括电车）"},
                  @{@"price" : @"72元",@"unit":@"整备质量每吨",@"description":@"包括半挂牵引车、三轮汽车和低速载货汽车等"}],
                  @[@{@"price" : @"36元",@"unit":@"整备质量每吨",@"description":@"挂车"}],
                  @[@{@"price" : @"72元",@"unit":@"整备质量每吨",@"description":@"专用作业车"},
                  @{@"price" : @"72元",@"unit":@"整备质量每吨",@"description":@"轮式专用机械车"}],
                  @[@{@"price" : @"60元",@"unit":@"每辆",@"description":@"摩托车"}],nil];
    */
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
