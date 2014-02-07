//
//  ArticleListItemCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/12/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ArticleListItemCell.h"
#import "AMRatingControl.h"
#import "AppSettings.h"

@interface ArticleListItemCell(){
    AMRatingControl *_ratingControl;
}

@end

@implementation ArticleListItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRating:(int)rating{
    if (!_ratingControl){
        _ratingControl =[[AMRatingControl alloc] initWithLocation:CGPointMake(185, 88) andMaxRating:5];
        [_ratingControl setRating:rating];
        [self addSubview:_ratingControl];
        [_ratingControl setEnabled:NO];
    }
}
- (IBAction)favorBtnPressed:(id)sender {
    NSLog(@"favor");
    if ([self.share_data[@"is_favor"] intValue]==0){
        NSString *url = [NSString stringWithFormat:@"favor/add?userid=%d&id=%@&type=ATL",[AppSettings sharedSettings].userid,self.share_data[@"id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [self.favorbtn setImage:[UIImage imageNamed:@"favor"] forState:UIControlStateNormal];
                [self setNeedsLayout];
                self.share_data[@"is_favor"]=@"1";
            }
        }];
    }else{
        NSString *url = [NSString stringWithFormat:@"favor/del?userid=%d&id=%@",[AppSettings sharedSettings].userid,self.share_data[@"favor_id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [self.favorbtn setImage:[UIImage imageNamed:@"favorno"] forState:UIControlStateNormal];
                [self setNeedsLayout];
                self.share_data[@"is_favor"]=@"0";
            }
        }];
    }
    
    
    
}
- (IBAction)shareBtnPressed:(id)sender {
    [[AppSettings sharedSettings] popupShareMenu:self.share_data[@"share_title"] introduce:self.share_data[@"share_intro"] url:self.share_data[@"share_url"]];
}
@end
