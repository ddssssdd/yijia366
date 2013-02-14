//
//  InformationViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "InformationViewController.h"

#import "AppSettings.h"


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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitifier];
    if (cell == nil){
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentitifier];
        
    }
    id item = [_list objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[item objectForKey:@"title"];
    cell.detailTextLabel.text=[item objectForKey:@"description"];
    return cell;
}

-(void)setup{
    _url = [AppSettings sharedSettings].url_for_get_news;
}
-(void)processData:(id)json{
    if (_list){
        [_list removeAllObjects];
    }else{
        _list =[[NSMutableArray alloc] init];
    }
    [_list addObjectsFromArray:[json objectForKey:@"result"]];
    
    [self.tableView reloadData];
}
@end
