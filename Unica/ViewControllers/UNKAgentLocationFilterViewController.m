//
//  UNKAgentLocationFilterViewController.m
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAgentLocationFilterViewController.h"

@interface UNKAgentLocationFilterViewController (){
    NSMutableDictionary *dictLogin;
}

@end

@implementation UNKAgentLocationFilterViewController


-(void)viewDidLoad{

    [super viewDidLoad];
    
    // google analytics
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Agent Location Filter"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
     dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    
    [_searchTextField addTarget:self action:@selector(searchTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _searchTextField.delegate = self;
    _searchTextField.placeholder = @"Type here";
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

   
    NSLog(@"%@",[kUserDefault valueForKey:kIsRemoveAll]);
    
    if (![[kUserDefault valueForKey:kIsRemoveAll] isEqualToString:@"Yes"]) {
        
         NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectedLocation]];
        
        if (dict.count>0 && ![dict isKindOfClass:[NSNull class]]) {
            _filterDictionaty = [dict valueForKey:kselectedLocation];
            
            _searchTextField.text = [dict valueForKey:kselectedLocation];
        }
       else if (([[Utility replaceNULL:appDelegate.addressString value:@""]length]>0)) {
            _searchTextField.text = appDelegate.addressString;
        }
        
        else{
            
            
            if ([dictLogin valueForKey:kresidential_city]) {
                
                _searchTextField.text = [dictLogin valueForKey:kresidential_city];
            }
            
            else{
                _searchTextField.text = appDelegate.addressString;
            }
            
        }
    }
    else{
    
        _searchTextField.text = @"";
       
         _filterDictionaty = [[NSMutableDictionary alloc]init];
        
    }
    
    
  
    NSLog(@"%@",appDelegate.addressString);
    
    _locationView.layer.borderWidth = 1.0;
    _locationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _locationView.layer.cornerRadius = 5.0;
    [_locationView.layer setMasksToBounds:YES];
    
    _locationBackgroundView.layer.cornerRadius = 5.0;
    [_locationBackgroundView.layer setMasksToBounds:YES];
    
  /*  NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectedLocation]];
    
    if (dict.count>0 && ![dict isKindOfClass:[NSNull class]]) {
        _filterDictionaty = [dict valueForKey:kselectedLocation];
        
        _searchTextField.text = [dict valueForKey:kselectedLocation];
    }
    else{
        _filterDictionaty = [[NSMutableDictionary alloc]init];
    }*/

    pageNumber = 0;
    
    _locationTable.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    _locationTable.hidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([[kUserDefault valueForKey:kfilterscleared] isEqualToString:kfilterscleared]) {
        
        [kUserDefault removeObjectForKey:kselectedLocation];
        [kUserDefault setValue:@"" forKey:kfilterscleared];
    }
    else {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:_searchTextField.text forKey:kselectedLocation];
    
    [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectedLocation];
    }
}

-(void)searchLocationData{
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    [dictionary setValue:_searchTextField.text forKey:ksearchinput];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    [dictionary setValue:@"" forKey:ksearchinput];
    [dictionary setValue:@"" forKey:kPageNumber];
    
    [self getSearchData:dictionary];
}

#pragma mark - APIS
/****************************
 * Function Name : - getSearchData
 * Create on : - 21 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for call APIs
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getSearchData:(NSMutableDictionary*)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent-location-search.php"];
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    _locationTable.hidden = NO;
                    
                    if (pageNumber == 0 ) {
                        if (searchArray) {
                            [searchArray removeAllObjects];
                        }
                    searchArray = [dictionary valueForKey:kAPIPayload];
                        
                        pageNumber = 1;
                    }
                    else{
                        NSMutableArray *arr = [dictionary valueForKey:kAPIPayload];
                        
                        
                        if(arr.count > 0){
                            [searchArray addObjectsFromArray:arr];
                        }
                        NSLog(@"%lu",(unsigned long)searchArray.count);
                        pageNumber = pageNumber+1 ;
                    }
                    
                    [_locationTable reloadData];
                    
                    // show message if no recoed found
                    if (searchArray.count > 0) {
                        if (messageLabel) {
                            messageLabel.text = @"";
                            [messageLabel removeFromSuperview];
                        }
                    }
                    
                    else{
                        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
                        messageLabel.text = @"No records found...";
                        messageLabel.textAlignment = NSTextAlignmentCenter;
                        messageLabel.textColor = [UIColor whiteColor];
                        [self.view addSubview:messageLabel];
                        
                    }
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
            
        }
        
        
    }];
    
}


#pragma  mark - Table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   // return [searchArray count];
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"location"];
    cell.backgroundColor = kDefaultBlueColor;
    
    if ([searchArray count]>0) {
        cell.textLabel.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:kName];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _locationTable.hidden = YES;
    _filterDictionaty  = [searchArray objectAtIndex:indexPath.row];
    
//    if ([self.delegate respondsToSelector:@selector(getSearchData:)]) {
//        [self.delegate getSearchData:[searchArray objectAtIndex:indexPath.row]];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}

#pragma  mark - Search bar delegate


-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"%@",_searchTextField.text);
    
    if([_searchTextField.text isEqualToString:@""])
    {
        pageNumber = 0;
        [searchArray removeAllObjects];
        [_locationTable reloadData];
    }
    else{
        
        NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        
        [dictionary setValue:_searchTextField.text forKey:ksearchinput];
        if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
            [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
        }
        else{
            [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
        }
        [dictionary setValue:_searchTextField.text forKey:ksearchinput];
        [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
        
        [self getSearchData:dictionary];
    }
}


#pragma mark - Button clicked Action

/****************************
 * Function Name : - button clicked Action
 * Create on : - 14 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for get button clicked Action
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Scrol view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate{
    if(!isLoading)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 10;
        if(y > h + reload_distance) {
            NSLog(@"End Scroll %f",y);
            if (pageNumber != totalRecord) {
                NSLog(@"Call API for pagging from %d for total pages %d",pageNumber,totalRecord);
                isLoading = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
                _locationTable.tableFooterView = spinner;
                
                NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
                
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
                
                [dictionary setValue:_searchTextField.text forKey:ksearchinput];
                if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
                    [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
                }
                else{
                    [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
                }
                [dictionary setValue:_searchTextField.text forKey:ksearchinput];
                [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
                
                [self getSearchData:dictionary];
            }
            
        }
    }
    
    else{
        
        _locationTable.tableFooterView = nil;
    }
}

#pragma  mark - button clicked

-(void)searchTextFieldValueChanged:(UITextField *)textField{

   /* if (_timer) {
        if ([_timer isValid]){ [
        _timer invalidate];
        }
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];*/
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self timeAction:searchBar.text];
    [_searchTextField resignFirstResponder];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_searchTextField resignFirstResponder];

    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.applyBtnFloatConstant.constant=340+5;
    return  YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [_searchTextField resignFirstResponder];
    if (![[kUserDefault valueForKey:kIsRemoveAll] isEqualToString:@"Yes"])
    {
        if([Utility replaceNULL:_searchTextField.text value:@""].length>0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:_searchTextField.text forKey:kselectedLocation];
            
            [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectedLocation];
        }

    }
       self.applyBtnFloatConstant.constant=97;
    return  YES;
}

- (IBAction)applyButton_clicked:(id)sender {
    
    [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
    if ([self.agentLocation respondsToSelector:@selector(agentLocationFilter:)]) {
        [self.agentLocation agentLocationFilter:@"1"];
    }
    [self.navigationController popViewControllerAnimated:NO];

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_searchTextField resignFirstResponder];
}
@end
