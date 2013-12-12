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

@interface GoodsDetailController ()<OneButtonCellDelegate>{
    id _target;
    UIImageView *_imageView;
    UIPageControl *_pager;
    int _index;
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

-(void)showPicture:(int)i{
    NSString *url = [_target[@"album"] objectAtIndex:i][@"pic_url"];
    [_imageView setImageWithURL:[NSURL URLWithString:url]];
    _pager.currentPage = i;
}

-(void)goLeft{
    _index--;
    if (_index<0){
        _index =[_target[@"album"] count]-1;
        
    }
    [self showPicture:_index];
}
-(void)goRight{
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
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;

    if (indexPath.section==0){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailPictureCell" owner:nil options:nil] objectAtIndex:0];
        DetailPictureCell *aCell = (DetailPictureCell *)cell;
        [aCell.image setImageWithURL:[NSURL URLWithString:_target[@"pic_url"]]];
        aCell.pager.numberOfPages =[ _target[@"album"] count];
        _imageView = aCell.image;
        _pager = aCell.pager;
    
    }else if (indexPath.section==1){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailPriceCell" owner:nil options:nil] objectAtIndex:0];
        DetailPriceCell *aCell = (DetailPriceCell *)cell;
        aCell.lblBuyer.text =_target[@"buyer"];
        aCell.lblDiscount.text = _target[@"discount"];
        aCell.lblStand_price.text = _target[@"stand_price"];
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
    }else if (indexPath.section==4){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OneButtonCell" owner:nil options:nil] objectAtIndex:0];
        OneButtonCell *aCell = (OneButtonCell *)cell;
        aCell.button.text = @"购买";
        aCell.delegate = self;
        aCell.backgroundColor =[UIColor clearColor];
    }
    return cell;
}

-(void)buttonPress:(OneButtonCell *)sender{
    NSLog(@"clicked on buying");
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
    
}

@end
