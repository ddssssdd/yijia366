//
//  LicenseTypeViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/17/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "LicenseTypeViewController.h"

@interface LicenseTypeViewController (){
    id _list;
}

@end

@implementation LicenseTypeViewController

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
    self.title =@"驾照类型";
    
    //_list =@[@"A1",@"A2",@"B1",@"B2"];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(select:)];
}
-(void)select:(id)sender{
    NSMutableString *result=[[NSMutableString alloc] init];
    for (UIView *v in [self.tableView subviews]) {
        if ([v isKindOfClass:[UITableViewCell class]]){
            UITableViewCell *cell = (UITableViewCell *)v;
            if (cell.accessoryType==UITableViewCellAccessoryCheckmark){
                [result appendString:@","];
                [result appendString:cell.textLabel.text];
            }
        }
    
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"driver_type" object:self userInfo:@{@"result":result}];
    
    [self.navigationController popViewControllerAnimated:YES];
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    id item=[_list objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"code"];
    cell.detailTextLabel.text =item[@"code"];//[NSString stringWithFormat:@"年审间隔：%@年",item[@"years"]];
    cell.accessoryType = UITableViewCellAccessoryNone;
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
    UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

-(void)setup{
    _helper.url=[_helper appSetttings].url_get_license_type;
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _list = json[@"result"];
    [self.tableView reloadData];
}

@end
