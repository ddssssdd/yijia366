//
//  CompulsoryInsuranceViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CompulsoryInsuranceViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"

@interface CompulsoryInsuranceViewController ()
{
    int _currentType;
    NSDictionary *_dict;
}

@end

@implementation CompulsoryInsuranceViewController

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
    _currentType =0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}
- (IBAction)segmentedSelectChanged:(UISegmentedControl *)sender {

    NSInteger index = sender.selectedSegmentIndex;
    if (index!=_currentType){
        [self loadData];
    }
    
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
-(void)loadData{
    NSString *data_key = [NSString stringWithFormat:@"%@_type_%d",NSStringFromClass([self class]),_currentType];
    NSString *_url =[NSString stringWithFormat:@"api/get_compulsory_details?typeid=%d",_currentType];
    [[HttpClient sharedHttp] get:_url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            
            [[AppSettings sharedSettings] saveJsonWith:data_key data:json];
            [self processData:json];
            
        }else{
            //get nothing from server;
        }
    }];
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    _dict =json[@"result"];
    [self.tableView reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dict count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id key=[[_dict allKeys] objectAtIndex:section];
    return [[_dict objectForKey:key] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell=nil;
    cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    id key=[[_dict allKeys] objectAtIndex:indexPath.section];
    id item =[[_dict objectForKey:key] objectAtIndex:indexPath.row];
    cell.textLabel.text=item[@"name"];
    cell.detailTextLabel.text=item[@"price"];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_dict allKeys] objectAtIndex:section];

}
@end
