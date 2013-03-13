//
//  EditTableViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "EditTableViewController.h"
#import "EditTextCell.h"
#import "DatePickerViewController.h"
#import "LicenseTypeViewController.h"
#import "AppSettings.h"

@interface EditTableViewController (){
    id _sections;
    id _items;
    NSMutableDictionary *_result;
}

@end

@implementation EditTableViewController
-(id)initWithDelegate:(id)delegate{
    self = [self initWithNibName:@"EditTableViewController" bundle:nil];
    if (self){
        self.delegate = delegate;
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]  initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   
    
    [super viewDidUnload];
}
-(void)save:(id)sender{
    
    
    for (UIView *v in [self.tableView subviews]) {
        if ([v isKindOfClass:[EditTextCell class]]){
            EditTextCell *cell = (EditTextCell *)v;
            [_result setObject:cell.valueText.text forKey:cell.key];
        }
        
    }
    [_result setObject:[NSString stringWithFormat:@"%d", [AppSettings sharedSettings].userid] forKey:@"user_id"];
    [self.delegate saveData:_result];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



-(void)initData{
    
    _sections =[self.delegate getSections];
    _items =[self.delegate getItems];
    _result =[NSMutableDictionary dictionaryWithDictionary:[self.delegate getInitData]];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_items objectAtIndex:section] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sections objectAtIndex:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    EditTextCell *cell =nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSArray *cells =[[NSBundle mainBundle] loadNibNamed:@"EditTextCell" owner:self.tableView options:nil];
        cell =[cells objectAtIndex:0];
        
        cell.valueText.delegate = self;
    }

    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *value =[_result objectForKey:item[@"key"]];
    cell.keyLabel.text = item[@"name"];
    cell.valueText.placeholder = item[@"name"];
    cell.valueText.text = [NSString stringWithFormat:@"%@",value];
    cell.key = item[@"key"];
    //cell.valueLabel.text = value;
    if (![item[@"vcname"] isEqualToString:@""]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.tag = indexPath.row;
    cell.valueText.tag = indexPath.row;
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditTextCell *cell =(EditTextCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *value = cell.valueText.text;
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *vcname=item[@"vcname"];
    if (![vcname isEqualToString:@""]){
        if ([vcname isEqualToString:@"DatePickerViewController"]){
            DatePickerViewController *vc = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
            vc.keyname = item[@"key"];//@"init_date";
            vc.delegate = self;
            
            [self.navigationController pushViewController:vc animated:YES];
            vc.value = value;
        }else{
            LicenseTypeViewController *vc = [[LicenseTypeViewController alloc] initWithNibName:vcname bundle:nil];
            vc.delegate = self;
            
            [self.navigationController pushViewController:vc animated:YES];
            vc.value = value;
        }
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    /*
     EditTableCell *cell =(EditTableCell *)[self.tableView viewWithTag:textField.tag];
     NSIndexPath *path =[self.tableView indexPathForCell:cell];
     [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
     */
    return YES;
}

-(void)setValueByKey:(NSString *)value key:(NSString *)key{
    [_result setObject:value forKey:key];
    NSLog(@"%@",_result);
    [self.tableView reloadData];
}

@end
