//
//  FriendListController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "FriendListController.h"
#import "AppSettings.h"
#import "FriendHeader.h"
#import "FriendListCell.h"

@interface FriendListController (){
    id _list;
    NSString *_content;
    FriendHeader *_header;
    NSString *_invite_code;
    NSString *_share_title;
    NSString *_share_inctroduce;
    NSString *_share_url;
}

@end

@implementation FriendListController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(share)];
    
}
-(void)share{
    [[AppSettings sharedSettings] popupShareMenu:_share_title introduce:_share_inctroduce url:_share_url];
}
-(void)load_data{
    NSString *url = [NSString stringWithFormat:@"bound/get_my_friends?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list =json[@"result"][@"friends"];
            NSLog(@"%@",_list);
            _content = json[@"result"][@"content"];
            _invite_code = json[@"result"][@"my_invite"];
            _share_url = json[@"result"][@"share_url"];
            _share_title = json[@"result"][@"share_title"];
            _share_inctroduce = json[@"result"][@"share_intro"];
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
    
    
    if (cell==nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendListCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [_list objectAtIndex:indexPath.row];
    NSLog(@"%@",item);
    FriendListCell *aCell = (FriendListCell *)cell;
    aCell.lblName.text = item[@"name"];
    aCell.lblDate.text = [AppSettings getStringDefault:item[@"registerDate"] default:@""];
    aCell.lblMemo.text = item[@"is_bounds"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 100.0f;
    }
    return  0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        if (!_header){
            _header =[[[NSBundle mainBundle] loadNibNamed:@"FriendHeader" owner:nil options:nil] objectAtIndex:0];
            _header.btnButton1.text=@"invite way 1";
            _header.btnButton2.text=@"invite way 2";
            _header.btnButton3.text=@"invite way 3";
            _header.parent = self.navigationController;
        }
        _header.lblContent.text= _content;
        _header.lblInvite_code.text = _invite_code;
        return _header;
    }
    return nil;
}



@end
