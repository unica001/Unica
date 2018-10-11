//
//  UNKEventViewController.m
//  Unica
//
//  Created by ramniwas on 02/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKEventViewController.h"
#import "UNKEventDetailsViewController.h"
#import "EventCell.h"

@interface UNKEventViewController (){
    NSMutableDictionary *dictLogin;
    BOOL isShowHude;
    
    BOOL isFromFilter;
    BOOL LoadMoreData;

}

@end

@implementation UNKEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Search Events";
    LoadMoreData = true;
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.hidden  = YES;

    messageLabel.textColor = [UIColor blackColor];
    [self.view addSubview:messageLabel];
    
    isShowHude = YES;
    if ([self.incomingViewType isEqualToString:kHomeView]) {
        [_backButton setImage:[UIImage imageNamed:@"BackButton"]];
    }
    else{
        
        // SWReveal delegates
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {  SWRevealViewController *revealViewController = self.revealViewController;
            if ( revealViewController )
            {
                [_backButton setTarget: self.revealViewController];
                [_backButton setAction: @selector( revealToggle: )];
                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            }
            
        }
        self.revealViewController.delegate = self;
    }
    
    _eventArray = [[NSMutableArray alloc]init];
    
    // search bar text field
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    searchField.backgroundColor = [UIColor whiteColor];
    
    self.eventCountryFilterArray = [[NSMutableArray alloc]init];
    self.eventCityFilterArray = [[NSMutableArray alloc]init];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]
        || isFromFilter == true){
   
        isFromFilter = false;
        LoadMoreData =true;
        [_eventTable setContentOffset:CGPointZero animated:YES];

       
        dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        
        if ([self.incomingViewType isEqualToString:kNotifications]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:self.eventId forKey:kevent_id];
            [self performSegueWithIdentifier:keventDetailSegueIdentifier sender:dict];
            self.incomingViewType = @"";
            
        }
        else{
            [self loadEventList];
            
        }
    }
    
    else{
    
        [_eventTable reloadData];
    }
    }



-(void)loadEventList{
    NSLog(@"%@",self.eventCountryFilterArray);
    
    pageNumber = 1;
    
    _cityFilterIDs = @"";
    
    NSLog(@"%@",self.isFilterApply);
    if (self.eventCityFilterArray.count>0 && [self.isFilterApply integerValue] ==1) {
        //        NSArray *institudeIDs = [self.eventCityFilterArray valueForKey:Kid];
        NSData* data = [ NSJSONSerialization dataWithJSONObject:[self.eventCityFilterArray valueForKey:Kid]  options:NSJSONWritingPrettyPrinted error:nil ];
        _cityFilterIDs = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    _countyFilterIDs = @"";
    if (self.eventCountryFilterArray.count>0 && [self.isFilterApply integerValue] ==1) {
        
        NSData* data = [ NSJSONSerialization dataWithJSONObject:[self.eventCountryFilterArray valueForKey:Kid]  options:NSJSONWritingPrettyPrinted error:nil ];
        _countyFilterIDs = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    if([[kUserDefault valueForKey:@"showHudEventDetail"] isEqualToString:@"yes"])
    {
        [kUserDefault removeObjectForKey:@"showHudEventDetail"];
        isShowHude=NO;
    }
    else
    {
        isShowHude=YES;
    }

    
    [self getEvents:isShowHude];
}
#pragma mark - APIS

-(void)getEvents:(BOOL)showHude{

    
 NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:_countyFilterIDs forKey:kParticipate_country_id];
    [dictionary setValue:_searchBar.text forKey:ksearch];
    [dictionary setValue:[NSString stringWithFormat:@"%@",_cityFilterIDs] forKey:kcity];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"events.php"];
    
    NSString *message =@"Finding Higher Education Events Near You ";
    if(pageNumber==1)
    {
        message =@"Finding Higher Education Events Near You";
    }
    else
    {
        message =@"Finding more events near you";
    }
    
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                isShowHude = false;
                
                _eventTable.tableHeaderView = nil;
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isLoading = NO;

                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    int counter = (int)([[payloadDictionary valueForKey:kevents] count] % 10 );
                    if(counter>0)
                    {
                        LoadMoreData = false;
                    }
                    messageLabel.text = @"";
                    [messageLabel setHighlighted:YES];
                    
                    if (pageNumber == 1 ) {
                        if (_eventArray) {
                            [_eventArray removeAllObjects];
                        }
                        _eventArray = [payloadDictionary valueForKey:kevents];
                        
                        pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:kevents];
                        
                        
                        if(arr.count > 0){
                            [_eventArray addObjectsFromArray:arr];
                        }
                        NSLog(@"%lu",(unsigned long)_eventArray.count);
                        pageNumber = pageNumber+1 ;
                    }
                    
                    [_eventTable reloadData];
                  
                    
                
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber == 1) {
                            
                           
                            messageLabel.text = @"No records found";
                            messageLabel.hidden = NO;
                            
                            [_eventArray removeAllObjects];
                            [_eventTable reloadData];
                        }
                        else
                        {
                            LoadMoreData = false;
                        }
                        
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_searchBar resignFirstResponder];

                    if (_eventArray) {
                        [_eventArray removeAllObjects];
                        [_eventTable reloadData];
                    }  _eventTable.tableHeaderView = nil;
                    
                    messageLabel.text = @"";
                    [messageLabel setHighlighted:YES];
                    
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}


#pragma mark - Table view delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return [_eventArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double height = 0.0;
    
    // Title
    NSString *titleString = [[_eventArray objectAtIndex:indexPath.section]valueForKey:kevent_name];
    
    if ( [Utility getTextHeight:titleString size:CGSizeMake(kiPhoneWidth-110, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        height =[Utility getTextHeight:titleString size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20;}
    else{
        height = 10;
        
    }
    
    //Address
    NSString*addressString = [[_eventArray objectAtIndex:indexPath.section]valueForKey:kevent_location];
    

    if ( [Utility getTextHeight:addressString size:CGSizeMake(kiPhoneWidth-130, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        height =([Utility getTextHeight:addressString size:CGSizeMake(kiPhoneWidth - 130, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20)+height;
    }
    else{
        height = height+0;
    }

    return 120+height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
    footerView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1];
    
    return footerView;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"eventCell";
    
    
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"EventCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *eventName = [[_eventArray objectAtIndex:indexPath.section]valueForKey:kevent_name];
    
    
    // eventName
    if (![eventName isKindOfClass:[NSNull class]]) {
        eventName = [eventName stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        cell.titleHeight.constant = [Utility getTextHeight:eventName size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        
        
        cell.titleLabel.text = eventName;
    }
    // date
    
    cell.dateLabel.text = [[_eventArray objectAtIndex:indexPath.section]valueForKey:kevent_date];
    
    //Address

    NSString *address = [[_eventArray objectAtIndex:indexPath.section]valueForKey:kevent_location];
    
    if (![address isKindOfClass:[NSNull class]]) {
        cell.addressHeight.constant =[Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth - 130, CGFLOAT_MAX) font:kDefaultFontForTextField];
        cell.addressLabel.text = address;
    }
    
    // evemt image
    
    NSString *urlString = [[_eventArray objectAtIndex:indexPath.section]valueForKey:kevent_image];
    
    if (![urlString isKindOfClass:[NSNull class]]) {
            [cell._imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    
                }
                NSLog(@"%@",error);
            }];
    }
    
    
    // image view
    cell.eventBackGroundView.layer.cornerRadius = 5;
    [cell.eventBackGroundView.layer setMasksToBounds:YES];
    
    NSString *isRegister = [[_eventArray objectAtIndex:indexPath.section]valueForKey:@"isRegistered"];
    
    if ([isRegister boolValue]  == true) {
        [cell.registerButton setBackgroundColor:[UIColor grayColor]];
        cell.registerButton.userInteractionEnabled = YES;
        [cell.registerButton setTitle:@"Registered" forState:UIControlStateNormal];
    }
    else{
    
   
        cell.registerButton.userInteractionEnabled = YES;
    }
     [cell.registerButton addTarget:self action:@selector(registerButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if([_eventArray objectAtIndex:indexPath.section]==[_eventArray objectAtIndex:_eventArray.count-1])
    {
        if(_eventArray.count>=10 && LoadMoreData==true)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self getEvents:YES];
            });
        
    }
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:keventDetailSegueIdentifier sender:[_eventArray objectAtIndex:indexPath.section]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        float reload_distance = 10;
        if(y > h + reload_distance) {
            NSLog(@"End Scroll %f",y);
            if (pageNumber != totalRecord) {
                NSLog(@"Call API for pagging from %d for total pages %d",pageNumber,totalRecord);
                isLoading = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
               // _eventTable.tableFooterView = spinner;
                
                //[self getEvents:YES];
            }
            
        }
    }
    
    else{
        
        _eventTable.tableFooterView = nil;
    }
}


#pragma  mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    _eventTable.tableHeaderView = spinner;
    
    pageNumber = 1;
    [_eventTable setContentOffset:CGPointZero animated:YES];
    if([_searchBar.text isEqualToString:@""])
    {
        
        [self getEvents:NO];
    }
    else{
        
        [self getEvents:NO];
        
    }

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   /* if (_timer) {
        if ([_timer isValid]){ [
            _timer invalidate];
        }
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];*/
    
}

-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"%@",_searchBar.text);
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    _eventTable.tableHeaderView = spinner;
    
    pageNumber = 1;

    if([_searchBar.text isEqualToString:@""])
    {
        
        [self getEvents:NO];
    }
    else{
        
        [self getEvents:NO];
        
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
   if ([segue.identifier isEqualToString:keventDetailSegueIdentifier]) {
        UNKEventDetailsViewController *eventDetailViewController = segue.destinationViewController;
       
//       if ([self.incomingViewType isEqualToString:kNotifications]) {
//           eventDetailViewController.incomingViewType = self.incomingViewType;
//       }
        eventDetailViewController.evenDictionary = sender;
        
    }
    else if ([segue.identifier isEqualToString:kAgentFilterSegueIdentifier]) {
        UNKAgentFilterViewController *agentFilter = segue.destinationViewController;
        agentFilter.incomingViewType = KEvent;
        agentFilter.eventCountryFilterArray = self.eventCountryFilterArray;
        agentFilter.eventCityFilterArray = self.eventCityFilterArray;
        agentFilter.removeAllFilter = self;
        agentFilter.applyButtonDelegate = self;
    }
   
}

#pragma mark - button delegate method

- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterButton_clicked:(id)sender {
    [self performSegueWithIdentifier:kAgentFilterSegueIdentifier sender:nil];
}

-(void)registerButton_clicked:(UIButton *)sender{
    
    CGPoint point = [sender convertPoint:CGPointZero toView:_eventTable];
    NSIndexPath *indexPath = [_eventTable indexPathForRowAtPoint:point];
    NSMutableDictionary *dict = [_eventArray objectAtIndex:indexPath.section];
    
    NSString *isRegister = [[_eventArray objectAtIndex:indexPath.section]valueForKey:@"isRegistered"];
    
    if ([isRegister boolValue]  == true) {
        
        [Utility showAlertViewControllerIn:self title:@"" message:@"Already Registered." block:^(int index){
        
        }];
    
    }else{
        
        [Utility showAlertViewControllerIn:self withAction:@"CANCEL" actionTwo:@"YES" title:@"" message:@"Are you sure, You want to register for this event" block:^(int index){
            
            if (index == 1) {
                [self registredAPIS:YES eventID:[dict valueForKey:kevent_id] path:indexPath];
               // [self registredAPIS:YES eventID:[dict valueForKey:kevent_id] index:indexPath];
            }
        }];
    }
   
}


-(void)registredAPIS:(BOOL)showHude eventID:(NSString*)eventID path:(NSIndexPath*)indexPath{
    

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    
    [dictionary setValue:eventID forKey:kevent_id];
    
    NSString *message = @"Registering for this event";
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-event-register.php"];
    
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _eventTable.tableHeaderView = nil;
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:@"Registered Successfully, your details have been shared with the Organiser." block:^(int index) {
                       // [[_eventArray objectAtIndex:indexPath.section]valueForKey:@"isRegistered"]
                        [[_eventArray objectAtIndex:indexPath.section] setValue:@"1" forKey:@"isRegistered"];
                        [_eventTable reloadData];
                       // [self loadEventList];
                    }];
        
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


#pragma  Mark - Filter delegate

-(void)checkApplyButtonAction:(NSInteger)index{
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
    
    isFromFilter = true;
}

-(void)removeAllFilter:(NSInteger)index{
    
    isFromFilter = true;
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];


    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
}

@end
