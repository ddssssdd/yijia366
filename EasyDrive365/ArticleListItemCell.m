//
//  ArticleListItemCell.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/12/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ArticleListItemCell.h"
#import "AMRatingControl.h"

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
        _ratingControl =[[AMRatingControl alloc] initWithLocation:CGPointMake(125, 88) andMaxRating:5];
        [_ratingControl setRating:rating];
        [self addSubview:_ratingControl];
        [_ratingControl setEnabled:NO];
    }
}

@end
