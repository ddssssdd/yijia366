//
//  GoodsDetailController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "GoodsDetailController.h"
#import "AppSettings.h"
#import "OneButtonCell.h"
#import "DetailPictureCell.h"
#import "DetailPriceCell.h"
#import "DetailDescriptionCell.h"
#import "DetailRateCell.h"
#import "UIImageView+AFNetworking.h"
#import "ItemCommentsController.h"
#import "BuyButtonView.h"
#import "NewOrderController.h"

@interface GoodsDetailController ()<BuyButtonViewDelegate>{
    id _target;
    UIImageView *_imageView;
    UIPageControl *_pager;
    int _index;
    BuyButtonView *_buttonView;
    UIView *_navigationView;
    UIButton *_favorBtn;
}

@end

@implementation GoodsDetailController

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
	// Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeRight];
   
    
}
-(void)addRightButtons{
    NSString *imageName = [_target[@"is_favor"] intValue]==1?@"shoucang":@"quxiaosc";
    if (!_navigationView){
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        
        _favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _favorBtn.frame = CGRectMake(30, 2, 30, 30);
        [_favorBtn addTarget:self action:@selector(addFavor) forControlEvents:UIControlEventTouchUpInside];
        //[_favorBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [_navigationView addSubview:_favorBtn];
        
        
        UIButton *exampleButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        exampleButton2.frame = CGRectMake(70, 2, 30, 30);
        [exampleButton2 addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
        [exampleButton2 setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        
        [_navigationView addSubview:exampleButton2];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationView];
    }
    [_favorBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    
}
-(void)addFavor{
    if ([_target[@"is_favor"] intValue]==0){
        NSString *url = [NSString stringWithFormat:@"favor/add?userid=%d&id=%@&type=GDS",[AppSettings sharedSettings].userid,_target[@"id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [_favorBtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
                [_navigationView setNeedsLayout];
                _target[@"is_favor"]=@"1";
            }
        }];
    }else{
        NSString *url = [NSString stringWithFormat:@"favor/remove?userid=%d&id=%@&type=GDS",[AppSettings sharedSettings].userid,_target[@"id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [_favorBtn setImage:[UIImage imageNamed:@"quxiaosc"] forState:UIControlStateNormal];
                [_navigationView setNeedsLayout];
                _target[@"is_favor"]=@"0";
                
            }
        }];
    }
}
-(void)goShare{
    [[AppSettings sharedSettings] popupShareMenu:_target[@"share_title"] introduce:_target[@"share_intro"] url:_target[@"share_url"]];
}

-(void)showPicture:(int)i{
    NSString *url = [_target[@"album"] objectAtIndex:i][@"pic_url"];
    [_imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_640x234.png"]];
    _pager.currentPage = i;
}

-(void)goRight{
    _index--;
    if (_index<0){
        _index =[_target[@"album"] count]-1;
        
    }
    [self showPicture:_index];
}
-(void)goLeft{
    _index++;
    if (_index>[_target[@"album"] count]-1){
        _index=0;
    }
    [self showPicture:_index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup{
    _helper.url = [NSString stringWithFormat:@"goods/get_goods_info?userid=%d&id=%d",[AppSettings sharedSettings].userid,self.target_id];
    
}
-(void)processData:(id)json{
    if ([[AppSettings sharedSettings] isSuccess:json]){
        _target = json[@"result"];
        _index=0;
        NSLog(@"%@",_target);
        [self addRightButtons];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;

    if (indexPath.section==0){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailPictureCell" owner:nil options:nil] objectAtIndex:0];
        DetailPictureCell *aCell = (DetailPictureCell *)cell;
        [aCell.image setImageWithURL:[NSURL URLWithString:_target[@"pic_url"]]  placeholderImage:[UIImage imageNamed:@"default_640x234.png"]];
        aCell.pager.numberOfPages =[ _target[@"album"] count];
        _imageView = aCell.image;
        _pager = aCell.pager;
    
    }else if (indexPath.section==1){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailPriceCell" owner:nil options:nil] objectAtIndex:0];
        DetailPriceCell *aCell = (DetailPriceCell *)cell;
        aCell.lblBuyer.text =_target[@"buyer"];
        aCell.lblDiscount.text = _target[@"discount"];
        aCell.lblStand_price.text = _target[@"stand_price"];
        aCell.lblStand_price.strikeThroughEnabled = YES;
        aCell.lblPrice.text = _target[@"price"];
    }else if (indexPath.section==2){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailDescriptionCell" owner:nil options:nil] objectAtIndex:0];
        DetailDescriptionCell *aCell = (DetailDescriptionCell *)cell;
        aCell.txtDescription.text = _target[@"description"];
    }else if (indexPath.section==3){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailRateCell" owner:nil options:nil] objectAtIndex:0];
        DetailRateCell *aCell = (DetailRateCell *)cell;
        aCell.lblStar.text =[NSString stringWithFormat:@"%@",  _target[@"star"]];
        aCell.lblStar_voternum.text = [NSString stringWithFormat:@"%@", _target[@"star_voternum"]];
        aCell.rating = 4.5;
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==3){
        if (!_buttonView){
            _buttonView = [[[NSBundle mainBundle] loadNibNamed:@"BuyButtonView" owner:nil options:nil] objectAtIndex:0];
            _buttonView.delegate = self;
            [_buttonView.btnBuy setBackgroundImage:[UIImage imageNamed:@"btnbuy_big"] forState:UIControlStateNormal];
        }
        return _buttonView;
    }
    return  nil;
}
-(void)buyButtonPressed:(BuyButtonView *)sender data:(id)data{
    NewOrderController *vc = [[NewOrderController alloc] initWithStyle:UITableViewStylePlain];
    vc.product_id = [_target[@"id"] intValue];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==3)
        return 60;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 150;
        case 1:
            return 44;
        case 2:
            return 60;
        case 3:
            return 44;
        case 4:
            return 44;
            
        default:
            break;
    }
    return 44.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3){
        ItemCommentsController *vc =[[ItemCommentsController alloc] initWithStyle:UITableViewStylePlain];
        vc.itemId = [NSString stringWithFormat:@"%d",self.target_id];
        vc.itemType =@"goods";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
