//
//  RecommentsController.m
//  EasyDrive366
//
//  Created by Steven Fu on 6/1/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "RecommentsController.h"
#import "GoodsListItemCell.h"
#import "AppSettings.h"
#import "UIImageView+AFNetworking.h"
#import "GoodsDetailController.h"
#import "BuyButtonDelegate.h"
#import "NewOrderController.h"
#import "InsuranceStep1Controller.h"
#import "WelcomeViewController.h"
#import "SignupStep0ViewController.h"
#import "AppDelegate.h"
#import "SignupStep1ViewController.h"
#import "TaskDispatch.h"

@interface RecommentsController ()<BuyButtonDelegate,UIAlertViewDelegate>{
    id _list;
    id _imageList;
    UIView *_headerView;
    UIImageView *_imageView;
    UIPageControl *_pager;
    int _index;
    UIRefreshControl *_refreshControl;
}

@end


@implementation RecommentsController

-(void)viewDidLoad{
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
    self.title = @"推荐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonSystemItemAction target:self action:@selector(settingsButtonPress:)];
    [[HttpClient sharedHttp] online];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(need_set:) name:NEED_SET object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsButtonPress:) name:@"Login_First" object:nil];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeRight];
    _refreshControl= [[UIRefreshControl alloc] init];
    self.refreshControl = _refreshControl;
    [_refreshControl addTarget:self action:@selector(load_data) forControlEvents:UIControlEventValueChanged];
    [self load_data];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}
-(void)load_data{
    NSString *url = [NSString stringWithFormat:@"api/get_mainform?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _imageList = json[@"result"];
            [self.tableView reloadData];
            [self load_goods];
        }
    }];
}
-(void)load_goods{
    NSString *url = [NSString stringWithFormat:@"goods/get_goods_list?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"];
            [self.tableView reloadData];
            [_refreshControl endRefreshing];
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil){
        cell= [[[NSBundle mainBundle] loadNibNamed:@"GoodsListItemCell" owner:nil options:nil] objectAtIndex:0];
    }
    id item = [_list objectAtIndex:indexPath.row];
    GoodsListItemCell *itemCell=(GoodsListItemCell *)cell;
    itemCell.lblTitle.text =item[@"name"];
    itemCell.lblPrice.text = item[@"price"];
    itemCell.lblStand_price.text = item[@"stand_price"];
    itemCell.lblStand_price.strikeThroughEnabled = YES;
    itemCell.lblDiscount.text = item[@"discount"];
    itemCell.lblDescription.text = item[@"description"];
    itemCell.lblBuyer.text=item[@"buyer"];
    itemCell.item = item;
    itemCell.delegate = self;
    [itemCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [_list objectAtIndex:indexPath.row];
    GoodsDetailController *vc =[[GoodsDetailController alloc] initWithStyle:UITableViewStylePlain];
    vc.target_id =[item[@"id"] intValue];
    vc.title = item[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)BuyButtonDelegate:(id)item{
    NSLog(@"%@",item);
    if ([item[@"is_carins"] intValue]==0){
        NewOrderController *vc = [[NewOrderController alloc] initWithStyle:UITableViewStylePlain];
        vc.product_id = [item[@"id"] intValue];
        vc.min =[item[@"min_quantity"] intValue];
        vc.max =[item[@"max_quantity"] intValue];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        InsuranceStep1Controller *vc =[[InsuranceStep1Controller alloc] initWithNibName:@"InsuranceStep1Controller" bundle:nil];
        vc.title = item[@"name"];
        vc.web_url = item[@"web_url"];
        vc.goods_id = [item[@"id"] intValue];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}
-(void)showPicture:(int)i{
    NSString *url = [_imageList objectAtIndex:i][@"pic_url"];
    [_imageView setImageWithURL:[NSURL URLWithString:url]];
    _pager.currentPage = i;
}

-(void)goRight{
    _index--;
    if (_index<0){
        _index =[_imageList count]-1;
        
    }
    [self showPicture:_index];
}
-(void)goLeft{
    _index++;
    if (_index>[_imageList count]-1){
        _index=0;
    }
    [self showPicture:_index];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL islogin = [AppSettings sharedSettings].isLogin;
   
    if (!islogin){
        [AppSettings sharedSettings].userid=-1;
        self.navigationItem.rightBarButtonItem.title = @"登录";
        
    }else{
        self.navigationItem.rightBarButtonItem.title = @"设置";
    }
   
    
    
}

-(void)settingsButtonPress:(id)sender
{
    
    BOOL islogin = [AppSettings sharedSettings].isLogin;
    if (!islogin){
        WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
        return;
    }
    
    
    SignupStep0ViewController *vc = [[SignupStep0ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)loginSuccess{
   [self load_data];
}
- (IBAction)logout {
    [AppSettings sharedSettings].isLogin = FALSE;
    [AppSettings sharedSettings].userid = -1;
    [[AppSettings sharedSettings] save];
    
    [self load_data];
}
-(void)need_set:(NSNotification *)notification{
    NSString *message = [notification object];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AppTitle message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabbarController.selectedIndex =0;
        SignupStep1ViewController *vc = [[SignupStep1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.commingFrom = @"主页";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 150.0f;
    }
    return 0.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_headerView==nil){
        _headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        _imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 130)];
        _pager =[[UIPageControl alloc] initWithFrame:CGRectMake(131, 129, 37, 36)];
        [_pager setCurrentPageIndicatorTintColor:[UIColor redColor]];
        [_pager setPageIndicatorTintColor:[UIColor blackColor]];
        [_headerView addSubview:_imageView];
        [_headerView addSubview:_pager];
        if (_imageList){
            _pager.numberOfPages = [_imageList count];
        }else{
            [_imageView setImage:[UIImage imageNamed:@"default_640x234"]];
        }
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnHeader)];
        [_headerView setGestureRecognizers:@[tap]];
        
    }else{
        if (_imageList){
            _pager.numberOfPages = [_imageList count];
            _index =0;
            [self showPicture:_index];
        }else{
            [_imageView setImage:[UIImage imageNamed:@"default_640x234"]];
        }
    }
    return _headerView;
}
-(void)tapOnHeader{
    id item = [_imageList objectAtIndex:_pager.currentPage];
    NSLog(@"%@",item);
    id obj = @{@"id":item[@"id"],@"page_id":item[@"page_id"],@"action_url":item[@"url"]};
    TaskDispatch *dispatch =[[TaskDispatch alloc] initWithController:self.navigationController task:obj];
    [dispatch pushToController];

}
@end
