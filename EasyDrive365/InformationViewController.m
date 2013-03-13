//
//  InformationViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "InformationViewController.h"

#import "AppSettings.h"
#import "InformationCell.h"
#import "BrowserViewController.h"


@interface InformationViewController (){
    NSMutableArray *_list;
}

@end

@implementation InformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list?[_list count]:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentitifier = @"Cell";
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitifier];
    if (cell == nil){
        //cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentitifier];
        cell =[[[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    id item = [_list objectAtIndex:indexPath.row];
    
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[item objectForKey:@"fmt_createDate"]];
    cell.detailLabel.text=[NSString stringWithFormat:@"%@",[item objectForKey:@"description"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [_list objectAtIndex:indexPath.row];
    NSString *action = item[@"action"];
    [[[UIAlertView alloc] initWithTitle:@"action" message:action delegate:self cancelButtonTitle:nil otherButtonTitles:@"go" , nil] show ];
    
    BrowserViewController *vc = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc go:@"http://www.baidu.com"];
}
-(void)setup{
    _helper.url = [AppSettings sharedSettings].url_for_get_news;
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    if (_list){
        [_list removeAllObjects];
    }else{
        _list =[[NSMutableArray alloc] init];
    }
    [_list addObjectsFromArray:[json objectForKey:@"result"][@"data"]];
    _phone =json[@"result"][@"phone"];
    _company =json[@"result"][@"company"];
    [self.tableView reloadData];
}
@end
