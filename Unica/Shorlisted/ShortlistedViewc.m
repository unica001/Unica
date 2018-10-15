//
//  ShortlistedViewc.m
//  Unica
//
//  Created by Shilpa Sharma on 03/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.

#import "ShortlistedViewc.h"
#import "ShortlistCourseCell.h"
#import "UNKCourseDetailsViewController.h"

@interface ShortlistedViewc () {
    NSString *unica_fee, *currancyString;
    NSInteger applied_count,apply_limit;
    BOOL feePaidStatus;
    
    BOOL isFromFilter;
    BOOL LoadMoreData;
}

@end

@implementation ShortlistedViewc

#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageNumber = 1;
   [_tblViewShortlisted registerNib:[UINib nibWithNibName:@"ShortlistCourseCell" bundle:nil] forCellReuseIdentifier:@"ShortlistCourseCell"];
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor blackColor];
    [self.view addSubview:messageLabel];
    [self apiCallShortlistedCourse];
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

#pragma mark - IBAction Methods

- (IBAction)tapBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark popView
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

#pragma mark Methods

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

-(void)courseTopButton_clicked:(UIButton *)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNKCourseDetailsViewController *courseDetails = [sb instantiateViewControllerWithIdentifier:@"CourseDetailsViewController"];
    courseDetails.feePaidStatus = feePaidStatus;
    courseDetails.unica_fee = unica_fee;
    courseDetails.applied_count = applied_count;
    courseDetails.apply_limit = apply_limit;
    courseDetails.selectedCourseDictionary = [_courseArray objectAtIndex:sender.tag];
    courseDetails.unica_feeCurrancy = currancyString;
    [self.navigationController pushViewController:courseDetails animated:YES];
}

- (void)_favoriteButton_Clicked:(UIButton*)sender {
    UIButton *favoriteButton = (UIButton*)sender;
    [self courseLike:[_courseArray objectAtIndex:favoriteButton.tag]];
}

-(void)applyButton_clicked:(UIButton *)sender{
    NSMutableDictionary *courseDictionary = [_courseArray objectAtIndex:sender.tag];
    [self ApplyFunction:courseDictionary];
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Student" bundle:[NSBundle mainBundle]];
//    UNKFilterViewC *agentFilter = [sb instantiateViewControllerWithIdentifier:@"UNKFilterViewC"];
////    agentFilter.incomingViewType = KEvent;
////    agentFilter.removeAllFilter = self;
////    agentFilter.applyButtonDelegate = self;
//    [self.navigationController pushViewController:agentFilter animated:true];
}

#pragma  make payment
-(void)makePayment
{
    self.navigationController.navigationBarHidden=YES;
    
    //float price = 50.00;
    float price = [unica_fee floatValue];
    
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
    
    //    paymentView.ACC_ID = @"23778";
    //    paymentView.SECRET_KEY = @"b02fe0e3d9980c401af39de16ff58dab";
    paymentView.ACC_ID = @"23777";
    paymentView.SECRET_KEY = @"4ec951b8122cd0acc5f4b96011d4d8a7";
    //paymentView.MODE = @"TEST";
    paymentView.MODE = @"LIVE";
    paymentView.ALGORITHM = @"";
    
    
    paymentView.strSaleAmount=[NSString stringWithFormat:@"%0.2f",price];
    paymentView.reference_no=@"223";
    paymentView.descriptionString = @"Test Description";
    //    paymentView.strCurrency =@"INR";
    //    paymentView.strDisplayCurrency =@"USD";
    paymentView.strCurrency =currancyString;
    paymentView.strDisplayCurrency =currancyString;
    
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
#pragma mark: UITableView Delegate

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

    NSString *instituteName = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kinstitute_name];
    //university name
    if ( [Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        height =([Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20)+height;
    }
    else{
        height = height+0;
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
    static NSString *cellIdentifier  =@"ShortlistCourseCell";
    ShortlistCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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

    NSString *instituteName = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kinstitute_name];
    // university name
    if (![instituteName isKindOfClass:[NSNull class]]) {
        cell.universityNameLabelHeight.constant =[Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        cell.universityNameLabel.text = instituteName;
    }

    // like

    if ([[[_courseArray objectAtIndex:indexPath.row]valueForKey:kis_like]boolValue] ==true) {
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    }
    else{
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
    }
//    [cell.likeButton addTarget:self action:@selector(_favoriteButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
//    cell.likeButton.tag = indexPath.row;


    cell.imageBackgroundView.layer.cornerRadius = cell.imageBackgroundView.frame.size.width/2;
    cell.imageBackgroundView.layer.borderWidth =1.0;
    cell.imageBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell.imageBackgroundView.layer setMasksToBounds:YES];

//    cell.countryName.text = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kcourse_country];
    cell.countryName2.text = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kcourse_country];

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
                [self apiCallShortlistedCourse];
            });

    }
    return  cell;
}


#pragma mark Api call

- (void)apiCallShortlistedCourse {
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    [dictionary setValue:[NSString stringWithFormat:@"%d", pageNumber] forKey:kPage_number];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"interested_course_student.php"];
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dict, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dict valueForKey:kAPIPayload];
                isLoading = NO;
                if ([[dict valueForKey:kAPICode] integerValue]== 200) {
                    int counter = (int)([[payloadDictionary valueForKey:kcourses] count] % 10 );
                    if(counter>0) {
                        LoadMoreData = false;
                    }
                    if (pageNumber == 1 ) {
                        if (_courseArray) {
                            [_courseArray removeAllObjects];
                        }
                        _courseArray = [payloadDictionary valueForKey:kcourses];
                        pageNumber = 2;
                    } else {
                        NSMutableArray *arr = [payloadDictionary valueForKey:kcourses];
                        if(arr.count > 0){
                            [_courseArray addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:_courseArray] array];
                            _courseArray =[[NSMutableArray alloc] initWithArray:newArray];
                        }
                        pageNumber = pageNumber+1 ;
                    }
                    
                    if([[payloadDictionary valueForKey:@"unica_fee_paid"] integerValue]== 1) {
                        feePaidStatus = NO;
                    } else {
                        feePaidStatus = YES;
                    }
                    
                    NSString * str = [payloadDictionary valueForKey:@"unica_fee"];
                    NSArray * arr = [str componentsSeparatedByString:@" "];
                    unica_fee =[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]] ;
                    currancyString =[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
                    applied_count = [[payloadDictionary valueForKey:@"applied_count"] integerValue];
                    apply_limit = [[payloadDictionary valueForKey:@"apply_limit"] integerValue];
                    messageLabel.text = @"";
                    [messageLabel setHidden:YES];
                    [_tblViewShortlisted reloadData];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (pageNumber ==1) {
                            [_courseArray removeAllObjects];
                            [_tblViewShortlisted reloadData];
                            messageLabel.text = @"No records found";
                            messageLabel.hidden = NO;
                        } else{
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
                    
                    NSInteger anIndex=[_courseArray indexOfObject:selectedDictioanry];
                    
                    if ([likeString boolValue] == 0){
                        [[_courseArray objectAtIndex:anIndex] setValue:@"0" forKey:@"is_like"];
                    }
                    else{
                        [[_courseArray objectAtIndex:anIndex] setValue:@"1" forKey:@"is_like"];
                        
                    }
                    [_tblViewShortlisted reloadData];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (_courseArray) {
                            [_courseArray removeAllObjects];
                            [_tblViewShortlisted reloadData];
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
                
                textMessage = [NSString stringWithFormat:@"Full %@ %@ is refunded by the Institution in form of fee discount or cash or voucher, when you successfully enroll at any Institution applied using this App. You can apply up to %@ courses using this app and in case any of your application is rejected by an institution, it will not be counted in %@, so you can apply to another course or institution. This %@ %@ fee is not refunded by UNICA.",unica_fee,currancyString,[f stringFromNumber:[NSNumber numberWithInt:apply_limit]],[f stringFromNumber:[NSNumber numberWithInt:apply_limit]],unica_fee,currancyString];
                
                subTitle = @"(100% Refundable/Cash back)";
                amount = [NSString stringWithFormat:@"One time Application Processing FEE : %@ %@",unica_fee,currancyString];
                [self creatPopView];
            }
            else{
                [Utility showAlertViewControllerIn:self withAction:@"CANCEL" actionTwo:@"OK" title:@"" message:[NSString stringWithFormat:@"Application FEE for this course is : %@",[courseDictionary valueForKey:kapplication_fee]] block:^(int index){
                    
                    if (index == 1) {
                        
                        textMessage = [NSString stringWithFormat:@"Full %@ %@ is refunded by the Institution in form of fee discount or cash or voucher, when you successfully enroll at any Institution applied using this App. You can apply up to %@ coursesusing this app and in case any of your application is rejected by an institution, it will not be counted in %@, so you can apply to another course or institution. This %@ %@ fee is not refunded by UNICA.",unica_fee,currancyString,[f stringFromNumber:[NSNumber numberWithInt:apply_limit]],[f stringFromNumber:[NSNumber numberWithInt:apply_limit]],unica_fee,currancyString];
                        
                        subTitle = @"(100% Refundable/Cash back)";
                        amount = [NSString stringWithFormat:@"One time Application Processing FEE : %@ %@",unica_fee,currancyString];
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
            
        }];
    }
}

#pragma  Mark - Filter delegate

-(void)checkApplyButtonAction:(NSInteger)index{
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
    
    isFromFilter = true;
}

-(void)removeAllFilter:(NSInteger)index{
    
    isFromFilter = true;    
    
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
}
@end
