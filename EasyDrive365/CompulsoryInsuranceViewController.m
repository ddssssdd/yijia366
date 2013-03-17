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
#import "InfoAndPriceCell.h"

@interface CompulsoryInsuranceViewController ()
{
    int _currentType;
    NSDictionary *_dict;
    id _json;
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
    self.segmentedControl.backgroundColor = self.tableView.backgroundColor;
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
        _currentType = index;
        if (_json)
            [self update_display];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
     [self setTableView:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
}
-(void)loadData{
    NSString *data_key = [NSString stringWithFormat:@"%@",NSStringFromClass([self class])];
    
    
    id json = [[AppSettings sharedSettings] loadJsonBy:data_key];
    if (json){
        [self processData:json];
    }
    NSString *_url =[NSString stringWithFormat:@"api/get_compulsory_details?userid=%d",[AppSettings sharedSettings].userid];
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
    
    _json = json;
   
    [self update_display];
}
-(void)update_display{
    NSString *type_name=[NSString stringWithFormat:@"type_%d",_currentType];
    _dict =_json[@"result"][@"data"][type_name];
    NSLog(@"%@",_dict);
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
    InfoAndPriceCell *cell=nil;
    cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        //cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell =[[[NSBundle mainBundle] loadNibNamed:@"InfoAndPriceCell" owner:nil options:nil] objectAtIndex: 0];
    }
    id key=[[_dict allKeys] objectAtIndex:indexPath.section];
    id item =[[_dict objectForKey:key] objectAtIndex:indexPath.row];
    cell.titleLabel.text=item[@"name"];
    cell.detailLabel.text=item[@"price"];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_dict allKeys] objectAtIndex:section];

}
@end
