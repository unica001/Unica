//
//  UNKAjentViewController.m
//  Unica
//
//  Created by vineet patidar on 15/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAgentViewController.h"
#import "AgentCell.h"
#import <MessageUI/MessageUI.h>
#import "UNKAgentFilterViewController.h"
#import "UNKAgentDetailsSliderViewController.h"

@interface UNKAgentViewController ()<MFMailComposeViewControllerDelegate>{
    BOOL isFromFilter;
    BOOL LoadMoreData;
    
}

@end

@implementation UNKAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Search Agents";
    LoadMoreData =true;

    // google analytics
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Agent Search"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
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
    
    _agentArray = [[NSMutableArray alloc]init];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    searchField.backgroundColor = [UIColor whiteColor];
    
    // message pop
    
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_textView.layer setMasksToBounds:YES];
    
    
    _messageUsView.layer.cornerRadius = 10;
    [_messageUsView.layer setMasksToBounds:YES];
    
    _messageView.hidden = YES;
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor blackColor];
    [self.view addSubview:messageLabel];
 
    [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSLog(@"%@",appDelegate.addressString);
    

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    [kUserDefault synchronize];
   
   

    messageLabel.hidden = YES;
   
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]
        || isFromFilter == true){
        
    isFromFilter = false;
    pageNumber = 1;
        if(pageNumber==1)
        {
            LoadMoreData =true;
        }
    [_agentTable setContentOffset:CGPointZero animated:YES];
    [self searchAgent:YES fromSearch:NO];
    }
  else {
      [_agentTable reloadData];
  }
    [self CurrentLocationIdentifier];
}
 

#pragma mark - APIS

-(void)sendMessage:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }    [dictionary setValue:[selectedDictionary valueForKey:kAgent_id] forKey:kAgent_id];
    [dictionary setValue:_textView.text forKey:kmessage];
   
   NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent_send_message.php"];
    
       [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
    
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    _textView.text = @"";
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index){
                        
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
            [Utility hideMBHUDLoader];
            
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}

-(void)searchAgent:(BOOL)showHude fromSearch:(BOOL) fromSearch{
    
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    // add filter search
    NSMutableDictionary *locationDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kselectedLocation]];

    NSString *isRemove = [kUserDefault valueForKey:kIsRemoveAll];
    
    NSString *locationID = @"";
//    if ([locationDictionary isKindOfClass:[NSMutableDictionary class]]) {
//        locationID = [locationDictionary valueForKey:kselectedLocation];
//        
//         if ([isRemove isEqualToString:@"Yes"]){
//         locationID = @"";
//        }
//    }
//    else if ([isRemove isEqualToString:@"No"]){
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        
//        if (appDelegate.addressString) {
//            locationID = appDelegate.addressString;
//        }
//    }
    if ([isRemove isEqualToString:@"Yes"]){
        locationID = @"";
    }
    else
    {
        locationID = [self setLocation];
    }

    
    
    NSLog(@"%@",self.isFilterApply);
    
    NSString *rating = @"";
    NSMutableDictionary *ratingDictionary  = [NSMutableDictionary dictionaryWithDictionary:[kUserDefault valueForKey:kfilterRating]];    if ([ratingDictionary isKindOfClass:[NSMutableDictionary class]] && [self.isFilterApply integerValue] ==1) {
         rating = [[ratingDictionary valueForKey:kfilterRating] valueForKey:kfilterRating
                   ];
    }
    
    NSMutableDictionary *serviceDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kselecteService]];
    
    NSString *serviceID = @"";
    
    if ([serviceDictionary isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableArray *serviceArray = [serviceDictionary valueForKey:kselecteService];
        
        if (serviceArray.count>0) {
            NSMutableArray *array = [serviceArray valueForKey:Kid];
            serviceID = [array componentsJoinedByString:@","];
            
        }
    }
    
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    [dictionary setValue:[NSString stringWithFormat:@"%ld",(long)[rating integerValue]] forKey:kFilter_rating];
    [dictionary setValue:locationID forKey:kFilter_location_id];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    [dictionary setValue:serviceID forKey:kfilter_serive_id];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent_search.php"];
    [dictionary setValue:_searchBar.text forKey:kkeyword];

    
    NSString *message;
   // if (loadMore == YES) {
    if(pageNumber>1){
        message = @"Finding more experts near you";
    }
    else{
        message = @"Finding International Higher Education Experts Near You.";
        

    }
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _agentTable.tableHeaderView = nil;

                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                loadMore = NO;

                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    if([[payloadDictionary valueForKey:Kagent] count]<=0)
                    {
                        LoadMoreData = false;
                    }
                    else
                    {
                        int counter = (int)([[payloadDictionary valueForKey:Kagent] count] % 10 );
                        if(counter>0)
                        {
                            LoadMoreData = false;
                        }
                    }
                    
                    if (pageNumber == 1 ) {
                        if (_agentArray) {
                            [_agentArray removeAllObjects];
                        }
                        _agentArray = [payloadDictionary valueForKey:Kagent];

                        pageNumber = pageNumber+1 ;
                    }
                    else{
                        
                        NSMutableArray *arr = [payloadDictionary valueForKey:Kagent];
                        
                        if(arr.count > 0){
                            [_agentArray addObjectsFromArray:arr];
                        }
                        NSLog(@"%lu",(unsigned long)_agentArray.count);
                        pageNumber = pageNumber+1 ;
                    }
                    
                    isLoading = NO;
                    
                    [_agentTable reloadData];
                   
                    messageLabel.text = @"";
                    [messageLabel setHidden:YES];
       
                }
                
                   else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber == 1) {
                            
                            [_agentArray removeAllObjects];
                            [_agentTable reloadData];
                            messageLabel.text = @"No records found";
                            messageLabel.hidden = NO;
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
                _agentTable.tableHeaderView = nil;

                dispatch_async(dispatch_get_main_queue(), ^{
//                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
//                        
//                    }];
                });
            }
        }
        
    }];
}

-(void)getAboutAgent:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }    [dictionary setValue:[selectedDictionary valueForKey:kAgent_id] forKey:kAgent_id];

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent_detail.php"];
    
NSString *massage = @"You can leave a review or call and message agents directly from this app.";
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:massage params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
    
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                
            if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                
                  [self performSegueWithIdentifier:kAgentDetailSegueIdentifier sender:payloadDictionary];
                    
               
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

-(void)agentLikes:(NSMutableDictionary*)selectedDictioanry index:(NSInteger)index{
    
    BOOL likeString = [[selectedDictioanry valueForKey:kIslike] boolValue];
    NSString *likeStatus;
    NSString *message;
    if (likeString == false) {
        
        likeStatus = @"true";
        message = @"Adding this to your Favourites";
    }
    else{
        message = @"Removing this from your Favourites ";
        likeStatus = @"false";
    }
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
  
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    [dictionary setValue:likeStatus forKey:kstatus];
    [dictionary setValue:[selectedDictioanry  valueForKey:kAgent_id] forKey:kAgent_id];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-like_agent.php"];
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionaryResult, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               
                
                
                if ([[dictionaryResult valueForKey:kAPICode] integerValue]== 200) {
                    pageNumber = 1;
                   // [_agentArray removeAllObjects];
                    
                    [self favReloadData:dictionary];
                    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

                     [appDelegate getFavouriteList:@"student-fav-agents.php" :kAGENT];
                    
                    [[_agentArray objectAtIndex:index] setValue:likeStatus forKey:kIslike];
                    [_agentTable reloadData];
                    
                  //  [self searchAgent:YES fromSearch:NO];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        

                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionaryResult valueForKey:kAPIMessage] block:^(int index) {
                            
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



#pragma mark - Table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_agentArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double height = 0.0;
    
    
    // address
    NSString *_address = [[_agentArray objectAtIndex:indexPath.row]valueForKey:kAddress];
    
    if ( [Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        
        height = [Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp]-20;
    }
    else {
        height = 0;
    }
    
    NSString *_consultancyName = [[_agentArray objectAtIndex:indexPath.row]valueForKey:kAgent_consultancy_name];
    
    if ( [Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth- 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium] >20) {
        
       height = ([Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20)+height;
    }
    else {
        height = 0+height;
    }
    
   return 140+height;
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
    
    static NSString *cellIdentifier  =@"agentCell";

    
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AgentCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // set consultancy name
    NSString *_consultancyName = [[_agentArray objectAtIndex:indexPath.row]valueForKey:kAgent_consultancy_name];
    
    if (![_consultancyName isKindOfClass:[NSNull class]]) {
        
        cell.nameLabelHeight.constant =[Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        
        cell.nameLabel.text = _consultancyName;
    }
    
    // address
    NSString *_address = [[_agentArray objectAtIndex:indexPath.row]valueForKey:kAddress];
    
    if (![_address isKindOfClass:[NSNull class]]) {
        
        cell.addressLabelHeight.constant =[Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForApp];
        
          cell.addressLabel.text = _address;
    }
  
    // send email
    cell.messageButton.tag = indexPath.row;
    [cell.messageButton addTarget:self action:@selector(sendEmailButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    _sendEmailButton = cell.messageButton;
    
    // call button
    cell.callButton.tag = indexPath.row;
    [cell.callButton addTarget:self action:@selector(callButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.callButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    _callButton = cell.callButton;
    
    // hide call button if string blank
      NSString *phonenumberString = [[_agentArray objectAtIndex:indexPath.row] valueForKey:kAgent_number];
    NSLog(@"%@",phonenumberString);
    
    if (!(phonenumberString.length>0) || [phonenumberString isKindOfClass:[NSNull class]]) {
        
        cell.callButton.hidden = YES;
        cell.callButtonWidth.constant = 0.0;
    }
    
    // favorite Button

    cell.favoriteButton.tag = indexPath.row;
    [cell.favoriteButton addTarget:self action:@selector(_favoriteButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    _favoriteButton = cell.callButton;
    
    if ([[[_agentArray objectAtIndex:indexPath.row]valueForKey:kIslike] boolValue] == true) {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    }
    else{
        [cell.favoriteButton setImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
    }
    
    // profile image
//    cell._profileImage.layer.cornerRadius = cell._profileImage.frame.size.width/2;
//    [cell._profileImage.layer setMasksToBounds:YES];
    
    
    NSString *imageUrl = [[_agentArray objectAtIndex:indexPath.row] valueForKey:kAgent_logo];
    
    if (![imageUrl isKindOfClass:[NSNull class]]) {
        
        [cell._profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
             
            }
            NSLog(@"%@",error);
        }];
    }

    
    // code for rating view
    
    HCSStarRatingView *_ratingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(cell.ratingView.frame.origin.x, 5, cell.ratingView.frame.size.width, cell.ratingView.frame.size.height)];
    _ratingView.userInteractionEnabled = NO;
    _ratingView.allowsHalfStars = NO;
    _ratingView.tintColor = [UIColor colorWithRed:252.0f/255.0f green:180.0f/255.0f blue:33.0f/255.0f alpha:1.0];
    _ratingView.value = [[[_agentArray objectAtIndex:indexPath.row]valueForKey:kAgent_rating]integerValue];
    _ratingView.backgroundColor = [UIColor clearColor];
    [cell.ratingBGView addSubview:_ratingView];
    
    
    // cell BG view
    
    cell.agentCellBGView.layer.cornerRadius = 3;
    [cell.agentCellBGView.layer setMasksToBounds:YES];
    
     cell.agentCellBGViewHeight.constant = 130+ ([Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForApp]-20)+([Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForApp]-20);
    if([_agentArray objectAtIndex:indexPath.row]==[_agentArray objectAtIndex:_agentArray.count-1])
    {
        if(_agentArray.count>=10)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                if(LoadMoreData == true)
                [self searchAgent:YES fromSearch:NO];
            });
        
    }
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    selectedIndex = indexPath.row;
    [self getAboutAgent:[_agentArray objectAtIndex:indexPath.row]];
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
                loadMore = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
               // _agentTable.tableFooterView = spinner;
                
               // [self searchAgent:YES fromSearch:NO];
            }
            
        }
    }
    
    else{
    
        _agentTable.tableFooterView = nil;
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
    /*if (_timer) {
        if ([_timer isValid]){ [
                                _timer invalidate];
        }
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];*/
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
    //loadMore = YES;
    pageNumber = 1;
    [_agentTable setContentOffset:CGPointZero animated:YES];
    [self searchAgent:YES fromSearch:YES];
}


-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"%@",_searchBar.text);
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    _agentTable.tableHeaderView = spinner;
    [_agentTable setContentOffset:CGPointZero animated:YES];
    if([_searchBar.text isEqualToString:@""])
    {
        
        [_agentArray removeAllObjects];
        pageNumber = 1;
        [self searchAgent:NO fromSearch:YES];
    }
    else{
        
        pageNumber = 1;
        
        [self searchAgent:NO fromSearch:YES];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kAgentFilterSegueIdentifier]) {
        UNKAgentFilterViewController *agentFilter = segue.destinationViewController;
        agentFilter.agentFilter = self;
        agentFilter.removeAllFilter = self;
        agentFilter.agentLocation = self;
        agentFilter.agentService = self;
        agentFilter.incomingViewType = Kagent;
    }
   else if ([segue.identifier isEqualToString:kAgentDetailSegueIdentifier]) {
        UNKAgentDetailsSliderViewController *agentDetailController = segue.destinationViewController;
       agentDetailController.agentDictionary = sender;
       agentDetailController.agentStaticDictionary = [_agentArray objectAtIndex:selectedIndex];
    }
    
}

#pragma mark - button delegate method

/****************************
 * Function Name : - emailButton_Clicked
 * Create on : - 28 jan 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used for send mail
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (void)sendEmailButton_Clicked:(UIButton *)sender {
    
     selectedIndex =sender.tag;
    
    _messageView.hidden = NO;
    
}

- (void)callButton_Clicked:(UIButton *)sender {
        
    NSString *phonenumberString = [[_agentArray objectAtIndex:sender.tag] valueForKey:kAgent_number];
    
    if ([phonenumberString isEqual:[NSNull class]]&& phonenumberString.length<5) {
        return;
    }
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:phonenumberString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}

- (void)_favoriteButton_Clicked:(UIButton*)sender {
    UIButton *favoriteButton = (UIButton*)sender;
    [self agentLikes:[_agentArray objectAtIndex:favoriteButton.tag] index:favoriteButton.tag];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendButton_clicked:(id)sender {
    
    if (!(_textView.text.length>0)) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please enter your message " block:^(int index){
        }];
    }
    else{
        
        _messageView.hidden = YES;
        [_textView resignFirstResponder];
        [self sendMessage:[_agentArray objectAtIndex:selectedIndex]];
        
    }


}

- (IBAction)backButton_clicked:(id)sender {
    
    // code for remove filter
    [kUserDefault removeObjectForKey:kselectedLocation];
    [kUserDefault removeObjectForKey:kfilterRating];
    [kUserDefault removeObjectForKey:kselecteService];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterButton_clicked:(id)sender {
    [_searchBar resignFirstResponder];
   [self performSegueWithIdentifier:kAgentFilterSegueIdentifier sender:nil];
}

-(void)favReloadData:(NSMutableDictionary *)dictionary
{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[dictionary valueForKey:kcourse_id]];
    
    
    
    NSArray *lastEducationCountryFilterArray = [_agentArray filteredArrayUsingPredicate:predicate];
    
    if (lastEducationCountryFilterArray.count>0) {
        NSString *status=@"0";
        if([[dictionary valueForKey:kstatus] isEqualToString:@"true"])
            status=@"1";
        [[lastEducationCountryFilterArray objectAtIndex:0] setValue:status forKey:@"is_like"];
        [_agentTable reloadData];
    }
}

- (IBAction)cancelButton_clicked:(id)sender {
    _messageView.hidden = YES;
}

#pragma  Mark - Filter delegate

-(void)agentRatingFilter:(NSString*)index{
    self.isFilterApply = index;
    isFromFilter = true;
}

-(void)agentLocationFilter:(NSString *)index{
    self.isFilterApply = index;
    isFromFilter = true;

}
-(void)agentServiceMethod:(NSString *)index{
    self.isFilterApply = index;
    isFromFilter = true;

}

-(void)removeAllFilter:(NSInteger)index{
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
    isFromFilter = true;
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];

}
#pragma mark - CLLocation Manager

/****************************
 * Function Name : - CurrentLocationIdentifier
 * Create on : - 23th Nov 2016
 * Developed By : - Ramniwas
 * Description : - This method for get user current location
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (void)CurrentLocationIdentifier {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 100;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        [locationManager requestWhenInUseAuthorization];
        
    }
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    
    
    self.lat = (double) currentLocation.coordinate.latitude;
    self.lon = (double)  currentLocation.coordinate.longitude;
    
    if (geocoder) {
        [geocoder cancelGeocode];
    }
    geocoder = [[CLGeocoder alloc] init] ;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             //             NSString *area = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
             //             NSString *nameString = [placemark.addressDictionary valueForKey:@"Name"];
             
             NSString *city = [placemark.addressDictionary objectForKey:@"City"];
             
             NSString *country = [placemark.addressDictionary objectForKey:@"Country"];
             
             NSString *address = [NSString stringWithFormat:@"%@",city];
             
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             appDelegate.addressString = address;
             
         }
         else{
             NSLog(@"Geocode failed with error %@", error);
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             appDelegate.addressString = @"";
         }
     }];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSString * message=nil;
    switch (status) {
            
        case kCLAuthorizationStatusRestricted:
            message=@"Location services are required for this app, please authorize this application to use location service. Please tap on setting to enable location services!";
            
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            message=@"Location services are required for this app, please authorize this application to use location service. Please tlease tap on setting to enable location services!";
            
            break;
        case kCLAuthorizationStatusDenied:
            message=@"Location services are off. Please tap on setting to enable location services!";
            
            
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            
            break;
            
            
        default:
            
            
            break;
    }
    
    
    
    //    if (message) {
    //         [Utils showAlertViewControllerIn:self.window.rootViewController title:@"PupSmooch" message:message  block:^(int sum) {
    //
    //
    //         }];
    //   }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.lat = 0;
    self.lon = 0;
    // NSLog(@"location off");
    NSString *message=nil;
    if ([error domain] == kCLErrorDomain)
    {
        switch ([error code]){
            case kCLErrorDenied:
                
                break;
                
            default:
                message=@"No GPS coordinates are available. Please take the device outside to an open area.";
                break;
        }
    }
    
    [self CurrentLocationIdentifier];
    
    
}
-(NSString*)setLocation
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSString *retLocation;
    
    NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectedLocation]];
    
    if (dict.count>0 && ![dict isKindOfClass:[NSNull class]]) {
        retLocation = [dict valueForKey:kselectedLocation];
    }
    else if (([[Utility replaceNULL:appDelegate.addressString value:@""]length]>0)) {
        retLocation = appDelegate.addressString;
    }
    
    else{
        
        
        if ([dictLogin valueForKey:kresidential_city]) {
            
            retLocation = [dictLogin valueForKey:kresidential_city];
        }
        
        else{
            retLocation = appDelegate.addressString;
        }
        
    }
    return retLocation;
}
@end

