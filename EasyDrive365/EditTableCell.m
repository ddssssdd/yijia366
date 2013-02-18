//
//  EditTableCell.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "EditTableCell.h"

@implementation EditTableCell

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
-(void)endEdit{
    self.valueLabel.text= self.valueText.text;
    [self setEditable:NO];
}
-(void)setEditable:(BOOL)isedit{
    self.valueLabel.hidden = isedit;
    self.valueText.hidden = !isedit;
    
}
-(void)setValueByKey:(NSString *)key value:(NSString *)value{
    self.key = key;
    self.value = value;
    self.valueLabel.text = [value isKindOfClass:[NSNull class]]?@"":value;
    self.valueText.text = [value isKindOfClass:[NSNull class]]?@"":value;
}
-(void)start_listen{
    if (_inListen){
        return;
    }
    _inListen = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listen:) name:self.key object:nil];
}
-(void)listen:(NSNotification *)notification{
    [self setValueByKey:self.key value: notification.userInfo[@"result"]];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
