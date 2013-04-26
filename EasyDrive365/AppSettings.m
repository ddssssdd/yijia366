//
//  AppSettings.m
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/30/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AppSettings.h"
#import "HttpClient.h"
@implementation Information
-(void)setDataFromJsonWithKey:(id)json key:(NSString *)key{
    if (json[@"result"]){
        self.company = json[@"result"][@"company"];
        self.phone =json[@"result"][@"phone"];
        self.latest =json[@"result"][@"latest"];
        self.updateTime =json[@"result"][@"updated_time"];
    }
}
@end

@implementation AppSettings
@synthesize firstName=_firstName;
@synthesize lastName=_lastName;
@synthesize isLogin = _isLogin;
@synthesize userid=_userid;
@synthesize deviceToken=_deviceToken;
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
        _deviceToken =[aDecoder decodeObjectForKey:@"device_token"];
        _dict = [[NSMutableDictionary  alloc] init];
        [self init_latest];
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
    [aCoder encodeObject:_deviceToken forKey:@"device_token"];
}

-(id)init{
    self = [super init];
    if (self){
        _dict = [[NSMutableDictionary  alloc] init];
        [self init_latest];
    }
    return self;
}

+(AppSettings *)sharedSettings
{
    static AppSettings *_instance;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        //_instance = [[AppSettings alloc] init];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSData *userDefaultData =[userDefault objectForKey:NSStringFromClass([self class])];
        if (userDefaultData){
            _instance =[NSKeyedUnarchiver unarchiveObjectWithData:userDefaultData];
        }else{
            _instance =[[AppSettings alloc] init];
        }
        
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
    [_local_data setObject:item forKey:[self jsonKey:className]];
    [self save];

}
-(id)loadJsonBy:(NSString *)className{
    if (_local_data){
        return [[_local_data objectForKey:[self jsonKey:className]] objectForKey:@"data"];
    }else{
        return nil;
    }
}
-(NSString *)jsonKey:(NSString *)className{
    return [NSString stringWithFormat:@"%@_by_%d",className,self.userid];
}


-(void)setDeviceToken:(NSString *)deviceToken{
  
    _deviceToken=[[deviceToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken=%@",_deviceToken);
    [self register_device_token];
}
-(void)register_device_token
{
    if (self.userid && self.userid>0 && _deviceToken){
        HttpClient *http = [HttpClient sharedHttp];
        NSString *url = [NSString stringWithFormat:@"pushapi/add_device?userid=%d&device_token=%@&udid=%@",self.userid,_deviceToken,[self udid]];
        [http get:url block:^(id json) {
            NSLog(@"%@",json);
        }];
    }
}
-(void)login:(NSString *)username userid:(int)userid{
    self.userid = userid;
    self.firstName = username;
    self.isLogin = YES;
    [self save];
    [self register_device_token];
    self.isNeedRefresh=YES;
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

-(NSString *)url_for_post_maintain_record{
    return [NSString stringWithFormat:@"api/add_maintain_record?user_id=%d",self.userid];
}
-(NSString *)url_for_get_maintain_record{
    return [NSString stringWithFormat:@"api/get_maintain_record?userid=%d",self.userid];
}
-(NSString *)url_getlatest:(NSString *)keyname{
    return [NSString stringWithFormat:@"api/get_latest?userid=%d&keyname=%@",self.userid,keyname];
}

-(NSString *)url_get_driver_license{
    return [NSString stringWithFormat:@"api/get_driver_license?userid=%d",self.userid];
}
-(NSString *)url_get_car_registration{
    return [NSString stringWithFormat:@"api/get_car_registration?userid=%d",self.userid];
}

-(NSString *)url_get_suggestion_insurance{
    return [NSString stringWithFormat:@"api/get_suggestion_of_insurance?userid=%d",self.userid];
}

-(NSString *)url_get_license_type{
    return @"api/get_license_type";
}


-(NSString *)url_get_business_insurance{
    return [NSString stringWithFormat:@"api/get_Policys?userid=%d",self.userid];
}

-(NSString *)url_get_count_of_suggestions{
    return [NSString stringWithFormat:@"api/get_count_of_suggestion?userid=%d",self.userid];
}

-(NSString *)url_change_password:(NSString *)newPassword  oldPassword:(NSString *)oldPassword{
    return [NSString stringWithFormat:@"api/reset_user_pwd?userid=%d&oldpwd=%@&newpwd=%@",self.userid,oldPassword,newPassword];
}

-(NSString *)udid{
    UIDevice *device =[UIDevice currentDevice];
    //return [NSString stringWithFormat:@"%@", device.identifierForVendor];
    NSString *ident = nil;
    if ([device respondsToSelector:@selector(identifierForVendor)]) {
        ident = [device.identifierForVendor UUIDString];
    } else {
        ident = device.uniqueIdentifier;
    }
    return ident;
}

-(void)makeCall:(NSString *)phone{
    if (phone){
        NSString *phoneNumber = [@"tel://" stringByAppendingString:phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}


-(void)init_latest{
    for(int i=0;i<11;i++){
        NSString *key = [NSString stringWithFormat:@"%02d",i];
        Information *infor = [[Information alloc] init];
        id json = [self loadJsonBy:[NSString stringWithFormat:@"NavigationCell_%@",key]];
        NSLog(@"%@",json);
        if (json){
            [infor setDataFromJsonWithKey:json key:key];
        }
        [_dict setObject:infor forKey:key];
    }
}
-(void)get_latest{
    if (!self.isLogin){
        return;
    }
    self.isNeedRefresh= NO;
    for(int i=0;i<11;i++){
        NSString *keyname = [NSString stringWithFormat:@"%02d",i];
        [self get_latest_by_key:keyname];
    }
}
-(void)get_latest_by_key:(NSString *)keyname{
    NSString *url = [self url_getlatest:keyname];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd"];
            json[@"result"][@"updated_time"]=[formatter stringFromDate:[NSDate date]];
           // NSLog(@"%@",keyname);
            [[AppSettings sharedSettings] saveJsonWith:[NSString stringWithFormat:@"NavigationCell_%@",keyname]data:json];
            Information *infor =[_dict objectForKey:keyname];
            if (!infor){
                infor =[[Information alloc] init];
            }
            [infor setDataFromJsonWithKey:json key:keyname];
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NavigationCell_%@",keyname] object:infor];
            
        }else{
            NSLog(@"%@",json);
            //get nothing from server;
        }
    }];
}
-(Information *)getInformationByKey:(NSString *)key{
    //NSLog(@"%@",_dict);
    return [_dict objectForKey:key];
}

-(void)add_login:(NSString *)username password:(NSString *)password rememberPassword:(NSString *)rememberPassword{
    if (!_list){
        _list = [[NSMutableArray alloc] init];
    }
    
    for (id item in _list) {
        NSString *uname =item[@"username"];
        if ([uname isEqualToString:username]){
            [_list removeObject:item];
            break;
        }
    }
    id item = @{@"username":username,@"password":password,@"remember":rememberPassword};
    [_list addObject:item];
    NSLog(@"%@",_list);
    [self save];
}
-(NSMutableArray *)get_logins{
    if (!_list){
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}
@end
