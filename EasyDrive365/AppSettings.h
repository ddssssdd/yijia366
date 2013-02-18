//
//  AppSettings.h
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/30/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject<NSCoding>

@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic) BOOL isLogin;
@property (nonatomic) int userid;

@property (nonatomic,retain) NSMutableDictionary *local_data;
@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) id latest_news;

+(AppSettings *)sharedSettings;


-(void)save;

//local data process
-(void)saveJsonWith:(NSString *)className data:(id)data;
-(id)loadJsonBy:(NSString *)className;

//http process
-(BOOL)isSuccess:(id)json;
-(NSString *)url_for_get_news;
-(NSString *)url_for_get_helpcalls;
-(NSString *)url_for_rescue;
-(NSString *)url_for_illegallys;
-(NSString *)url_for_insurance_list;
-(NSString *)url_for_maintain_list;

-(NSString *)url_for_post_maintain_record;
-(NSString *)url_for_get_maintain_record;

-(NSString *)url_getlatest;

-(NSString *)url_get_driver_license;
-(NSString *)url_get_car_registration;
@end
