//
//  CustomEditTableViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CustomEditTableViewController.h"
#import "IntroduceCell.h"
#import "EditTextCell.h"
#import "OneButtonCell.h"

@interface CustomEditTableViewController ()<UITextFieldDelegate,OneButtonCellDelegate>{
    
    int textfield_count;
}

@end

@implementation CustomEditTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)init_setup{
    _saveButtonName =@"登录";
}
- (void)viewDidLoad
{
    [self init_setup];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self.navigationController setNavigationBarHidden:NO];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_saveButtonName style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    [self initData];
}
-(void)initData{
    /*
    id items=@[
    @{@"key" :@"username",@"label":@"用户名：",@"default":@"",@"placeholder":@"" },
    @{@"key" :@"password",@"label":@"密码：",@"default":@"",@"placeholder":@"" },
    @{@"key" :@"repassword",@"label":@"再输一遍：",@"default":@"",@"placeholder":@"" }
    ];
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"cell":@"IntroduceCell",@"list":@[],@"height":@100.0f},
           @{@"count" : @5,@"cell":@"EditTextCell",@"list":items,@"height":@44.0f},
           @{@"count" : @1,@"cell":@"OneButtonCell",@"list":@[],@"height":@44.0f}
           ]];
    
    */
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_list objectAtIndex:section][@"count"] intValue];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[_list objectAtIndex:indexPath.section][@"height"] intValue];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil){
        NSString *cellCalssName = [_list objectAtIndex:indexPath.section][@"cell"];
        if ([cellCalssName isEqualToString:@"default"]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }else{
            cell= [[[NSBundle mainBundle] loadNibNamed:cellCalssName owner:nil options:nil] objectAtIndex:0];
        }
    
       
    }
    [self setupCell:cell indexPath:indexPath];
    return cell;
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSString *cellCalssName = [_list objectAtIndex:indexPath.section][@"cell"];
    
    if ([cellCalssName isEqualToString:@"EditTextCell"]){
        textfield_count = [[_list objectAtIndex:indexPath.section][@"count"] intValue];
        NSArray *items = [_list objectAtIndex:indexPath.section][@"list"];
        id item = [items objectAtIndex:indexPath.row];
        NSLog(@"%@",item);
        EditTextCell *aCell =(EditTextCell *)cell;
        aCell.keyLabel.text = item[@"label"];
        aCell.key = item[@"key"];
        aCell.valueText.delegate = self;
        aCell.valueText.tag = indexPath.row;
        if ([item[@"ispassword"] isEqualToString:@"yes"]){
            aCell.valueText.secureTextEntry=YES;
        }else{
            aCell.valueText.secureTextEntry =NO;
        }
        if (indexPath.row <textfield_count-1){
            aCell.valueText.returnKeyType = UIReturnKeyNext;
        }else{
            aCell.valueText.returnKeyType = UIReturnKeyGo;
        }
    }else if ([cellCalssName isEqualToString:@"OneButtonCell"]){
        OneButtonCell *aCell =(OneButtonCell *)cell;
        aCell.delegate = self;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
   
    if (textField.tag==textfield_count-1){
        [self done];
    }else{
        [self setResponser:textField.tag+1];
    }
    return YES;
}
-(void)setResponser:(int)tag{
    for (UIView *v in [self.tableView subviews]) {
        if ([v isKindOfClass:[EditTextCell class]]){
            EditTextCell *cell = (EditTextCell *)v;
            if (cell.valueText.tag==tag){
                [cell.valueText becomeFirstResponder];
            }
        }
        
    }
}
-(void)done{
    NSMutableDictionary *_result =[[NSMutableDictionary alloc] init];
    for (UIView *v in [self.tableView subviews]) {
        if ([v isKindOfClass:[EditTextCell class]]){
            EditTextCell *cell = (EditTextCell *)v;
            [_result setObject:cell.valueText.text forKey:cell.key];
        }
        
    }
    //NSLog(@"%@",_result);
    [self processSaving:_result];
    
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    
}
-(void)buttonPress:(id)sender{
    [self done];
}



@end
