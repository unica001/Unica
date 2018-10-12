//
//  UNKCountryFilterViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 05/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKCountryFilterViewC.h"
#import "CourserFilterCell.h"

@interface UNKCountryFilterViewC ()

@end

@implementation UNKCountryFilterViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_searchTextField addTarget:self action:@selector(searchTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _searchTextField.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    _searchTextField.text = @"";
    filterArray = [[NSMutableArray alloc]init];
    
    if ([self.title isEqualToString:kCOUNTRY]) {
        _searchTextField.placeholder = @"Search country";
        NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountry]];
        
        if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountry] isKindOfClass:[NSMutableArray class]]) {
            self.eventCountryFilterArray = [dict valueForKey:kselectCountry];
        }
        else{
            self.eventCountryFilterArray = [[NSMutableArray alloc]init];
        }
        if (self.eventCountryFilterArray.count>0) {
            [filterArray addObjectsFromArray:self.eventCountryFilterArray];
            [dataTable reloadData];
            [dataTable setHidden:NO];
            [courseFilterTable setHidden:YES];
        }
    }
    pageNumber = 0;
}


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

#pragma mark - APIS
/****************************
 * Function Name : - getSearchData
 * Create on : - 21 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for call APIs
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getSearchData:(NSMutableDictionary*)dictionary {
    
    NSString *url;
    // show loading indicator
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    courseFilterTable.tableHeaderView = spinner;
    
    if ([self.title isEqualToString:kCOUNTRY]){
        url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"country_search.php"];
    }
//    else if ([self.title isEqualToString:KCITY]){
//        url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent-location-search.php"];
//    }
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                courseFilterTable.tableHeaderView = nil;
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    //                    if (pageNumber == 0) {
                    if (searchArray) {
                        [searchArray removeAllObjects];
                    }
                    
                    if ([self.title isEqualToString:kINSTITUTION]) {
                        searchArray = [[dictionary valueForKey:kAPIPayload] valueForKey:@"institute"];
                        
                        dataTable.hidden = YES;
                        courseFilterTable.hidden = NO;
                        [courseFilterTable reloadData];
                    }
                    
                    else if ([self.title isEqualToString:KCITY]) {
                        searchArray = [dictionary valueForKey:kAPIPayload];
                    }
                    isLoading = YES;
                    [courseFilterTable reloadData];
                    
                    // show message if no recoed found
                    if (searchArray.count > 0) {
                        if (messageLabel) {
                            messageLabel.text = @"";
                            [messageLabel removeFromSuperview];
                        }
                    }
                    
                    else{
                        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
                        messageLabel.text = @"No review found";
                        messageLabel.textAlignment = NSTextAlignmentCenter;
                        messageLabel.textColor = [UIColor whiteColor];
                        [self.view addSubview:messageLabel];
                        
                    }
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        courseFilterTable.tableHeaderView = nil;
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
        } 
    }];
    
}

#pragma  mark - Table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == courseFilterTable) {
        return [searchArray count];
    }
    return filterArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == courseFilterTable) {
        static NSString *cellIdentifier3  =@"courseFilterCell";
        
        CourserFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CourserFilterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.checkMarkLeftImageHeight.constant = 20;
        cell.checmarkRightImage.hidden = YES;
        headerViewY_Axis.constant = 16;
        if ([self.title isEqualToString:kCOUNTRY]){ // country
            cell.checkMarkLeftImageHeight.constant = 0;
            cell.checkMarkLeftImage.hidden = YES;
            if ([searchArray count]>0) {
                cell.nameLabel.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:kName];
            }
        }
        return cell;
    }
    static NSString *cellIdentifier  =@"cell";
    
    countryDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"countryDataCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.title isEqualToString:kCOUNTRY]) { // country
        
        if ([filterArray count]>0) {
            cell.countryNameLabel.text = [[filterArray objectAtIndex:indexPath.row] valueForKey:kName];
        }
    }
    
   
    [cell.crossButton addTarget:self action:@selector(removeSelectedData:) forControlEvents:UIControlEventTouchUpInside];
    cell.crossButton.tag = indexPath.row;
    return  cell;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == courseFilterTable) {
        
        if ([self.title isEqualToString:kCOUNTRY]) { // Event filter
            if (filterArray.count >= 10) {
                [Utility showAlertViewControllerIn:self title:@"" message:@"You can select max 10 countries." block:^(int index){}];
            } else {
                if (![filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                    [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
                }
                [self.eventCountryFilterArray removeAllObjects];
                [self.eventCountryFilterArray addObjectsFromArray:filterArray];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountry];
                
                [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountry];
                
                [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
                [kUserDefault synchronize];
            }
            dataTable.hidden = NO;
            courseFilterTable.hidden = YES;
            [dataTable reloadData];
            
        }
        _searchTextField.text = @"";
        [_searchTextField resignFirstResponder];
        [dataTable reloadData];
        [courseFilterTable reloadData];
    }
}

#pragma  mark - Search bar delegate
-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    
    if (_searchTextField.text.length < 3) {
        return;
    }
    
    if([_searchTextField.text isEqualToString:@""]) {
        pageNumber = 0;
        [searchArray removeAllObjects];
        [courseFilterTable reloadData];
    } else{
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        
        [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
        if ([self.title isEqualToString:kCOUNTRY]) {
            [dictionary setValue:_searchTextField.text forKey:kSearch_country];
        }
//        if (![self.title isEqualToString:KCITY]) {
//            [self getSearchData:dictionary];
//            
//        }
    }
    
}

#pragma  mark - button clicked

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_searchTextField resignFirstResponder];
    return  YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.applyBtnFloatConstant.constant=340+5;
    return  YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [_searchTextField resignFirstResponder];
    self.applyBtnFloatConstant.constant=97;

    return  YES;
}

-(void)searchTextFieldValueChanged:(UITextField *)textField{
    
    if ([self.title isEqualToString:kCOUNTRY]) {
        searchArray =[[NSMutableArray alloc]initWithArray:[[UtilityPlist getData:KCountryList] valueForKey:@"countries"]];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@ ",_searchTextField.text];
        searchArray = (NSMutableArray*)[searchArray filteredArrayUsingPredicate:predicate];
        
        dataTable.hidden = YES;
        courseFilterTable.hidden = NO;
        [courseFilterTable reloadData];
    } else {
        
        if (_timer) {
            if ([_timer isValid]){ [
                                    _timer invalidate];
            }
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];
    }
}


-(void)removeSelectedData:(UIButton*)sender{
    if ([self.title isEqualToString:kCOUNTRY] ) {
        
        if (self.eventCountryFilterArray.count>0) {
            [filterArray removeObjectAtIndex:sender.tag];
            [self.eventCountryFilterArray removeObjectAtIndex:sender.tag];
            [dataTable reloadData];
        }
    }
}
- (IBAction)applyButton_clicked:(id)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountry];
    
    [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountry];
    
    [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
    [kUserDefault synchronize];
    if ([self.applyButtonDelegate respondsToSelector:@selector(checkApplyButtonAction:)]) {
        [self.applyButtonDelegate checkApplyButtonAction:1];
    }
    
    [_searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
    
}

@end
