

#import "MyScheduleViewController.h"

@interface MyScheduleViewController() <delegateAgentService, delegateEvent, delegateForCheckApply, delegateRemoveAllFilter>{
    
    NSMutableArray *myScheduleArray;
    AppDelegate *appDelegate;
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    BOOL isHude;
    BOOL isFromFilter;
    
    NSString *countryIDsString;
    NSString *typeIDsString;
}

@end

@implementation MyScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    searchField.backgroundColor = [UIColor whiteColor];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [menuButton setTarget: self.revealViewController];
            [menuButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    }
    self.revealViewController.delegate = self;
    _countryFilter = [[NSMutableArray alloc] init];
    _typeFilter = [[NSMutableArray alloc] init];
    self.isFilterApply = @"1";
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    pageNumber  = 1;
    isHude = YES;
    
    NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountrySchedule]];
    if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountrySchedule] isKindOfClass:[NSMutableArray class]]) {
        self.countryFilter = [dict valueForKey:kselectCountrySchedule];
    } else {
        [self.countryFilter removeAllObjects];
    }
    if (self.countryFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *countyArray = [self.countryFilter valueForKey:Kid];
        countryIDsString = [countyArray componentsJoinedByString:@","];
    } else {
        countryIDsString = @"";
    }
    NSMutableDictionary *dictType = [Utility unarchiveData:[kUserDefault valueForKey:kselectTypeSchedule]];
    if ([dictType isKindOfClass:[NSMutableDictionary class]] && [[dictType valueForKey:kselectTypeSchedule] isKindOfClass:[NSMutableArray class]]) {
        self.typeFilter = [dictType valueForKey:kselectTypeSchedule];
    } else {
        [self.typeFilter removeAllObjects];
    }
    if (self.typeFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *typeArray = [self.typeFilter valueForKey:@"filterId"];
        typeIDsString = [typeArray componentsJoinedByString:@","];
    } else {
        typeIDsString = @"";
    }
    
//    NSMutableDictionary *dictevent = [Utility unarchiveData:[kUserDefault valueForKey:kselectEvent]];
//    if ([dictevent isKindOfClass:[NSMutableDictionary class]] && [[dictevent valueForKey:kselectEvent] isKindOfClass:[NSMutableArray class]]) {
//        self.eventFilter = [dictevent valueForKey:kselectEvent];
//    } else {
//        [self.eventFilter removeAllObjects];
//    }
//    if (self.eventFilter.count>0 && [self.isFilterApply integerValue] == 1) {
//        NSArray *eventArray = [self.eventFilter valueForKey:Kid];
//        eventIDsString = [eventArray componentsJoinedByString:@","];
//    } else {
//        eventIDsString = @"";
//    }
    NSLog(@"Country id %@, type Id %@", countryIDsString, typeIDsString);
    [self getScheduleList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return myScheduleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"MyScheduleCell";
    MyScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MyScheduleCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.button1.tag  = indexPath.row;
    cell.button2.tag = indexPath.row;
    
    [cell setMyScheduleData:myScheduleArray[indexPath.row]];
    
    [cell.button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

// Button Action

-(void)button1Action:(UIButton *)sender{
    NSMutableDictionary *dict = myScheduleArray[sender.tag][kbuttons][0];
    
    NSMutableDictionary *mainDict = myScheduleArray[sender.tag];

    
    if ([dict[kpark_free] integerValue] == 1 ) { // Park Free
        [self parkFreeRequest:mainDict index:sender.tag];
        
    }
    else if ([dict[@"search_people"] integerValue] == 1 ) { //search_people
        
    }
    else if ([dict[@"search_people"] integerValue] > 0 ) { // record expression
        
    }
}
-(void)button2Action:(UIButton *)sender{
    
}
- (IBAction)filterButtonAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
    UNKFilterViewC *filterViewC = [sb instantiateViewControllerWithIdentifier:@"UNKFilterViewC"];
    filterViewC.incomingViewType = kScheduleFilter;
    filterViewC.removeAllFilter = self;
    filterViewC.applyButtonDelegate = self;
    filterViewC.agentService = self;
    [self.navigationController pushViewController:filterViewC animated:YES];
}

- (IBAction)menuButtonAction:(id)sender {
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

#pragma  mark - Search bar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    isHude = true;
    pageNumber = 1;
    [tableView setContentOffset:CGPointZero animated:YES];
    [self getScheduleList];
}


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
            if (pageNumber != totalRecord) {
                isLoading = YES;
                isHude=false;
                [self getScheduleList];
            }
        }
    } else{
        tableView.tableFooterView = nil;
    }
}

#pragma mark - APIS

-(void)getScheduleList{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:appDelegate.userEventId forKey:kevent_id];
    [dic setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-schedule-lists.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dic  timeoutInterval:kAPIResponseTimeout showHUD:isHude showSystemError:isHude completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                isHude = NO;
                isLoading = NO;
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    if (pageNumber == 1 ) {
                        if (myScheduleArray) {
                            [myScheduleArray removeAllObjects];
                        }
                        myScheduleArray = dictionary[kAPIPayload][@"schedules"];
                        if(myScheduleArray.count==10){
                            pageNumber = 2;
                        }
                    }
                    else{
                        NSMutableArray *arr = dictionary[kAPIPayload][@"schedules"];
                        if(arr.count > 0){
                            [myScheduleArray addObjectsFromArray:arr];
                        }
                        pageNumber = pageNumber+1 ;
                    }
                    [tableView reloadData];
                }
                isLoading = NO;
                
                if (myScheduleArray.count == 0) {
                    noRecordLabel.hidden = false;
                }
                else {
                    noRecordLabel.hidden = true;
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


-(void)parkFreeRequest:(NSDictionary*)maindict index:(NSInteger)index{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:maindict[kslotId] forKey:kslotId];
    [dic setValue:appDelegate.userEventId forKey:kevent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-park-free-slot.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        
                        NSMutableDictionary *dict = maindict[kbuttons][0];
                        [dict setValue:@"0" forKey:kstatus];
                        [dict setValue:@"0" forKey:kType];
                        [dict setValue:@"0" forKey:kpark_free];
                         [dict setValue:@"Slot is Parket as FREE TIME" forKey:kName];
                        
                        [maindict[kbuttons] removeObjectAtIndex:0];
                        [maindict[kbuttons] addObject:dict];
                        
                        [myScheduleArray removeObjectAtIndex:index];
                        [myScheduleArray insertObject:maindict atIndex:index];
                        [tableView reloadData];

                    }];
                }
            });
        }
    }];
}

@end
