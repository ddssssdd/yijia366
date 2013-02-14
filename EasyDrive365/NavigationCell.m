//
//  NavigationCell.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NavigationCell.h"

@implementation NavigationCell

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
- (IBAction)buttonPress {
    NSLog(@"I am pressed,i will call:%@",self.phone);
}

@end
