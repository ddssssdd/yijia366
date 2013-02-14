//
//  Menu.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property (nonatomic,retain) NSArray *list;
+(Menu *)sharedMenu;
@end
