//
//  SetupUserController.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/24/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "SetupUserController.h"
#import "AppSettings.h"
#import "UIImageView+AFNetworking.h"
#import "BoundListController.h"
#import "AFHTTPClient.h"
#import "SVProgressHUD.h"
#import "Browser2Controller.h"

@interface SetupUserController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    id _user;
    UITextField *_txtname;
    UITextField *_txtsignature;
    UIImageView *_imageView;
    UIImageView *_imageCell;
    UIImage *_image;
}

@end

@implementation SetupUserController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonSystemItemAction target:self action:@selector(save)];
    
    [self load_data];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTableView)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
}
-(void)tapOnTableView{
    [self.view endEditing:NO];
    [self tapOnBigImage];
    /*
    [_txtsignature resignFirstResponder];
    [_txtname resignFirstResponder];
     */
}
-(void)save{
    //no judgement
    NSString *url = [NSString stringWithFormat:@"bound/save_user_info?userid=%d&nickname=%@&signature=%@",
                     [AppSettings sharedSettings].userid,
                     _user[@"nickname"],
                     _user[@"signature"]];
    
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_USER_PROFILE object:nil];
        }
    }];
}
-(void)load_data{
    NSString *url;
    if (self.taskid>0)
        url =[NSString stringWithFormat:@"bound/get_user_info?userid=%d&taskid=%d",[AppSettings sharedSettings].userid,self.taskid];
    else
        url =[NSString stringWithFormat:@"bound/get_user_info?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _user = json[@"result"];
            [self.tableView reloadData];
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 2;
        case 3:
            return 2;
            
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section==0){ //username
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.text =@"用户名";
        cell.detailTextLabel.text = _user[@"username"];
    }else if (indexPath.section==1){ //avatar
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text =@"设置头像";
        /*
        if (!_imageCell){
            _imageCell= [[UIImageView alloc] initWithFrame:CGRectMake(240, 2, 40, 40)];
            _imageCell.contentMode = UIViewContentModeScaleAspectFill;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage)];
            _imageCell.userInteractionEnabled = YES;
            
            [_imageCell addGestureRecognizer:tap];
        }*/
        _imageCell= [[UIImageView alloc] initWithFrame:CGRectMake(240, 2, 40, 40)];
        _imageCell.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage)];
        _imageCell.userInteractionEnabled = YES;
        
        [_imageCell addGestureRecognizer:tap];
        [_imageCell removeFromSuperview];
        [_imageCell setImageWithURLWithoutCache:[NSURL URLWithString:_user[@"photourl"]] placeholderImage:[UIImage imageNamed:@"m"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:_imageCell];
        
        

    }else if (indexPath.section==2){
        int topX = 14;
        if ([[AppSettings sharedSettings] isIos7]){
            topX = 4;
        }
        if (indexPath.row==0){
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.textLabel.text =@"姓名";
            if (!_txtname){
                _txtname = [[UITextField alloc] initWithFrame:CGRectMake(100, topX, 200, 36)];
                [_txtname addTarget:self action:@selector(nameChanged:) forControlEvents:UIControlEventEditingChanged];
                _txtname.placeholder =@"用户名称";
                _txtname.returnKeyType = UIReturnKeyNext;
                //_txtname.borderStyle = UITextBorderStyleLine;
                _txtname.clearButtonMode =UITextFieldViewModeAlways;
                [_txtname addTarget:self action:@selector(completeName) forControlEvents:UIControlEventEditingDidEndOnExit];
            }
            [_txtname removeFromSuperview];
            
            _txtname.text =_user[@"nickname"];
            [cell addSubview:_txtname];
        }else{
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.textLabel.text =@"签名";
            if (!_txtsignature){
                _txtsignature= [[UITextField alloc] initWithFrame:CGRectMake(100, topX, 200, 36)];
                [_txtsignature addTarget:self action:@selector(signatureChanged:) forControlEvents:UIControlEventEditingChanged];
                _txtsignature.placeholder =@"签名";
                _txtsignature.returnKeyType = UIReturnKeyDone;
                //_txtsignature.borderStyle = UITextBorderStyleLine;
                _txtsignature.clearButtonMode =UITextFieldViewModeAlways;
                [_txtsignature addTarget:self action:@selector(completeSignature) forControlEvents:UIControlEventEditingDidEndOnExit];
            }
            [_txtsignature removeFromSuperview];
            _txtsignature.text =_user[@"signature"];
            [cell addSubview:_txtsignature];
        }
    }else if (indexPath.section==3){
        if (indexPath.row==0){
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.textLabel.text =@"积分";
            cell.detailTextLabel.text = _user[@"bound"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.textLabel.text =@"经验值";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"LV%@ EXP%@",_user[@"level"],_user[@"exp"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    
    
    return cell;
}
-(void)completeSignature{
    [_txtsignature resignFirstResponder];
}
-(void)completeName{
    [_txtsignature becomeFirstResponder];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3){
        if (indexPath.row==0){
            BoundListController *vc = [[BoundListController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            Browser2Controller *vc = [[Browser2Controller alloc] initWithNibName:@"Browser2Controller" bundle:nil];
            vc.url = _user[@"exp_url"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section==1){
        //[self tapOnImage];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [actionSheet showInView:self.view];
        
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex ==1){
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}
-(void)nameChanged:(UITextField *)sender{
    _user[@"nickname"] = sender.text;
}
-(void)signatureChanged:(UITextField *)sender{
    _user[@"signature"] = sender.text;
}


-(void)tapOnImage{
    NSString *url = [NSString stringWithFormat:@"bound/get_user_photo?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [self showBigImage:json[@"result"]];
        }
    }];
}
-(void)showBigImage:(NSString *)url{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
    _imageView.contentMode = UIViewContentModeCenter;
    if ([url hasPrefix:@"http://"]){
        [_imageView setImageWithURLWithoutCache:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"m"]];
    }else{
        _imageView.image = [UIImage imageNamed:url];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBigImage)];
    [_imageView addGestureRecognizer:tap];
    _imageView.userInteractionEnabled = YES;
    [_imageView removeFromSuperview];
    [self.view addSubview:_imageView];
}
-(void)tapOnBigImage{
    [_imageView removeFromSuperview];
    _imageView = nil;
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    if (width <= maxWidth && height <= maxHeight)
    {
        return image;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > maxWidth || height > maxHeight)
    {
        CGFloat ratio = width/height;
        if (ratio > 1)
        {
            bounds.size.width = maxWidth;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = maxHeight;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (!error){
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:@"Image written to photo album"delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [av show];
    }else{
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Error writing to photo album: %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [av show];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image =[info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self saveImage:[self scaleToSize:_image size:CGSizeMake(600, 600)]];
    [self saveImage:[self scaleImage:_image maxWidth:640 maxHeight:960]];
}

- (void) pickImage:(UIImagePickerControllerSourceType )sourceType
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = sourceType;
    ipc.delegate =self;
    ipc.allowsEditing =NO;
    [self presentViewController:ipc animated:YES completion:nil];
    
    
}
-(void)saveImage:(UIImage *)image
{
    NSString *url =[NSString stringWithFormat:@"upload/upload_user_photo?userid=%d",[AppSettings sharedSettings].userid];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVERURL]];
    NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:url parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
        NSString *filename = [NSString stringWithFormat:@"upload.png"];
        [formData appendPartWithFileData:imageData name:@"userfile" fileName:filename mimeType:@"image/png"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",[AppSettings sharedSettings].userid] dataUsingEncoding:NSUTF8StringEncoding]  name:@"userid"];
       
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"iphone"] dataUsingEncoding:NSUTF8StringEncoding]  name:@"from"];
        
        
        
    }];
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        id jsonResult =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%@",jsonResult);
        if ([[AppSettings sharedSettings] isSuccess:jsonResult]){
            //[_imageCell setImageWithURL:[NSURL URLWithString:jsonResult[@"result"]] placeholderImage:[UIImage imageNamed:@"m"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_USER_PROFILE object:nil];
            /*
            _user[@"photourl"]=jsonResult[@"result"];
            [self.tableView reloadData];
             */
            _imageCell.image = image;
        }
        if (![[jsonResult objectForKey:@"status"] isEqualToString:@"success"]){
            NSString *message = @"发生异常，请稍后再试.";
            if ([[jsonResult allKeys] containsObject:@"message"]){
                message = [jsonResult objectForKey:@"message"];
            }
            [SVProgressHUD dismissWithSuccess:message afterDelay:3];
        }else{
            id alertMsg = jsonResult[@"alertmsg"];
            if (alertMsg && ![alertMsg isKindOfClass:[NSNull class]] && ![alertMsg isEqualToString:@""]){
                [SVProgressHUD dismissWithSuccess:alertMsg afterDelay:3];
            }else{
                [SVProgressHUD dismissWithSuccess:@"图片上传成功！" afterDelay:3];
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Access server error:%@,because %@",error,operation.request);
        
        
    }];
    [SVProgressHUD showWithStatus:@"正在上传图片..."];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}
@end
