//
//  HelpCallViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "HelpCallViewController.h"
#import "HelpHeaderView.h"

#import "AppSettings.h"

@interface HelpCallViewController (){
    NSMutableArray *_list;
    NSString *_company;
    NSString *_phone;
}

@end

@implementation HelpCallViewController

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
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Phone" style:UIBarButtonSystemItemAction target:self action:@selector(makeCall:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   
    [self setTableview:nil];
    [super viewDidUnload];
}


-(void)makeCall:(id)sender{
    NSLog(@"call");
}

-(void)setup{
    _helper.url = [AppSettings sharedSettings].url_for_get_helpcalls;
}
-(void)processData:(id)json{
    
    id result =[json objectForKey:@"result"];
    
    _company = [result objectForKey:@"company_name"];
    _phone =[result objectForKey:@"phone"];
    
    id list = [[json objectForKey:@"result"] objectForKey:@"list"];
    if (_list){
        [_list removeAllObjects];
    }else{
        _list =[[NSMutableArray alloc] init];
    }
    [_list addObjectsFromArray:list];
    
    
    [self updateData];
}
-(void)updateData{
    
    [self.tableview reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list?[_list count]:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentitifier=@"Cell";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentitifier];
    if (cell==nil){
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentitifier];
    }
    id item = [_list objectAtIndex:indexPath.row];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@$",[item objectForKey:@"price"]];
    cell.textLabel.text =[item objectForKey:@"description"];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HelpHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"HelpHeaderView" owner:nil options:nil] objectAtIndex:0];
    header.titleLabel.text= _company;
    header.detailLabel.text= _phone;
    header.backgroundColor =self.tableview.backgroundColor;
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
@end
