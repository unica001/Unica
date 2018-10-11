//
//  UNKPredictiveSearchViewController.m
//  Unica
//
//  Created by vineet patidar on 11/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKPredictiveSearchViewController.h"

@interface UNKPredictiveSearchViewController ()

@end

@implementation UNKPredictiveSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.incomingViewType isEqualToString: kMPStep2]) {
        self.navigationItem.title = @"Search Category";
    }
    else if ([self.incomingViewType isEqualToString:kStep1NativeLanguage]){
    self.navigationItem.title = @"Search Native Language";
    }
    else{
        self.navigationItem.title = @"Search Country";
    }
    
    self.navigationController.navigationBarHidden = NO;
    
    searchArray = [[NSMutableArray alloc]init];
    
    if ([self.incomingViewType isEqualToString:kStep1NativeLanguage]) {
        searchArray =[[UtilityPlist getData:klanguage_list] valueForKey:@"languages"];
        [_searchTable reloadData];
    }else{
        [self getSearchData:nil];
    }
    
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header"] forBarMetrics:UIBarMetricsDefault];}


#pragma mark - APIS
/****************************
 * Function Name : - getSearchData
 * Create on : - 14 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for move in previous screen
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getSearchData:(NSMutableDictionary*)dataDictionary{
    
    if ([self.incomingViewType isEqualToString:kStep1NativeLanguage]){
    
        _searchTable.tableHeaderView = nil;
        _searchBar.placeholder = @"Search Native Language";
        

         searchArray =[[UtilityPlist getData:klanguage_list] valueForKey:@"languages"];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"language_name BEGINSWITH[c] %@ ",_searchBar.text];
        searchArray = (NSMutableArray*)[searchArray filteredArrayUsingPredicate:predicate];
        
        [_searchTable reloadData];


    }else{
    
        if([Utility connectedToInternet])
        {
            NSString *url;
            
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
            
            
            if ([self.incomingViewType isEqualToString: kMPStep2]) {
                
                _searchBar.placeholder = @"Search Category";
                
                [dictionary setValue:_searchBar.text forKey:ksearch_subcategory];
                [dictionary setValue:@"" forKey:kPageNumber];
                
                url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"subcategory_search.php"];
            }
            else{
                _searchBar.placeholder = @"Search Country";
                
                [dictionary setValue:_searchBar.text forKey:kSearch_country];
                [dictionary setValue:@"1" forKey:kPageNumber];
                
                url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"country_search.php"];
            }
            
            [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
                
                if (!error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        _searchTable.tableHeaderView = nil;
                        _searchTable.tableFooterView = nil;
                        
                        
                        NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                        
                        if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                            
                            if ([self.incomingViewType isEqualToString: kMPStep2]) {
                                searchArray = [payloadDictionary valueForKey:@"course_sub_cat"];
                                
                            }
                            else {
                                searchArray = [payloadDictionary valueForKey:@"countries"];
                                
                            }
                            [_searchTable reloadData];
                            
                            
                        }else{
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                _searchTable.tableHeaderView = nil;
                                _searchTable.tableFooterView = nil;
                                
                                
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
                            _searchTable.tableFooterView = nil;
                            _searchTable.tableHeaderView = nil;
                            
                            
                            [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                                
                            }];
                        });
                    }
                    
                }
                
                
            }];
        }
        else{
            [self BindCountryData];
        }
    }
   

  
    
}


#pragma  mark - Table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [searchArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placesCell"];
    
    if ([self.incomingViewType isEqualToString:kStep1NativeLanguage]) {
        if ([searchArray count]>0) {
            cell.textLabel.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:klanguage_name];
            _searchBar.placeholder = @"Search Native Language";

        }
    }
    else{
        if ([searchArray count]>0) {
            cell.textLabel.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:kName];
        }
    }
    
 
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(getSearchData:type:)]) {
        [self.delegate getSearchData:[searchArray objectAtIndex:indexPath.row] type:self.incomingViewType];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma  mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (_timer) {
        if ([_timer isValid]){ [
                                _timer invalidate];
        }
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"%@",_searchBar.text);
    
    if([_searchBar.text isEqualToString:@""] && [Utility connectedToInternet])
    {
        
        //[searchArray removeAllObjects];
        searchArray= [[NSMutableArray alloc] init];
        [_searchTable reloadData];
    }
    else{
        
        UIActivityIndicatorView *spinnerHeader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinnerHeader startAnimating];
        spinnerHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        _searchTable.tableHeaderView = spinnerHeader;
        
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        _searchTable.tableFooterView = spinner;
        
        [self getSearchData:nil];
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

- (IBAction)doneButton_Clicked:(id)sender {
    
    if (self.locationDict.count >0) {
        
        NSString *address = @"";
        
        if (!(_searchAddress.length > 0)) {
            
            _searchAddress = address;
        }
        
        [self.locationDict setValue:_searchAddress forKey:@""];
        
        if ([self.delegate respondsToSelector:@selector(getSearchData:)]) {
            [self.delegate getSearchData:self.locationDict type:self.incomingViewType];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    else {
        
        [Utility showAlertViewControllerIn:self title:@"Location" message:@"Please select address" block:^(int index) {
            
        }];
        
    }
    
}

- (IBAction)backButton_Clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)BindCountryData
{
    
    _searchTable.tableHeaderView = nil;
    _searchTable.tableFooterView = nil;
    
    if(_searchBar.text.length ==0)
    {
        searchArray =[[NSMutableArray alloc]initWithArray:[[UtilityPlist getData:KCountryList] valueForKey:@"countries"]];
    }
    else
    {
        searchArray =[[NSMutableArray alloc]initWithArray:[[UtilityPlist getData:KCountryList] valueForKey:@"countries"]];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@ ",_searchBar.text];
        searchArray = (NSMutableArray*)[searchArray filteredArrayUsingPredicate:predicate];
    }
    [_searchTable reloadData];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
