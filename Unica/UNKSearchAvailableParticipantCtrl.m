//
//  UNKSearchAvailableParticipantCtrl.m
//  Unica
//
//  Created by Ram Niwas on 16/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKSearchAvailableParticipantCtrl.h"
#import "MeetingReportParticipantCell.h"

@interface UNKSearchAvailableParticipantCtrl() <delegateAgentService, delegateEvent, delegateForCheckApply, delegateRemoveAllFilter>{
    BOOL LoadMoreData;
    AppDelegate *appDelegate;
    BOOL isFromFilter;
    NSString *countryIDsString;
    NSString *typeIDsString;
    
    NSTimer *_timer;

}

@end

@implementation UNKSearchAvailableParticipantCtrl


- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UITextField *searchfield = [searchBar valueForKey:@"_searchField"];
    searchfield.textColor = [UIColor whiteColor];
    searchfield.backgroundColor = [UIColor whiteColor];
    [tableView registerNib:[UINib nibWithNibName:@"MeetingReportParticipantCell" bundle:nil] forCellReuseIdentifier:@"MeetingReportParticipantCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    pageNumber = 1;
    _isFilterApply = @"1";
    NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountryAvailable]];
    if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountryAvailable] isKindOfClass:[NSMutableArray class]]) {
        self.countryFilter = [dict valueForKey:kselectCountryAvailable];
    } else {
        [self.countryFilter removeAllObjects];
    }
    if (self.countryFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *countyArray = [self.countryFilter valueForKey:Kid];
        countryIDsString = [countyArray componentsJoinedByString:@","];
    } else {
        countryIDsString = @"";
    }
    NSMutableDictionary *dictType = [Utility unarchiveData:[kUserDefault valueForKey:kselectTypeAvailable]];
    if ([dictType isKindOfClass:[NSMutableDictionary class]] && [[dictType valueForKey:kselectTypeAvailable] isKindOfClass:[NSMutableArray class]]) {
        self.typeFilter = [dictType valueForKey:kselectTypeAvailable];
    } else {
        [self.typeFilter removeAllObjects];
    }
    if (self.typeFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *typeArray = [self.typeFilter valueForKey:@"filterId"];
        typeIDsString = [typeArray componentsJoinedByString:@","];
    } else {
        typeIDsString = @"";
    }
    
    NSLog(@"Country id %@, type Id %@", countryIDsString, typeIDsString);
     [self participantsList:YES searchText:searchBar.text];
}


#pragma mark - IBAction Methods
- (IBAction)tapBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Filter delegate

-(void)checkApplyButtonAction:(NSInteger)index{
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
    isFromFilter = true;
}

-(void)removeAllFilter:(NSInteger)index{
    isFromFilter = true;
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
}

-(void)agentServiceMethod:(NSString *)index{
    self.isFilterApply = index;
    isFromFilter = true;
}

- (void)eventMethod:(NSString *)index {
    self.isFilterApply = index;
    isFromFilter = true;
}

#pragma mark UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrParticipant.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 171;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"MeetingReportParticipantCell";
    
    MeetingReportParticipantCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MeetingReportParticipantCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kDefaultBlueColor;
    cell.btnRecordExp.tag = indexPath.row;
    [cell setParticipant:arrParticipant[indexPath.row] isFromRecordExpression:YES];
    [cell.btnRecordExp addTarget:self action:@selector(sendRequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - SearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    pageNumber = 1;
    [searchBar resignFirstResponder];
    [self participantsList:false searchText:searchBar.text];
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

-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    
    pageNumber = 1;
    [tableView setContentOffset:CGPointZero animated:YES];
    [self participantsList:YES searchText:searchBar.text];
}

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
        
        float reload_distance = 0;
        if(y > h + reload_distance) {
            if ([arrParticipant count] % 10 == 0) {
                isLoading = YES;
                [self participantsList:false searchText:searchBar.text];
            }
        }
    } else{
        tableView.tableFooterView = nil;
    }
}


#pragma Button Action


- (IBAction)filterButtonAction:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
    UNKFilterViewC *filterViewC = [sb instantiateViewControllerWithIdentifier:@"UNKFilterViewC"];
    filterViewC.incomingViewType = kSearchAvailableFilter;
    filterViewC.removeAllFilter = self;
    filterViewC.applyButtonDelegate = self;
    filterViewC.agentService = self;
    [self.navigationController pushViewController:filterViewC animated:YES];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)sendRequestButtonAction:(UIButton*)sender{
    NSDictionary *dict = [arrParticipant objectAtIndex:sender.tag];
    [self sendParticipantRequest:dict[@"participantId"]];
    
}

#pragma mark - APIS


-(void)sendParticipantRequest:(NSString*)participantId{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:participantId forKey:@"participantId"];
    [dic setValue:appDelegate.userEventId forKey:kevent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-send-request.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        [self participantsList:false searchText:searchBar.text];
                        
                    }];
                }
            });
        }
    }];
}
-(void)participantsList:(BOOL)showHude searchText:(NSString*)searchText{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        NSString *userId = [dictLogin valueForKey:Kid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [dictionary setValue:userId forKey:kUser_id];
    }
    else{
        NSString *userId =[dictLogin valueForKey:Kuserid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [dictionary setValue:userId forKey:kUser_id];
    }
    
    [dictionary setValue:[dictLogin valueForKey:@"user_type"] forKey:@"user_type"];
    [dictionary setValue:appDelegate.userEventId forKey:kevent_id];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
    [dictionary setValue:searchText forKey:ksearchText];
    [dictionary setValue:self.selectedSlotID forKey:kslotId];
    [dictionary setValue:countryIDsString forKey:@"countryId"];
    [dictionary setValue:typeIDsString forKey:@"filterType"];
    
   NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-available-participants.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:false completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isLoading = NO;
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    int counter = (int)([[payloadDictionary valueForKey:@"participant"] count] % 10 );
                    if(counter>0)
                    {
                        LoadMoreData = false;
                    }
                    
                    if (pageNumber == 1 ) {
                        if (arrParticipant) {
                            [arrParticipant removeAllObjects];
                        }
                        arrParticipant = [payloadDictionary valueForKey:@"participant"];
                        pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:@"participant"];
                        if(arr.count > 0){
                            
                            [arrParticipant addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:arrParticipant] array];
                            arrParticipant =[[NSMutableArray alloc] initWithArray:newArray];
                        }
                        NSLog(@"%lu",(unsigned long)arrParticipant.count);
                        pageNumber = pageNumber+1 ;
                    }
                    [tableView reloadData];
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber ==1) {
                            [arrParticipant removeAllObjects];
                            [tableView reloadData];
   
                        }
                        else{
                            LoadMoreData = false;
                        }
                    });
                }
                
                isLoading = NO;
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (pageNumber ==1) {
                        [arrParticipant removeAllObjects];
                        [tableView reloadData];
                
                        messageLabel.text = @"No records found";
                        messageLabel.hidden = NO;
                    }
                    else{
                        messageLabel.text = @"";
                        messageLabel.hidden = YES;
                        
                    }
                    
                });
            }
        }
        
    }];
}


@end
