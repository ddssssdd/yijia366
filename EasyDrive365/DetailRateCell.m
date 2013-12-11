//
//  DetailRateCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/11/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "DetailRateCell.h"
@interface DetailRateCell()<StarRatingViewDelegate>{
    TQStarRatingView *_ratingView;
}
@end
@implementation DetailRateCell

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

-(void)setRating:(CGFloat)rating{
    if (_ratingView==nil){
        _ratingView =[[TQStarRatingView alloc] initWithFrame:CGRectMake(20, 11, 75, 21) numberOfStar:rating];
        [self addSubview:_ratingView];
        _ratingView.delegate= self;
    }

}
-(void)starRatingView:(TQStarRatingView *)view score:(float)score{
    NSLog(@"%f",score);
}
@end
