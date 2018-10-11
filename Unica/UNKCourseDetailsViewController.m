//
//  UNKCourseDetailsViewController.m
//  Unica
//
//  Created by vineet patidar on 29/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKCourseDetailsViewController.h"
#import "CourseDescriptionCell.h"
#import "TimeLineCell.h"
#import "VideoCell.h"
#import "UNKCourseViewController.h"
#import "courseFeeCell.h"
@interface UNKCourseDetailsViewController ()
{
     NSMutableArray *_videoArray;
       UIWebView *webview;
    BOOL isTableLoaded;
}

@end

@implementation UNKCourseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Course Details";
    [self setHeaderViewData];
    
    _courseDetailTable.hidden = YES;
    coursVideoCollectionView.delegate = self;
    
    [self getCourseDetails:self.selectedCourseDictionary];
    
   
     webview = [[UIWebView alloc]init];
    webview.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden= NO;
    
    if([kUserDefault valueForKey:@"searchCourese"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [kUserDefault removeObjectForKey:@"searchCourese"];
            [self applyButton_clicked:nil];
            
        });
    }
    

}
- (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}


-(void)setHeaderViewData{
    
    NSString *course ;
    if([courseDetailDictioanry valueForKey:ktitle])
    {
        course = [courseDetailDictioanry valueForKey:ktitle];
    }
    else
    {
        course = [courseDetailDictioanry valueForKey:kcourse_name];
    }
    CGFloat height = 0.0;
    
    // Course  name
    if (![courseName isKindOfClass:[NSNull class]] && [Utility getTextHeight:course size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]>25) {
        _courseNameHeight.constant = [Utility getTextHeight:course size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        
        height = [Utility getTextHeight:course size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20;
        
    }
    courseName.text = course;
    
    
    NSString *instituteName ;
    if([courseDetailDictioanry valueForKey:kinstitute_name])
    {
        instituteName = [courseDetailDictioanry valueForKey:kinstitute_name];
    }
    else
    {
        instituteName = [courseDetailDictioanry valueForKey:kUnivercity_name];
    }
    
    // university name
    if (![instituteName isKindOfClass:[NSNull class]]&& [Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]>20) {
        _universityNameHeight.constant = [Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        
        height = [Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20;
    }
    _universityName.text = instituteName;
    
    
    CGRect frame = _headerView.frame;
    frame.size.height = height+frame.size.height;
    _headerView.frame = frame;
    
    
    _countryName.text = [courseDetailDictioanry valueForKey:kCountry];
    _countryName2.text = [courseDetailDictioanry valueForKey:kCountry];
    
//    // country image
//    _countryImage.layer.cornerRadius = _countryImage.frame.size.width/2;
//    [_countryImage.layer setMasksToBounds:YES];
    
    NSString *countryImage ;
    if([courseDetailDictioanry valueForKey:kcountry_image])
    {
        countryImage = [courseDetailDictioanry valueForKey:kcountry_image];
    }
    else
    {
        countryImage = [courseDetailDictioanry valueForKey:@"country_flag"];
    }
    
    if (![countryImage isKindOfClass:[NSNull class]]) {
        
        [_countryImage sd_setImageWithURL:[NSURL URLWithString:countryImage] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    
    // chech mark image
    
    if ([[courseDetailDictioanry valueForKey:kis_eligible] boolValue]== true) {
        [_checkMarkButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    
    // like
    
    if ([[courseDetailDictioanry valueForKey:kis_like]boolValue] ==true) {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    }
    else{
        
        
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
    }
    [_likeButton setHidden:NO];

    
    _imageBackgroundView.layer.cornerRadius = _imageBackgroundView.frame.size.width/2;
    _imageBackgroundView.layer.borderWidth =1.0;
    _imageBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_imageBackgroundView.layer setMasksToBounds:YES];
    
    
    _courseDetailTable.layer.cornerRadius = 5.0;
    [_imageBackgroundView.layer setMasksToBounds:YES];
    
    
    if ([[courseDetailDictioanry valueForKey:kapplied]boolValue] ==true) {
        _applyButton.backgroundColor = [UIColor grayColor];
        _applyButton.userInteractionEnabled = NO;
        [_applyButton setTitle:@"Application Sent" forState:UIControlStateNormal];
    }
    else{
        
        [_applyButton addTarget:self action:@selector(applyButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _applied_count = [[courseDetailDictioanry valueForKey:@"applied_count"] integerValue];
    _apply_limit = [[courseDetailDictioanry valueForKey:@"apply_limit"] integerValue];
}

#pragma  mark - APIs
/****************************
 * Function Name : - getCourseDetails
 * Create on : - 29 march 2017
 * Developed By : -  Ramniwas
 * Description : -  This funtion are use for get course details
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getCourseDetails:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    
    if ([self.incomingViewType isEqualToString:kMyApplication]) {
       [dictionary setValue:[selectedDictionary valueForKey:kcourse_id] forKey:kcourse_id];  
    }
    
   else if(![self.selectedCourseDictionary valueForKey:Kid])
    {
     [dictionary setValue:[selectedDictionary valueForKey:kcourse_id] forKey:kcourse_id];
    }
    else{
        [dictionary setValue:[selectedDictionary valueForKey:Kid] forKey:kcourse_id];
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"course_detail.php"];
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    courseDetailDictioanry = [dictionary valueForKey:kAPIPayload];
                     _videoArray = [courseDetailDictioanry valueForKey:kvideos_url];
                    _courseDetailTable.hidden = NO;
                    
                    webview.frame = CGRectMake(0, 30, kiPhoneWidth-20, webview.scrollView.contentSize.height);
                    
                    NSString *string = [NSString stringWithFormat:@"<font face = 'arial'><span style='font-size:14px;color:#555555'><p>%@",[courseDetailDictioanry valueForKey:kdescription]];
                    
                    [webview loadHTMLString:string baseURL:nil];
                    
                    webview.opaque = YES;
                    webview.scrollView.scrollEnabled = NO;
                    
                    [webview setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    if([[courseDetailDictioanry valueForKey:@"unica_fee_paid"] integerValue]== 1)
                    {
                        _feePaidStatus = NO;
                    }
                    else
                    {
                        _feePaidStatus = YES;
                    }
                    
                    _unica_fee = [courseDetailDictioanry valueForKey:@"unica_fee"];

                    [self addVideo:0];
                    [self setHeaderViewData];

                    [_courseDetailTable reloadData];
                    [coursVideoCollectionView reloadData];
                    
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
    
    NSString *likeString ;
    if ([self.selectedCourseDictionary valueForKey:kis_like]) {
        likeString  = [self.selectedCourseDictionary valueForKey:kis_like];
    }
    else{
    
         likeString  = [courseDetailDictioanry valueForKey:kis_like];
    }
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
    if(![self.selectedCourseDictionary valueForKey:ktitle])
    {
        [dictionary setValue:[self.selectedCourseDictionary valueForKey:kcourse_id] forKey:kcourse_id];
    }
    else{
        [dictionary setValue:[self.selectedCourseDictionary valueForKey:Kid] forKey:kcourse_id];
    }

    
    
    [dictionary setValue:likeString forKey:kstatus];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student_like_course.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    if (![self.incomingViewType isEqualToString:kFavourite]) {
                        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        [appDelegate getFavouriteList:@"student-fav-courses.php" :kCOURSES];
                    }
                   
                    
                    if ([likeString boolValue] ==true) {
                        [_likeButton setBackgroundImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
                        [self.selectedCourseDictionary setValue:likeString forKey:kis_like];
                    }
                    else if ([likeString boolValue] ==false) {
                        [_likeButton setBackgroundImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
                        [self.selectedCourseDictionary setValue:likeString forKey:kis_like];
                    }
                    else{
                        
                        
                        if ([self.incomingViewType isEqualToString:kFavourite]) {
                            
                            
                            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"course_id == %@",[NSString stringWithFormat:@"%@",[self.selectedCourseDictionary valueForKey:kcourse_id]]];
                            
                            NSArray *filterArray = [_favouriteArray filteredArrayUsingPredicate:predicate];
                            
                            if(filterArray.count>0)
                            {
                                [_favouriteArray  removeObject:[filterArray objectAtIndex:0]];
                            }
                            
                            NSMutableDictionary *favDict = [[NSMutableDictionary alloc]init];
                            [_favouriteArray removeObject:self.selectedCourseDictionary];
                            
                            [favDict setValue:_favouriteArray forKey:kCOURSES];
                            [UtilityPlist saveData:favDict fileName:kCOURSES];
                        }
                         [self.selectedCourseDictionary setValue:likeString forKey:kis_like];
                        [_likeButton setBackgroundImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
                        
                       
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
    if ([selectedDictionary valueForKey:kinstitute_id]) {
        [dictionary setValue:[selectedDictionary valueForKey:kinstitute_id] forKey:kinstitute_id];
    }
    else{
     [dictionary setValue:[courseDetailDictioanry valueForKey:kinstitute_id] forKey:kinstitute_id];
    }
    
    
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


#pragma mark - Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(courseDetailDictioanry.count>0)
    {
        if (section ==1) {
            return 2;
        }
        if (section ==2) {
            return [[courseDetailDictioanry valueForKey:kcharges] count]-2;
        }
        else if (section ==5){
            
            return [[courseDetailDictioanry valueForKey:kintake] count];
            
        }
        else  if (section == 4){
            
            return 0;
        }
        //else  if (section == 5+[[courseDetailDictioanry valueForKey:kintake] count]){
        else  if (section == 6){
            
            return [[courseDetailDictioanry valueForKey:ktimeline] count];
        }
        
        return 1;
    }
    else
    {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 5 ){
        return 40;
        
    }
    else if (section == 6){
        
        return 40;

    }
    else if (section != 0) {
        return 1;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    if (section == 5 ){
        view.frame = CGRectMake(0, 0, kiPhoneWidth, 40);
        view.backgroundColor = [UIColor whiteColor];

        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kiPhoneWidth-20, 40)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.text = @"Intakes";
        [view addSubview:headerLabel];
        
        return view;
    }
    else if (section == 6){
        view.frame = CGRectMake(0, 0, kiPhoneWidth, 40);
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, kiPhoneWidth-40, 30)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.text = @"Timelines";
        [view addSubview:headerLabel];
        
        UIImageView *clockImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20,20)];
        clockImage.image = [UIImage imageNamed:@"Clock"];
        [view addSubview:clockImage];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 1)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:lineLabel];
        
        return view;
    }

    
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
//        double height = 0.0;
    
        if (![[Utility replaceNULL:[courseDetailDictioanry valueForKey:kdescription] value:@""] isEqualToString:@""]) {
            
            if (webview.scrollView
                .contentSize.height>0) {
                return webview.scrollView.contentSize.height+30;
            }
            return 0;
        }
        return 40;
        
    }
    else if (indexPath.section== 7){
        double height = 0.0;
        
        NSString *eligibility = [courseDetailDictioanry valueForKey:keligibility_domestic_student];
        
        if (![eligibility isKindOfClass:[NSNull class]] &&  [Utility getTextHeight:eligibility size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]> 20) {
            
            height =  [Utility getTextHeight:eligibility size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20;
        }
        else{
            height = 0.0;
            
        }
        return 60+height;
        
        
    }
    else if (indexPath.section== 8){
        
        double height = 0.0;
        
        NSString *other = [courseDetailDictioanry valueForKey:kother_admission_requirement];
        
        if (![other isKindOfClass:[NSNull class]] && [Utility getTextHeight:other size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
            height = [Utility getTextHeight:other size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20;
        }
        else{
            height = 0.0;
        }
        return 60+height;
        
        
    }
    else if (indexPath.section== 9){
        
        double height = 0.0;
        
        NSString *special = [courseDetailDictioanry valueForKey:kspecial_appl_instructions];
        
        if ([Utility getTextHeight:special size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
            height = [Utility getTextHeight:special size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20;
        }
        else{
            height = 0.0;
        }
        return 60+height;
    }
    else if(indexPath.section==4)
    {
        return 0;
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row ==0) {
            
            if([Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField]>40)
                return [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField];
                else{
                    return 40;
                }
            
        }
        else if (indexPath.row ==1) {
            
            if([Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField]>40)
                return [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField];
                else{
                    return 40;
                }
           
        }
        else   if (indexPath.row ==2) {
            
            if([Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField]>40)
                return [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField];
            else{
                return 40;
            }
            
        }
        
        else  {
            
            // cell.textLabel.text = [NSString stringWithFormat:@"Tution Fee Breakup : %@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] ];
            if([Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField]>40)
                return [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField];
            else{
                return 40;
            }
            
           
        }
    }
    else
        return 40;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 1 ){
        
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        
        if (indexPath.row ==0) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] isKindOfClass:[NSNull class]]) {
                cell.headinLabel.text = @"Duration :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Duration :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Duration :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kduration]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kduration]  ];
                cell.iconImageView.image =[UIImage imageNamed:@"Calendar"];
                
            }
            
        }
        else  {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] isKindOfClass:[NSNull class]]) {
                
                cell.headinLabel.text = @"Average processing time :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Average processing time :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Average processing time :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kprocessing_time]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kprocessing_time] ];
                
                cell.iconImageView.image =[UIImage imageNamed:@"Clock"];
                
            }
        }
        
        return cell;
    }
    else if (indexPath.section ==2){
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        
        
        
        if (indexPath.row ==0) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] isKindOfClass:[NSNull class]]) {
                cell.headinLabel.text = @"Tution Fee : ";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Tution Fee : " size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Tution Fee : " size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] ];
                
            }
            
        }
        else if (indexPath.row ==1) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] isKindOfClass:[NSNull class]]) {
                
                cell.headinLabel.text = @"Application Fee :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Application Fee :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Application Fee :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] ];
                
                
                
            }
        }
        else   if (indexPath.row ==2) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] isKindOfClass:[NSNull class]]) {
                
                cell.headinLabel.text = @"Living Cost :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Living Cost :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Living Cost :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] ];
                
            }
        }
        
        else  if (indexPath.row ==3 ) {
            
            cell.headinLabel.text = @"Tution Fee Breakup :";
            CGRect lblFrame1 =cell.headinLabel.frame;
            lblFrame1.size.width =[Utility getTextWidth:@"Tution Fee Breakup :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell.headinLabel.frame= lblFrame1;
            cell.headingWidthConstant.constant = [Utility getTextWidth:@"Tution Fee Breakup :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            float hight = [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
            if(hight<30)
                hight=30;
            
            cell.descHeightConstant.constant = hight;
            
            CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
            
            cell.descLabel.frame=lblFrame;
            cell.descLabel.numberOfLines=0;
            cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
            //[cell.descLabel sizeToFit];
            cell.descLabel.text =[NSString stringWithFormat:@"%@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] ];
            
            
        }
        
        return  cell;
        
    }
    
    if (indexPath.section == 3){
        
        
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        
        if (indexPath.row ==0) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kcourse_level] isKindOfClass:[NSNull class]]) {
                cell.headinLabel.text = @"Program Level :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Program Level :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Program Level :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                
                float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kcourse_level]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+40), CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]+5;
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+40), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                
                NSString* myString =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kcourse_level]];
                
                NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString:myString];
                
                
                [tempString addAttributes:@{NSFontAttributeName : kDefaultFontForTextFieldMeium,
                                            NSForegroundColorAttributeName : [UIColor darkGrayColor]}
                                    range:NSMakeRange(0, myString.length)];
                cell.descLabel.attributedText = tempString;
                //cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kduration]  ];
                
                cell.iconImageView.image =[UIImage imageNamed:@"Clock"];
                
            }
            
        }
        
        
        
        
        
        return cell;
    }
    
    if (indexPath.section == 4){
        
        /* static NSString *cellIdentifier = @"cell";
         
         UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
         if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.font = [UIFont systemFontOfSize:14];
         cell.textLabel.textColor = [UIColor colorWithRed:121.0f/255.0f green:138.0f/255.0f blue:152.0f/255.0f alpha:1.0];
         cell.textLabel.numberOfLines = 2;
         
         
         if (indexPath.row==0) {
         cell.imageView.image = [UIImage imageNamed:@"Clock"];
         cell.textLabel.text = [NSString stringWithFormat:@"Submission Deadline : %@",[courseDetailDictioanry valueForKey:kprocessing_time]];
         }*/
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        cell.iconImageView.image =[UIImage imageNamed:@"Clock"];
        
        if (indexPath.row ==0) {
            
            if (![[courseDetailDictioanry valueForKey:kprocessing_time] isKindOfClass:[NSNull class]]) {
                cell.headinLabel.text = @"Submission Deadline :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Submission Deadline :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Submission Deadline :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kprocessing_time]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kprocessing_time]  ];
                
                
                
            }
            
        }
        return cell;
    }
    
    else if (indexPath.section == 5){
        
        /*static NSString *cellIdentifier = @"cell";
         
         UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
         if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.font = [UIFont systemFontOfSize:14];
         cell.textLabel.textColor = [UIColor colorWithRed:121.0f/255.0f green:138.0f/255.0f blue:152.0f/255.0f alpha:1.0];
         cell.textLabel.numberOfLines = 2;
         
         cell.imageView.image = [UIImage imageNamed:@"Calendar"];
         
         
         
         if ([[courseDetailDictioanry valueForKey:kintake] count]>0) {
         
         cell.textLabel.text = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:kintake] objectAtIndex:indexPath.row]valueForKey:kmessage]  value:@""]];
         
         
         }
         return  cell;*/
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        cell.iconImageView.image =[UIImage imageNamed:@"Calendar"];
        
        if ([[courseDetailDictioanry valueForKey:kintake] count]>0) {
            cell.headinLabel.text = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:kintake] objectAtIndex:indexPath.row]valueForKey:kmessage]  value:@""]];
            CGRect lblFrame1 =cell.headinLabel.frame;
            lblFrame1.size.width =[Utility getTextWidth:[NSString stringWithFormat:@"%@",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:kintake] objectAtIndex:indexPath.row]valueForKey:kmessage]  value:@""]] size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell.headinLabel.frame= lblFrame1;
            cell.headingWidthConstant.constant = [Utility getTextWidth:[NSString stringWithFormat:@"%@",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:kintake] objectAtIndex:indexPath.row]valueForKey:kmessage]  value:@""]] size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            /*  float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kprocessing_time]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
             if(hight<30)
             hight=30;
             
             cell.descHeightConstant.constant = hight;
             
             CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
             
             cell.descLabel.frame=lblFrame;
             cell.descLabel.numberOfLines=0;
             cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
             //[cell.descLabel sizeToFit];
             cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kprocessing_time]  ];*/
            cell.descLabel.hidden=YES;
        }
        
        return cell;
        
        
    }
    
    else if (indexPath.section == 6){
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        cell.iconImageView.image =[UIImage imageNamed:@"Calendar"];
        cell.iconImageView.hidden = YES;
        cell.imageWidth.constant = 0;
        cell.imageX_Axis.constant = 0;
        cell.headingLaelX_Axis.constant = 0;
        if ([[courseDetailDictioanry valueForKey:ktimeline] count]>0) {
            
            cell.headinLabel.text = [NSString stringWithFormat:@"%@ :",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kName]  value:@""]];
            
            CGRect lblFrame1 =cell.headinLabel.frame;
            
            lblFrame1.origin.x = 14;
            lblFrame1.size.width =[Utility getTextWidth:[NSString stringWithFormat:@"%@ :",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kName]  value:@""]] size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            
            cell.headinLabel.frame= lblFrame1;
            
            CGFloat lblWidth = [Utility getTextWidth:[NSString stringWithFormat:@"%@ :",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kName]  value:@""]] size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            
            cell.headingWidthConstant.constant = lblWidth;
            
            
            float hight = [Utility getTextHeight:[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kValue]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
            
            if(hight<30)
                hight=30;
            
            cell.descHeightConstant.constant = hight;
            
            CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
            
            cell.descLabel.textAlignment = NSTextAlignmentRight;
            cell.descLabel.frame=lblFrame;
            cell.descLabel.numberOfLines=0;
            cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
            //[cell.descLabel sizeToFit];
            cell.descLabel.text =[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kValue];
            
        }
        return cell;
        
    }
    
    static NSString *cellIdentifier  =@"descriptionCell";
    CourseDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CourseDescriptionCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section ==0) {
        cell.headerLabel.text = @"Description";
        
        if (![[Utility replaceNULL:[courseDetailDictioanry valueForKey:kdescription] value:@""] isEqualToString:@""]) {
            
            [cell.contentView addSubview:webview];
        }
        
    }
    
    else if (indexPath.section== 7){
        
        cell.headerLabel.text = @"Eligibility";
        NSString *description =  [courseDetailDictioanry valueForKey:keligibility_domestic_student];
        
        // Eligibility Domestic Student
        if (![description isKindOfClass:[NSNull class]]) {
            cell._descriptionLabelHeight.constant = [Utility getTextHeight:description size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell._descriptionLabel.text = description;
        }
        
    }
    else if (indexPath.section== 8){
        
        cell.headerLabel.text = @"Other Requirements";
        NSString *other = [courseDetailDictioanry valueForKey:kother_admission_requirement];
        
        // Other  Admission Requirement
        if (![other isKindOfClass:[NSNull class]]) {
            cell._descriptionLabelHeight.constant = [Utility getTextHeight:other size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell._descriptionLabel.text = other;
        }
        
    }
    else if (indexPath.section== 9){
        
        cell.headerLabel.text = @"Special Application Instructions";
        NSString *special = [courseDetailDictioanry valueForKey:kspecial_appl_instructions];
        
        // Special Appl Instructions
        
        if (![special isKindOfClass:[NSNull class]]) {
            cell._descriptionLabelHeight.constant = [Utility getTextHeight:special size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell._descriptionLabel.text = special;
        }
    }
    return  cell;
}

#pragma  mark - Collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_videoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionview cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    VideoCell *cell = [coursVideoCollectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    
    [cell.cellTopButton addTarget:self action:@selector(cellTopButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.cellTopButton.tag = indexPath.row;
    
    
    
    NSString *str = [self extractYoutubeIdFromLink:[[_videoArray objectAtIndex:indexPath.row] valueForKey:kvideos_url]];
    
    if (str.length>0) {
        [cell.playerView loadWithVideoId:str];
    }
    
    if (![str isKindOfClass:[NSNull class]]) {
        
//          NSString *videoUrl = [[[courseDetailDictioanry valueForKey:kvideos_url] objectAtIndex:indexPath.row] valueForKey:kvideos_url];
        
        NSString *videoUrl = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",str];
        
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:videoUrl] placeholderImage:[UIImage imageNamed:@"banner"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            NSLog(@"%@",error);
        }];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self addVideo:(int)indexPath.row];
}

-(void)cellTopButton_clicked:(UIButton *)sender{
    
    [self addVideo:(int)sender.tag];
}

-(NSString*)convertHtmlPlainText:(NSString*)HTMLString{
    
    NSData *HTMLData = [HTMLString dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:HTMLData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:NULL error:NULL];
    NSString *plainString = attrString.string;
    return plainString;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - Button delegate

- (IBAction)backButton_clicked:(id)sender {
    NSArray *navigation = [self.navigationController viewControllers];
    UIView *view = [navigation objectAtIndex:navigation.count-2];
    
    
    if([view isKindOfClass:[UNKCourseViewController class]])
    {
        [kUserDefault setValue:@"yes" forKey:@"showHudCousrseDetail"];
        [kUserDefault setValue:@"yes" forKey:@"showHudCousrseDetailForCell"];
        [kUserDefault valueForKey:@"showHudCousrseDetailForCell"];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)videoButton_clicked:(id)sender {
    
    [self addVideo:0];
}

- (IBAction)applyButton_clicked:(id)sender {
    
//    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    BOOL globalApplicationForm = [[kUserDefault valueForKey:kisGlobalFormCompleted] boolValue];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterSpellOutStyle];
    if(globalApplicationForm == YES)
    {
        if(_feePaidStatus ==NO )
        {
            
            if ([[[courseDetailDictioanry valueForKey:@"charges"] valueForKey:kapplication_fee] integerValue] ==0) {
            
                textMessage = [NSString stringWithFormat:@"Full %@ is refunded by the Institution in form of fee discount or cash or voucher, when you successfully enroll at any Institution applied using this App. You can apply up to %@ courses using this app and in case any of your application is rejected by an institution, it will not be counted in %@, so you can apply to another course or institution. This %@ fee is not refunded by UNICA.",_unica_fee,[f stringFromNumber:[NSNumber numberWithInt:_apply_limit]],[f stringFromNumber:[NSNumber numberWithInt:_apply_limit]],_unica_fee];
                
                subTitle = @"(100% Refundable/Cash back)";
                amount = [NSString stringWithFormat:@"One time Application Processing FEE : %@",_unica_fee];
                [self creatPopView];
            }
            else{
                
                [Utility showAlertViewControllerIn:self withAction:@"CANCEL" actionTwo:@"OK" title:@"" message:[NSString stringWithFormat:@"Application FEE for this course is : %@",[[courseDetailDictioanry valueForKey:@"charges"] valueForKey:kapplication_fee]] block:^(int index){
                    
                    if (index == 1) {
                        
                        textMessage = [NSString stringWithFormat:@"Full %@ is refunded by the Institution in form of fee discount or cash or voucher, when you successfully enroll at any Institution applied using this App. You can apply up to %@ courses using this app and in case any of your application is rejected by an institution, it will not be counted in %@, so you can apply to another course or institution. This %@ fee is not refunded by UNICA.",self.unica_fee,[f stringFromNumber:[NSNumber numberWithInt:_apply_limit]],[f stringFromNumber:[NSNumber numberWithInt:_apply_limit]],self.unica_fee];
                        
                        subTitle = @"(100% Refundable/Cash back)";
                        amount = [NSString stringWithFormat:@"One time Application Processing FEE : %@",self.unica_fee];
                        [self creatPopView];
                    }
                }];
            
            }
            
            
            
        }
        else
        {
            if(_applied_count<=_apply_limit)
            {
                if (_apply_limit-_applied_count == 0) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:@"You have exceeded the limit of application allowance on your account." block:^(int index){}];
                    
                }
                else{
                     if ([[[courseDetailDictioanry valueForKey:@"charges"] valueForKey:kapplication_fee] integerValue] >0)
                     {
                         [Utility showAlertViewControllerIn:self withAction:@"CANCEL" actionTwo:@"OK" title:@"" message:[NSString stringWithFormat:@"Application FEE for this course is : %@",[[courseDetailDictioanry valueForKey:@"charges"] valueForKey:kapplication_fee]] block:^(int index){
                             
                             if (index == 1) {
                                 
                                 NSString * course;
                                 if(_apply_limit-_applied_count<2)
                                 {
                                     course=@"course";
                                 }
                                 else
                                 {
                                     course=@"courses";
                                 }
                                 [Utility showAlertViewControllerIn:self withAction:@"No" actionTwo:@"YES" title:@"" message:[NSString stringWithFormat:@"Are you sure, You want to apply for this course, you can apply for %ld more %@",_apply_limit-_applied_count,course] block:^(int index){
                                     
                                     if (index == 1) {
                                         
                                           [kUserDefault setValue:self.selectedCourseDictionary forKey:kPaymentInfoDict];
                                         
                                         NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                                         for (UIViewController *aViewController in allViewControllers)
                                         {
                                             
                                             if ([aViewController isKindOfClass:[UNKWebViewController  class]])
                                                 
                                             {
                                                 [self.navigationController popToViewController:aViewController animated:NO];
                                             }
                                             else if  ([aViewController isKindOfClass:[UNKHomeViewController class]]){
                                                 
                                                 self.navigationController.navigationBarHidden = NO;
                                                 UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                                 UNKQuestionnaireViewController *questionnaireViewController = [storyBoard instantiateViewControllerWithIdentifier:@"QuestionnaireViewController"];
                                                 questionnaireViewController.isAlreadyPay = true;
                                                 [self.navigationController pushViewController:questionnaireViewController animated:YES];
                                             }
                                         }
                                         
                                     }
                                     
                                     
                                 }];
                             }
                         }];
                     }
                    else
                    {
                        NSString *course;
                        if(_apply_limit-_applied_count<2)
                        {
                            course=@"course";
                        }
                        else
                        {
                            course=@"courses";
                        }
                        [Utility showAlertViewControllerIn:self withAction:@"No" actionTwo:@"YES" title:@"" message:[NSString stringWithFormat:@"Are you sure, You want to apply for this course, you can apply for %ld more %@",_apply_limit-_applied_count,course] block:^(int index){
                            
                            if (index == 1) {
                                
                                [kUserDefault setValue:self.selectedCourseDictionary forKey:kPaymentInfoDict];
                                
                                NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                                for (UIViewController *aViewController in allViewControllers)
                                {
                                    
                                    if ([aViewController isKindOfClass:[UNKWebViewController  class]])
                                        
                                    {
                                        [self.navigationController popToViewController:aViewController animated:NO];
                                    }
                                    else if  ([aViewController isKindOfClass:[UNKHomeViewController class]]){
                                        
                                        self.navigationController.navigationBarHidden = NO;
                                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                        UNKQuestionnaireViewController *questionnaireViewController = [storyBoard instantiateViewControllerWithIdentifier:@"QuestionnaireViewController"];
                                        questionnaireViewController.isAlreadyPay = true;
                                        [self.navigationController pushViewController:questionnaireViewController animated:YES];
                                    }
                                }
                                
                            }
                            
                            
                        }];
                    }
                   
                }
                
                
            }
        }
        
    }
    else
    {
        
        
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please fill Global Application form" block:^(int index) {
            
            [kUserDefault setValue:@"yes" forKey:@"searchCourese"];
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"GAF" bundle:[NSBundle mainBundle]];
            GlobalApplicationStep1ViewController *globalApplicationStep1ViewController = [storyBoard instantiateViewControllerWithIdentifier:@"GAFStepp1StoryboardID"];
            [self.navigationController pushViewController:globalApplicationStep1ViewController animated:YES];
            
        }];
        
    }

}

- (IBAction)likeButton_clicked:(id)sender {
    [self courseLike:self.selectedCourseDictionary];
}



#pragma  mark video player delegate

-(void)addVideo:(int)index{
   
    if([[courseDetailDictioanry valueForKey:kvideos_url] count]>0)
    {
        videoLabel.text = [[[courseDetailDictioanry valueForKey:kvideos_url] objectAtIndex:index] valueForKey:ktitle];
        if ([[courseDetailDictioanry valueForKey:kvideos_url] count]>0) {
            NSString *videoUrl = [[[courseDetailDictioanry valueForKey:kvideos_url] objectAtIndex:index] valueForKey:kvideos_url];
            NSString *str = [self extractYoutubeIdFromLink:videoUrl];
            
            ytPlayerView.delegate = self;
            if (str.length>0) {
                [ytPlayerView loadWithVideoId:str];
            }
        }
    }
    else{
        
        videoButtonHeight.constant = 0;
        playerViewHeight.constant = 0;
       collectionViewHeight.constant = 0;
        
        _fooderView.frame = CGRectMake(0, 0, kiPhoneWidth, 70);
        _courseDetailTable.tableFooterView = _fooderView;
    }
    
    
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
    isInfoClicked = NO;

    
    [self makePayment];
    [kUserDefault setValue:self.selectedCourseDictionary forKey:kPaymentInfoDict];
    
    NSLog(@"OK");
}

-(void)cancelButton_Clicked:(UIButton*)sender{
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
    isInfoClicked = NO;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
}

#pragma  make payment
-(void)makePayment
{
    self.navigationController.navigationBarHidden=YES;
    
    [kUserDefault setValue:kcourseDetailsViewController forKey:kFromView];

    
    float price = 50.00;
    
    //Merchant has to configure the below code
    
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

    
    // save paymenttype
    
    [kUserDefault setObject:kcourses forKey:kPaymentModeType];
    [self.navigationController pushViewController:paymentView animated:NO];
}

- (IBAction)institudeDetailsButton_clicked:(id)sender {
    
    [self getInstitudeDetails:self.selectedCourseDictionary];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
    NSLog(@"%@",webview.scrollView);
    
    CGRect frame = webview.frame;
    NSString *heightStrig = [webView stringByEvaluatingJavaScriptFromString:@"(document.height !== undefined) ? document.height : document.body.offsetHeight;"];
    float height = heightStrig.floatValue + 10.0;
    frame.size.height = height;
    webview.frame = frame;
    
    [_courseDetailTable reloadData];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kInstitudeSegueIdentifer]) {
        UNKInstitudeViewController *institudeViewController = segue.destinationViewController;
        institudeViewController.institudeDictionary = sender;
        
    }
}

@end
