//
//  ProviderDetailController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ProviderDetailController.h"
#import "AppSettings.h"
#import "ProviderListItemCell.h"
#import "DetailPictureCell.h"
#import "DetailRateCell.h"
#import "UIImageView+AFNetworking.h"
#import "ItemCommentsController.h"


@interface ProviderDetailController (){
    id _target;
    UIImageView *_imageView;
    UIPageControl *_pager;
    int _index;
}

@end

@implementation ProviderDetailController

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
    _helper.url = [NSString stringWithFormat:@"api/get_service_info?userid=%d&code=%@",[AppSettings sharedSettings].userid,self.code];
    
}
-(void)processData:(id)json{
    if ([[AppSettings sharedSettings] isSuccess:json]){
        _target = json[@"result"];
        _index=0;
        NSLog(@"%@",_target);
        [self.tableView reloadData];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==5){
        return [_target[@"goods"] count];
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section==0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIndetifier"];
        cell.textLabel.text = _target[@"name"];
    }else if (indexPath.section==1){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailPictureCell" owner:nil options:nil] objectAtIndex:0];
        DetailPictureCell *aCell = (DetailPictureCell *)cell;
        [aCell.image setImageWithURL:[NSURL URLWithString:_target[@"pic_url"]]];
        aCell.pager.numberOfPages =[ _target[@"album"] count];
        _imageView = aCell.image;
        _pager = aCell.pager;
        
    }else if (indexPath.section==2){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailRateCell" owner:nil options:nil] objectAtIndex:0];
        DetailRateCell *aCell = (DetailRateCell *)cell;
        aCell.lblStar.text =[NSString stringWithFormat:@"%@",  _target[@"star"]];
        aCell.lblStar_voternum.text = [NSString stringWithFormat:@"%@", _target[@"star_voternum"]];
        aCell.rating = 4.5;
        
    }else if (indexPath.section==3){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIndetifier"];
        cell.textLabel.text = _target[@"phone"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section==4){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIndetifier"];
        cell.textLabel.text = _target[@"address"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section==5){
        id item = [_target[@"goods"] objectAtIndex:indexPath.row];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProviderListItemCell" owner:nil options:nil] objectAtIndex:0];
        ProviderListItemCell *itemCell=(ProviderListItemCell *)cell;
        itemCell.lblName.text =item[@"name"];
        itemCell.lblAddress.text = item[@"address"];
        itemCell.lblPhone.text = item[@"phone"];
        
        [itemCell.image setImageWithURL:[NSURL URLWithString:item[@"pic_url"]]];
    }
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 44.0;
        case 1:
            return 150;
        case 2:
            return 44;
        case 3:
            return 44;
        case 4:
            return 44;
        case 5:
            return 120.0;
            
        default:
            break;
    }
    return 44.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2){
        ItemCommentsController *vc =[[ItemCommentsController alloc] initWithStyle:UITableViewStylePlain];
        vc.itemId = self.code;
        vc.itemType =@"provider";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
