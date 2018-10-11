//
//  UNKCourseViewController.m
//  Unica
//
//  Created by vineet patidar on 28/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKCourseViewController.h"
#import "UNKAgentFilterViewController.h"
#import "CourseCell.h"
#import "UNKCourseDetailsViewController.h"
#import "UNKInstitudeViewController.h"
#import "UNKWebViewController.h"
#import "GlobalApplicationStep1ViewController.h"

@interface UNKCourseViewController (){
    NSString *institudeIDsString;
    NSString *countryIDsString;
    NSString *scholarshipString;
    NSString *perfectMatchString;
    
    NSString *unica_fee;
    NSInteger applied_count,apply_limit;
    BOOL feePaidStatus;
    
    BOOL isFromFilter;
    BOOL LoadMoreData;
    
}

@end

@implementation UNKCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [kUserDefault setValue:@"No" forKey:kisGlobalFormCompleted];
    self.navigationItem.title = @"Search Courses";
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.hidden  = YES;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:messageLabel];
    
    
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
    
    _courseArray = [[NSMutableArray alloc]init];
    
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    searchField.backgroundColor = [UIColor whiteColor];
    
    
    self.institutionFilter = [[NSMutableArray alloc]init];
    self.countryFilter = [[NSMutableArray alloc]init];
    self.scholarShipFilter = [[NSMutableArray alloc]init];
    self.perfectFilter = [[NSMutableArray alloc]init];
    
    
    self.isFilterApply = @"0";
    LoadMoreData=true;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    if([kUserDefault valueForKey:@"searchCourese"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *CourseDic =[[NSMutableDictionary alloc] init];
            CourseDic = [kUserDefault valueForKey:@"searchCourese"];
            [kUserDefault removeObjectForKey:@"searchCourese"];
            [self ApplyFunction:CourseDic];
        });
       
    }
    else
    {
        isInfoClicked = NO;
        self.navigationController.navigationBarHidden= NO;
        
        [super viewWillDisappear:animated];
        
        if ([self isMovingFromParentViewController]
            || isFromFilter == true)
        {
            
            isFromFilter = false;
            countryIDsString = @"";
            institudeIDsString = @"";
            scholarshipString = @"";
            perfectMatchString = @"";
            
            pageNumber = 1;
            [_courseTable setContentOffset:CGPointZero animated:YES];
            
            
            NSLog(@"%@",self.isFilterApply);
            if([self.isFilterApply integerValue] == 1)
            {
                LoadMoreData = true;
            }
            if (self.institutionFilter.count>0 && [self.isFilterApply integerValue] == 1) {
                
                NSArray *institudeArray = [self.institutionFilter valueForKey:Kid];
                institudeIDsString = [institudeArray componentsJoinedByString:@","];
            }
            
            if (self.countryFilter.count>0 && [self.isFilterApply integerValue] == 1) {
                NSArray *countyArray = [self.countryFilter valueForKey:Kid];
                countryIDsString = [countyArray componentsJoinedByString:@","];
            }
            
            if (self.scholarShipFilter.count>0 && [self.isFilterApply integerValue] == 1) {
                NSString *strFilter = [self.scholarShipFilter objectAtIndex:0];
                if ([strFilter isEqualToString:@"All"]) {
                    scholarshipString = @"0";
                }
                else{
                    scholarshipString = @"1";
                    
                }
            }
            
            
            if (self.perfectFilter.count>0 && [self.isFilterApply integerValue] == 1) {
                NSString *strFilter = [self.perfectFilter objectAtIndex:0];
                if ([strFilter isEqualToString:@"All"]) {
                    perfectMatchString = @"0";
                }
                else{
                    perfectMatchString = @"1";
                    
                }
            }
            
            NSLog(@"%@",self.institutionFilter);
            NSLog(@"%@",self.countryFilter);
            NSLog(@"%@",self.scholarShipFilter);
            NSLog(@"%@",self.perfectFilter);
            
            
            if([[kUserDefault valueForKey:@"showHudCousrseDetail"] isEqualToString:@"yes"])
            {
                [kUserDefault removeObjectForKey:@"showHudCousrseDetail"];
                [self searchCourse:NO];
            }
            else
            {
                [self searchCourse:YES];
            }
        }
        
        else{
            [_courseTable reloadData];
        }
    }
    
    
}


#pragma mark - APIS

-(void)searchCourse:(BOOL)showHude{
    
   
    
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
        
    }
    [dictionary setValue:countryIDsString forKey:kfilterfilter_country_id];
    [dictionary setValue:institudeIDsString forKey:kfilterfilter_institute_id];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    [dictionary setValue:scholarshipString forKey:kfilterscholarship];
    [dictionary setValue:perfectMatchString forKey:kfilterperfect_match];
    [dictionary setValue:_searchBar.text forKey:kkeyword];
    NSString *message =@"Finding Best Match Courses For You ";
    
    if(pageNumber==1)
    {
        message =@"Finding Best Match Courses For You ";
    }
    else
    {
        message =@"Finding more courses as per your Profile Filters";
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"search_course.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _courseTable.tableHeaderView = nil;
                
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isLoading = NO;
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    int counter = (int)([[payloadDictionary valueForKey:kcourses] count] % 10 );
                    if(counter>0)
                    {
                        LoadMoreData = false;
                    }
                    
                    if (pageNumber == 1 ) {
                        if (_courseArray) {
                            [_courseArray removeAllObjects];
                        }
                        _courseArray = [payloadDictionary valueForKey:kcourses];
                        
                        pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:kcourses];
                        
                        
                        if(arr.count > 0){
                            
                            [_courseArray addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:_courseArray] array];
                            _courseArray =[[NSMutableArray alloc] initWithArray:newArray];
                            
                        }
                        NSLog(@"%lu",(unsigned long)_courseArray.count);
                        pageNumber = pageNumber+1 ;
                    }
                    
                    if([[payloadDictionary valueForKey:@"unica_fee_paid"] integerValue]== 1)
                    {
                        feePaidStatus = NO;
                    }
                    else
                    {
                        feePaidStatus = YES;
                    }
                    
                    unica_fee = [payloadDictionary valueForKey:@"unica_fee"];
                    applied_count = [[payloadDictionary valueForKey:@"applied_count"] integerValue];
                    apply_limit = [[payloadDictionary valueForKey:@"apply_limit"] integerValue];
                    [_courseTable reloadData];
                    
                    
                    messageLabel.text = @"";
                    messageLabel.hidden = YES;
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber ==1) {
                            
                            [_courseArray removeAllObjects];
                            [_courseTable reloadData];
                            
                            
                            messageLabel.text = @"No records found";
                            messageLabel.hidden = NO;
                            
                            
                        }
                        else{
                            
                            messageLabel.text = @"";
                            messageLabel.hidden = YES;
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
                        
                        [_courseArray removeAllObjects];
                        [_courseTable reloadData];
                        
                        
                        
                        messageLabel.text = @"No records found";
                        messageLabel.hidden = NO;
                        
                    }
                    else{
                        
                        messageLabel.text = @"";
                        messageLabel.hidden = YES;
                        
                    }
                    
                    _courseTable.tableHeaderView = nil;
                    
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
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
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

-(void)courseLike:(NSMutableDictionary*)selectedDictioanry{
    
    NSString *likeString = [selectedDictioanry valueForKey:@"is_like"];
    NSString *message;
    
    if ([likeString boolValue] == 0) {
        likeString = @"true";
        message = @"Adding this to your Favourites";
        
    }
    else{
        likeString = @"false";
        message = @"Removing this from your Favourites ";
        
    }
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    [dictionary setValue:likeString forKey:kstatus];
    [dictionary setValue:[selectedDictioanry  valueForKey:Kid] forKey:kcourse_id];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student_like_course.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionaryResult, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionaryResult valueForKey:kAPICode] integerValue]== 200) {
                    
                    /*pageNumber = 1;
                    
                    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    [appDelegate getFavouriteList:@"student-fav-courses.php" :kCOURSES];
                    [self favReloadData:dictionary];
                    [self searchCourse:NO];*/
                    
                    NSInteger anIndex=[_courseArray indexOfObject:selectedDictioanry];
                    
                    if ([likeString boolValue] == 0){
                        [[_courseArray objectAtIndex:anIndex] setValue:@"0" forKey:@"is_like"];
                    }
                    else{
                        [[_courseArray objectAtIndex:anIndex] setValue:@"1" forKey:@"is_like"];
                        
                    }
                    [_courseTable reloadData];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (_courseArray) {
                            [_courseArray removeAllObjects];
                            [_courseTable reloadData];
                        }
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
    
    return [_courseArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double height = 0.0;
    
    // course name
    NSString *courseName = [[_courseArray objectAtIndex:indexPath.row]valueForKey:ktitle];
    
    if ( [Utility getTextHeight:courseName size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        height =[Utility getTextHeight:courseName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20;}
    else{
        height = 0;
        
    }
    
    // Application fee
    NSString *applicationFee;
    NSString*convertedtution_fee = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kconverted_amount_tution_fee];
    
    if (![convertedtution_fee isKindOfClass:[NSNull class]] && convertedtution_fee.length >0) {
        
        applicationFee = [NSString stringWithFormat:@"Application Fee: %@(%@)",[[_courseArray objectAtIndex:indexPath.row]valueForKey:kapplication_fee],convertedtution_fee];
    }
    else{
        
        applicationFee = [NSString stringWithFormat:@"Application Fee: %@",[[_courseArray objectAtIndex:indexPath.row]valueForKey:kapplication_fee]];
    }
    
    if ( [Utility getTextHeight:applicationFee size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        height =([Utility getTextHeight:applicationFee size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20)+height;
    }
    else{
        height = height+0;
    }
    
    
    // scholarship
    NSString *scholarship = [NSString stringWithFormat:@"Scholarship - %@", [[_courseArray objectAtIndex:indexPath.row]valueForKey:kscholarship]];
    
    if ( [Utility getTextHeight:scholarship size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        height =([Utility getTextHeight:scholarship size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20)+height;
    }
    else{
        height = height+0;
    }
    
    
    NSString *instituteName = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kinstitute_name];
    // university name
    
    
    
    if ( [Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        height =([Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20)+height;
    }
    else{
        height = height+0;
    }
    
    return 155+height;
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
    
    static NSString *cellIdentifier  =@"courseCell";
    
    
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CourseCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *courseName = [[_courseArray objectAtIndex:indexPath.row]valueForKey:ktitle];
    
    // Course  name
    if (![courseName isKindOfClass:[NSNull class]]) {
        cell.courseNameLabelHeight.constant = [Utility getTextHeight:courseName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        cell.courseTopButtonHeight.constant = [Utility getTextHeight:courseName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]+20;
        cell.courseTopButton.tag = indexPath.row;
        [cell.courseTopButton addTarget:self action:@selector(courseTopButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.courseNameLabel.text = courseName;
    }
    
    
    cell.imageButton.tag = indexPath.row;
    [cell.imageButton addTarget:self action:@selector(courseTopButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    // Application fee
    NSString *applicationFee;
    
    
    
    NSString*convertedtution_fee = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kconverted_amount_application_fee];
    
    if ([[[_courseArray objectAtIndex:indexPath.row]valueForKey:kapplication_fee] integerValue]>0) {
        
        applicationFee = [NSString stringWithFormat:@"Application Fee: %@(%@)",[[_courseArray objectAtIndex:indexPath.row]valueForKey:kapplication_fee],convertedtution_fee];
    }
    else{
        applicationFee = [NSString stringWithFormat:@"Application Fee: 0 USD"];
    }
    
    cell.feeLabelHeight.constant = 20;
    if (![applicationFee isKindOfClass:[NSNull class]]) {
        cell.feeLabelHeight.constant =[Utility getTextHeight:applicationFee size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextField];
        cell.feeLabel.text = applicationFee;
    }
    
    // scholarship
    NSString *scholarship ;
    if ([[[_courseArray objectAtIndex:indexPath.row]valueForKey:kscholarship] integerValue]>0) {
        scholarship = [NSString stringWithFormat:@"Scholarship - %@ %%", [[_courseArray objectAtIndex:indexPath.row]valueForKey:kscholarship]];
        
        if (![scholarship isKindOfClass:[NSNull class]]) {
            cell.scholarshipLabelHeight.constant =[Utility getTextHeight:scholarship size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextField];
            
            cell.scholarshipLabel.text = scholarship;
        }
    }
    else{
        cell.scholarshipLabelHeight.constant = 0.0;
    }
    
    
    
    
    NSString *instituteName = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kinstitute_name];
    // university name
    if (![instituteName isKindOfClass:[NSNull class]]) {
        cell.universityNameLabelHeight.constant =[Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        cell.universityNameLabel.text = instituteName;
    }
    
   /* // profile image
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2;
    [cell.profileImage.layer setMasksToBounds:YES];
    
    cell.courseView.layer.cornerRadius = 5.0;
    [cell.courseView.layer setMasksToBounds:YES];*/
    
    
    // chech mark image
    
    if ([[[_courseArray objectAtIndex:indexPath.row]valueForKey:kis_eligible] boolValue]== true) {
        [cell.chemarkButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    
    // like
    
    if ([[[_courseArray objectAtIndex:indexPath.row]valueForKey:kis_like]boolValue] ==true) {
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    }
    else{
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
    }
    [cell.likeButton addTarget:self action:@selector(_favoriteButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.likeButton.tag = indexPath.row;
    
    
    cell.imageBackgroundView.layer.cornerRadius = cell.imageBackgroundView.frame.size.width/2;
    cell.imageBackgroundView.layer.borderWidth =1.0;
    cell.imageBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell.imageBackgroundView.layer setMasksToBounds:YES];
    
    cell.countryName.text = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kcourse_country];
    
    
    // cell image
    
    if (![[[_courseArray objectAtIndex:indexPath.row] valueForKey:kcountry_image] isKindOfClass:[NSNull class]]) {
        
        
        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[[_courseArray objectAtIndex:indexPath.row] valueForKey:kcountry_image]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    
    
    
    if ([[[_courseArray objectAtIndex:indexPath.row]valueForKey:kapplied]boolValue] ==true) {
        cell.applyButton.backgroundColor = [UIColor grayColor];
        cell.applyButton.userInteractionEnabled = YES;
        [cell.applyButton setTitle:@"Applied" forState:UIControlStateNormal];
    }
    else{
        
        cell.applyButton.tag = indexPath.row;
        [cell.applyButton addTarget:self action:@selector(applyButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if([_courseArray objectAtIndex:indexPath.row]==[_courseArray objectAtIndex:_courseArray.count-1])
    {
        if(_courseArray.count>=10 && LoadMoreData==true)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self searchCourse:YES];
            });
        
    }
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self getInstitudeDetails:[_courseArray objectAtIndex:indexPath.row]];
    //[self performSegueWithIdentifier:kcourseDetailsViewController sender:[_courseArray objectAtIndex:indexPath.row]];
    
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
                // _courseTable.tableFooterView = spinner;
                
                //[self searchCourse:YES];
            }
            
        }
    }
    
    else{
        
        _courseTable.tableFooterView = nil;
    }
}


#pragma  mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    pageNumber = 1;
    [_courseTable setContentOffset:CGPointZero animated:YES];
    [self searchCourse:YES];
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
    if([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        pageNumber = 1;
        [_courseTable setContentOffset:CGPointZero animated:YES];
        [self searchCourse:NO];
    }
}

-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"%@",_searchBar.text);
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    _courseTable.tableHeaderView = spinner;
    
    pageNumber = 1;
    [_courseTable setContentOffset:CGPointZero animated:YES];
    [self searchCourse:NO];
    
    
    //    if([_searchBar.text isEqualToString:@""])
    //    {
    //        [self searchCourse:NO];
    //    }
    //    else{
    //
    //        [self searchCourse:NO];
    //
    //    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kAgentFilterSegueIdentifier]) {
        UNKAgentFilterViewController *agentFilter = segue.destinationViewController;
        agentFilter.incomingViewType = KCourse;
        agentFilter.institutionFilter =self.institutionFilter;
        agentFilter.countryFilter =self.countryFilter;
        agentFilter.scholarShipFilter =self.scholarShipFilter;
        agentFilter.perfectFilter =self.perfectFilter;
        agentFilter.applyButtonDelegate = self;
        agentFilter.removeAllFilter = self;
    }
    else if ([segue.identifier isEqualToString:kcourseDetailsViewController]) {
        UNKCourseDetailsViewController *courseDetails = segue.destinationViewController;
        courseDetails.feePaidStatus = feePaidStatus;
        courseDetails.unica_fee = unica_fee;
        courseDetails.applied_count = applied_count;
        courseDetails.apply_limit = apply_limit;
        courseDetails.selectedCourseDictionary = sender;
        
    }
    else  if ([segue.identifier isEqualToString:kInstitudeSegueIdentifer]) {
        UNKInstitudeViewController *institudeViewController = segue.destinationViewController;
        institudeViewController.institudeDictionary = sender;
        
    }
}

#pragma mark - button delegate method

-(void)courseTopButton_clicked:(UIButton *)sender{
    
    [self performSegueWithIdentifier:kcourseDetailsViewController sender:[_courseArray objectAtIndex:sender.tag]];
    
}
- (void)_favoriteButton_Clicked:(UIButton*)sender {
    UIButton *favoriteButton = (UIButton*)sender;
    [self courseLike:[_courseArray objectAtIndex:favoriteButton.tag]];
    
}

- (IBAction)segment_clicked:(id)sender {
    if (_segment.selectedSegmentIndex == 0) {
    }
    else if ( _segment.selectedSegmentIndex == 1){
        [self performSegueWithIdentifier:kAgentFilterSegueIdentifier sender:nil];
    }
}

- (IBAction)filterButton_clicked:(id)sender {
    [_searchBar resignFirstResponder];
    [self performSegueWithIdentifier:kAgentFilterSegueIdentifier sender:nil];
}

- (IBAction)backButton_clicked:(id)sender {
    
    [kUserDefault removeObjectForKey:@"showHudCousrseDetail"];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma get institude details
-(void)getInstitudeDetails:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    [dictionary setValue:[selectedDictionary valueForKey:kinstitute_id] forKey:kinstitute_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"institute_detail.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [self performSegueWithIdentifier:kInstitudeSegueIdentifer sender:payloadDictionary];
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

// apply for course

-(void)applyButton_clicked:(UIButton *)sender{
    
    NSMutableDictionary *courseDictionary = [_courseArray objectAtIndex:sender.tag];
    [self ApplyFunction:courseDictionary];
   
    
    
}
-(void)ApplyFunction: (NSMutableDictionary*)courseDictionary
{
    BOOL globalApplicationForm = [[kUserDefault valueForKey:kisGlobalFormCompleted] boolValue];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterSpellOutStyle];
    
    if(globalApplicationForm == YES)
    {
        if(feePaidStatus ==NO )
        {
            
            
            if ([[courseDictionary valueForKey:kapplication_fee] integerValue] ==0) {
                
                textMessage = [NSString stringWithFormat:@"Full %@ is refunded by the Institution in form of fee discount or cash or voucher, when you successfully enroll at any Institution applied using this App. You can apply up to %@ courses using this app and in case any of your application is rejected by an institution, it will not be counted in %@, so you can apply to another course or institution. This %@ fee is not refunded by UNICA.",unica_fee,[f stringFromNumber:[NSNumber numberWithInt:apply_limit]],[f stringFromNumber:[NSNumber numberWithInt:apply_limit]],unica_fee];
                
                subTitle = @"(100% Refundable/Cash back)";
                amount = [NSString stringWithFormat:@"One time Application Processing FEE : %@",unica_fee];
                [self creatPopView];
            }
            else{
                [Utility showAlertViewControllerIn:self withAction:@"CANCEL" actionTwo:@"OK" title:@"" message:[NSString stringWithFormat:@"Application FEE for this course is : %@",[courseDictionary valueForKey:kapplication_fee]] block:^(int index){
                    
                    if (index == 1) {
                        
                        textMessage = [NSString stringWithFormat:@"Full %@ is refunded by the Institution in form of fee discount or cash or voucher, when you successfully enroll at any Institution applied using this App. You can apply up to %@ coursesusing this app and in case any of your application is rejected by an institution, it will not be counted in %@, so you can apply to another course or institution. This %@ fee is not refunded by UNICA.",unica_fee,[f stringFromNumber:[NSNumber numberWithInt:apply_limit]],[f stringFromNumber:[NSNumber numberWithInt:apply_limit]],unica_fee];
                        
                        subTitle = @"(100% Refundable/Cash back)";
                        amount = [NSString stringWithFormat:@"One time Application Processing FEE : %@",unica_fee];
                        [self creatPopView];
                    }
                }];
            }
            
            
            
        }
        else
        {
            if(applied_count<=apply_limit)
            {
                if (apply_limit-applied_count == 0) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:@"You have exceeded the limit of application allowance on your account." block:^(int index){}];
                    
                }
                else{
                    if ([[courseDictionary valueForKey:kapplication_fee] integerValue] >0)
                    {
                        [Utility showAlertViewControllerIn:self withAction:@"CANCEL" actionTwo:@"OK" title:@"" message:[NSString stringWithFormat:@"Application FEE for this course is : %@",[courseDictionary valueForKey:kapplication_fee]] block:^(int index){
                            
                            if (index == 1) {
                                NSString *course;
                                if(apply_limit-applied_count<2)
                                {
                                    course=@"course";
                                }
                                else
                                {
                                    course=@"courses";
                                }
                                [Utility showAlertViewControllerIn:self withAction:@"No" actionTwo:@"YES" title:@"" message:[NSString stringWithFormat:@"Are you sure, You want to apply for this course, you can apply for %ld more %@",apply_limit-applied_count,course] block:^(int index){
                                    
                                    if (index == 1) {
                                        
                                        [kUserDefault setValue:courseDictionary forKey:kPaymentInfoDict];
                                        
                                        self.navigationController.navigationBarHidden = NO;
                                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                        UNKQuestionnaireViewController *questionnaireViewController = [storyBoard instantiateViewControllerWithIdentifier:@"QuestionnaireViewController"];
                                        questionnaireViewController.isAlreadyPay = true;
                                        [self.navigationController pushViewController:questionnaireViewController animated:YES];
                                        
                                    }
                                    
                                    
                                }];
                            }
                        }];
                    }
                    else
                    {
                        NSString *course;
                        if(apply_limit-applied_count<2)
                        {
                            course=@"course";
                        }
                        else
                        {
                            course=@"courses";
                        }
                        [Utility showAlertViewControllerIn:self withAction:@"No" actionTwo:@"YES" title:@"" message:[NSString stringWithFormat:@"Are you sure, You want to apply for this course, you can apply for %ld more %@",apply_limit-applied_count,course] block:^(int index){
                            
                            if (index == 1) {
                                
                                [kUserDefault setValue:courseDictionary forKey:kPaymentInfoDict];
                                
                                self.navigationController.navigationBarHidden = NO;
                                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                UNKQuestionnaireViewController *questionnaireViewController = [storyBoard instantiateViewControllerWithIdentifier:@"QuestionnaireViewController"];
                                questionnaireViewController.isAlreadyPay = true;
                                [self.navigationController pushViewController:questionnaireViewController animated:YES];
                                
                            }
                            
                            
                        }];
                    }
                    
                }
                
                
            }
        }
        
    }
    else
    {
        [Utility showAlertViewControllerIn:self title:@"" message:@"To apply course,Please complete Global application first." block:^(int index) {
            
            [kUserDefault setObject:courseDictionary forKey:@"searchCourese"];
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"GAF" bundle:[NSBundle mainBundle]];
            GlobalApplicationStep1ViewController *globalApplicationStep1ViewController = [storyBoard instantiateViewControllerWithIdentifier:@"GAFStepp1StoryboardID"];
            [self.navigationController pushViewController:globalApplicationStep1ViewController animated:YES];
            
            /*  NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
             for (UIViewController *aViewController in allViewControllers)
             {
             
             if ([aViewController isKindOfClass:[UNKWebViewController  class]])
             
             {
             [self.navigationController popToViewController:aViewController animated:NO];
             }
             else if  ([aViewController isKindOfClass:[UNKHomeViewController class]]){
             self.navigationController.navigationBarHidden = NO;
             UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"GAF" bundle:[NSBundle mainBundle]];
             GlobalApplicationStep1ViewController *globalApplicationStep1ViewController = [storyBoard instantiateViewControllerWithIdentifier:@"GlobalApplicationStep1ViewController"];
             [self.navigationController pushViewController:globalApplicationStep1ViewController animated:YES];
             }
             }*/
            
        }];
        
    }
}

#pragma  make payment
-(void)makePayment
{
    self.navigationController.navigationBarHidden=YES;
    
    float price = 50.00;
    
    //Merchant has to configure the below code
    [kUserDefault setValue:kcourses forKey:kFromView];
    
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@",[dictLogin valueForKey:@"firstname"],[dictLogin valueForKey:@"lastname"]];
    
    
    NSMutableDictionary *residentialDictionary = [kUserDefault  valueForKey:kresidential_address];
    
    NSString *strBillingAddress = @"test";
    NSString *strBillingCity = @"Delhi";
    NSString *strBillingState = @"Delhi";
    NSString *strBillingPostal = @"201010";
    NSString *strCountryCode = @"IND";
    
    
    if (residentialDictionary) {
        
        if ([residentialDictionary valueForKey:@"address"]) {
            strBillingAddress  = [residentialDictionary valueForKey:@"address"];
        }
        if ([residentialDictionary valueForKey:@"city"]) {
            strBillingCity  = [residentialDictionary valueForKey:@"city"];
        }
        if ([residentialDictionary valueForKey:@"state"]) {
            strBillingState  = [residentialDictionary valueForKey:@"state"];
        }
        if ([residentialDictionary valueForKey:@"zip_code"]) {
            strBillingPostal  = [residentialDictionary valueForKey:@"zip_code"];
        }
        if ([dictLogin valueForKey:@"country_code"]) {
            strCountryCode  = [dictLogin valueForKey:@"country_code"];
        }
        
    }
    
    
    PaymentModeViewController *paymentView = [[PaymentModeViewController alloc]init];
    
    paymentView.ACC_ID = @"23778";
    paymentView.SECRET_KEY = @"b02fe0e3d9980c401af39de16ff58dab"; paymentView.MODE = @"TEST";
    paymentView.ALGORITHM = @"";
    
    
    paymentView.strSaleAmount=[NSString stringWithFormat:@"%0.2f",price];
    paymentView.reference_no=@"223";
    paymentView.descriptionString = @"Test Description";
    paymentView.strCurrency =@"INR";
    paymentView.strDisplayCurrency =@"USD";
    paymentView.strDescription = @"Test Description";
    
    paymentView.strBillingName = name;
    paymentView.strBillingAddress = strBillingAddress;
    paymentView.strBillingCity = strBillingCity;
    paymentView.strBillingState = strBillingState;
    paymentView.strBillingPostal = strBillingPostal;
    paymentView.strBillingCountry = strCountryCode;
    paymentView.strBillingEmail = [dictLogin valueForKey:@"email"];
    
    
    NSString *phoneNumber = [NSString stringWithFormat:@"%@",[dictLogin valueForKey:@"mobileNumber"]];
    
    NSArray *array = (NSArray*)[phoneNumber componentsSeparatedByString:@" "];
    if (array.count == 2) {
        phoneNumber = [NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
    }

    
    paymentView.strBillingTelephone = phoneNumber;
    
    paymentView.strDeliveryName = @"";
    paymentView.strDeliveryAddress = @"";
    paymentView.strDeliveryCity = @"";
    paymentView.strDeliveryState = @"";
    paymentView.strDeliveryPostal =@"";
    paymentView.strDeliveryCountry = @"";
    paymentView.strDeliveryTelephone =@"";
    
    [kUserDefault setObject:kcourses forKey:kPaymentModeType];
    [self.navigationController pushViewController:paymentView animated:NO];
    
}


#pragma popView
-(void)creatPopView{
    
    bgView = [[UIView alloc]initWithFrame:self.view.window.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self.view.window addSubview:bgView];
    
    popupView = [[UIView alloc]initWithFrame:CGRectMake(20, 150, kiPhoneWidth-40, kiPhoneHeight-100)];
    popupView.backgroundColor = [UIColor whiteColor];
    [self.view.window addSubview:popupView];
    popupView.layer.cornerRadius = 10.0;
    [popupView.layer setMasksToBounds:YES];
    
    CGFloat height =  10.0;
    
    // info button
    UIButton *infoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
    infoButton.backgroundColor = [UIColor clearColor];
    [infoButton setImage:[UIImage imageNamed:@"FAQ"] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButton_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:infoButton];
    
    
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoButton.frame.size.width+infoButton.frame.origin.x+10, 20, kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60),50)];
    headerLabel.text = amount;
    headerLabel.numberOfLines = 0;
    headerLabel.font = [UIFont fontWithName:kFontSFUITextSemibold size:14];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    [popupView addSubview:headerLabel];
    
    height = height+50;
    
    
    
    CGFloat subTitleLabelHeight = [Utility getTextHeight:subTitle size:CGSizeMake(kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60), 999) font:[UIFont fontWithName:kFontSFUITextRegular size:14]];
    
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoButton.frame.size.width+infoButton.frame.origin.x+10, height+10, kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60), subTitleLabelHeight)];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.text = subTitle;
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.font = kDefaultFontForApp;
    
    [popupView addSubview:subTitleLabel];
    
    height = subTitleLabelHeight+height+10;
    
    UILabel *textLabel;
    
    if (isInfoClicked == NO) {
        
        
        CGFloat testHeight = [Utility getTextHeight:textMessage size:CGSizeMake(kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60), 999) font:[UIFont fontWithName:kFontSFUITextRegular size:14]];
        
        
        UIImageView *popImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, height, kiPhoneWidth-60, testHeight+20)];
        popImage.image = [UIImage imageNamed:@"popImage"];
        [popupView addSubview:popImage];
        
        
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, height+10, kiPhoneWidth-70, testHeight)];
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = kDefaultFontForApp;
        textLabel.text = textMessage;
        textLabel.backgroundColor = [UIColor clearColor];
        [popupView addSubview:textLabel];
        
        height = testHeight+height+20;
        
        
    }
    else{
        [textLabel removeFromSuperview];
    }
    
    
    
    // ok button
    UIButton *okButon = [[UIButton alloc]initWithFrame:CGRectMake(popupView.frame.size.width-100, height+30, 70, 30)];
    okButon.backgroundColor = kDefaultBlueColor;
    [okButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButon setTitle:@"OK" forState:UIControlStateNormal];
    [okButon.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [okButon addTarget:self action:@selector(okButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [okButon setTintColor:[UIColor whiteColor]];
    okButon.layer.cornerRadius = 5.0;
    [okButon.layer setMasksToBounds:YES];
    [popupView addSubview:okButon];
    
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(30, height+30, 70, 30)];
    cancelButton.backgroundColor = kDefaultBlueColor;
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 5.0;
    [cancelButton.layer setMasksToBounds:YES];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelButton addTarget:self action:@selector(cancelButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:cancelButton];
    
    height = height+80;
    
    popupView.frame = CGRectMake(20, 150, kiPhoneWidth-40,height);
    
    
}

#pragma mark button Action

-(void)infoButton_Clicked{
    
    if (isInfoClicked == YES) {
        isInfoClicked = NO;
    }
    else{
        isInfoClicked = YES;
    }
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
    [self creatPopView];
}

-(void)okButton_Clicked:(UIButton *)sender{
    
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
    
    [self makePayment];
    [kUserDefault setValue:[_courseArray objectAtIndex:sender.tag] forKey:kPaymentInfoDict];
    
    NSLog(@"OK");
}

-(void)cancelButton_Clicked:(UIButton*)sender{
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
    isInfoClicked = NO;
    
}

-(void)favReloadData:(NSMutableDictionary *)dictionary
{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[dictionary valueForKey:kcourse_id]];
    
    
    
    NSArray *lastEducationCountryFilterArray = [_courseArray filteredArrayUsingPredicate:predicate];
    
    if (lastEducationCountryFilterArray.count>0) {
        NSString *status=@"0";
        if([[dictionary valueForKey:kstatus] isEqualToString:@"true"])
        {
            status=@"1";
        }
        [[lastEducationCountryFilterArray objectAtIndex:0]  setValue:status forKey:@"is_like"];
        [_courseTable reloadData];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
}

#pragma  Mark - Filter delegate

-(void)checkApplyButtonAction:(NSInteger)index{
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
    isFromFilter = true;

}

-(void)removeAllFilter:(NSInteger)index{
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
    
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];

    isFromFilter = true;
}

@end
