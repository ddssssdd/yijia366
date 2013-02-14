//
//  AppSettings.m
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/30/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings
@synthesize firstName=_firstName;
@synthesize lastName=_lastName;
@synthesize isLogin = _isLogin;
@synthesize userid=_userid;
@synthesize list = _list;
@synthesize latest_news =_latest_news;
@synthesize local_data =_local_data;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if (self)
    {
        _firstName = [aDecoder decodeObjectForKey:@"firstname"];
        _lastName =[aDecoder decodeObjectForKey:@"lastname"];
        _isLogin =[aDecoder decodeBoolForKey:@"isLogin"];
        _userid =[aDecoder decodeInt32ForKey:@"userid"];
        _list =[aDecoder decodeObjectForKey:@"list"];
        _latest_news =[aDecoder decodeObjectForKey:@"latest_news"];
        _local_data =[aDecoder decodeObjectForKey:@"local_data"];
        
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_firstName forKey:@"firstname"];
    [aCoder encodeObject:_lastName forKey:@"lastname"];
    [aCoder encodeBool:_isLogin forKey:@"isLogin"];
    [aCoder encodeInt32:_userid forKey:@"userid"];
    [aCoder encodeObject:_list forKey:@"list"];
    [aCoder encodeObject:_latest_news forKey:@"latest_news"];
    [aCoder encodeObject:_local_data forKey:@"local_data"];
}



+(AppSettings *)sharedSettings
{
    static AppSettings *_instance;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        //_instance = [[AppSettings alloc] init];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSData *udObject =[userDefault objectForKey:NSStringFromClass([self class])];
        _instance =[NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    });
    return _instance;
}



- (void)save{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [userDefault setObject:udObject forKey:NSStringFromClass([self class])];
    [userDefault synchronize];
    
}
//local data process
-(void)saveJsonWith:(NSString *)className data:(id)data{
    if (!_local_data){
        _local_data =[[NSMutableDictionary alloc] init];
        
    }
    id item =@{@"date" : [NSDate date],@"data":data};
    [_local_data setObject:item forKey:className];
    [self save];

}
-(id)loadJsonBy:(NSString *)className{
    if (_local_data){
        return [[_local_data objectForKey:className] objectForKey:@"data"];
    }else{
        return nil;
    }
}

//http process
-(BOOL)isSuccess:(id)json
{
    return [[json objectForKey:@"status"] isEqualToString:@"success"];
}
-(NSString *)url_for_get_news
{
    return [NSString stringWithFormat:@"api/get_news?userid=%d",self.userid];
}
-(NSString *)url_for_get_helpcalls
{
    return [NSString stringWithFormat:@"api/get_helps?userid=%d",self.userid];
}
-(NSString *)url_for_rescue{
    return [NSString stringWithFormat:@"api/get_rescues?userid=%d",self.userid];
}

-(NSString *)url_for_illegallys{
    return [NSString stringWithFormat:@"api/get_illegally_list?userid=%d",self.userid];
}
-(NSString *)url_for_insurance_list{
    return [NSString stringWithFormat:@"api/get_insurance_process_list?userid=%d",self.userid];
}

-(NSString *)url_for_maintain_list{
    return [NSString stringWithFormat:@"api/get_car_maintain_list?userid=%d",self.userid];
}


@end
