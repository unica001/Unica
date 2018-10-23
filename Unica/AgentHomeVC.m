//
//  AgentHomeVC.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "AgentHomeVC.h"
#import "AddBusinessCardVC.h"
#import "QRCodeScanViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddBusinessCardVC.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AddEventPopUp.h"
#import "NSDate+Utilities.h"

@interface AgentHomeVC ()
{
       NSMutableArray *_bannerArr,*imageBannerArr ,*textBannerArr ,*imageArr ,*titleArr ,*desArray,*imageArrayOfUrl,*navigationArr ;
    NSMutableDictionary *loginDictionary;
    UIImage *cardimg;
    NSMutableDictionary *dictEventDetail;
    TPKeyboardAvoidingScrollView *overlayView;
    AddEventPopUp *popView;
    GKActionSheetPicker *picker;
    NSString *strEndDate;
    UITextField *txtFieldEndDate;
    NSString *strMsg;
    
    NSArray *eventArray;
    NSArray *selectedEventArray;
    NSMutableArray *userList;

}

@end

@implementation AgentHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewEvent.layer.cornerRadius = 2;
    viewEvent.layer.masksToBounds = true;
   
    [self currentLocationIdentifier];
    [self getbanner];
    [self getEventDetail];
    [self loginUserAndConnectToChat];

    // google analytics
    [GAI sharedInstance].dispatchInterval = 0;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    
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
    
    [self getEventList];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self getEventID];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARK - Connect To Quickblox
-(void)loginUserAndConnectToChat{
    
    // login user
    if([Utility connectedToInternet])
    {
        
        NSString *userId = [NSString stringWithFormat:@"user_%@",[loginDictionary valueForKey:Kid]];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];

        [QBRequest logInWithUserLogin:userId password:kTestUsersDefaultPassword successBlock:^(QBResponse *response, QBUUser *user) {
            
            __weak typeof(self) weakSelf = self;
            [weakSelf registerForRemoteNotifications];
            
            // Connect user to chat
            [[QBChat instance] connectWithUser:user resource:@"iPhone6s" completion:^(NSError * _Nullable error) {
                
            }];

        } errorBlock:^(QBResponse *response) {
            
            [Utility hideMBHUDLoader];
            [Utility showAlertViewControllerIn:self title:@"Error" message:[response.error  description] block:^(int index){}];
        }];
    }
}

-(void)creatUserOnQuickBlock:(NSDictionary*)loginInfo{
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    QBUUser *user = [QBUUser new];
//    user.externalUserID = [userId integerValue];
    user.fullName = [NSString stringWithFormat:@"%@",[loginInfo valueForKey:kName]];
    user.phone = [loginInfo valueForKey:kMobileNumber];
    user.login = [NSString stringWithFormat:@"user_%@",userId];
    user.password = kTestUsersDefaultPassword;
    
    // check QBID
 if (![loginInfo valueForKey:kQbId] || [[loginInfo valueForKey:kQbId] isKindOfClass:[NSNull class]] || [[loginInfo valueForKey:kQbId] isEqualToString:@""]) {
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user)
         {
             [Utility hideMBHUDLoader];
             NSString *newUserQBID = [NSString stringWithFormat:@"%lu",(unsigned long)user.ID];
             [self saveQBID:newUserQBID];
         }
         
               errorBlock:^(QBResponse *response) {
                   
//                   [Utility hideMBHUDLoader];
//                   [Utility showAlertViewControllerIn:self title:@"Error" message:[response.error  description] block:^(int index){
//                   }];
               }];
    }
    else{
        [self saveQBID:[loginInfo valueForKey:kQbId]];

    }
   
   
    /*else{
        
        // login user and update info
        [QBRequest logInWithUserLogin:[NSString stringWithFormat:@"user_%@",[loginInfo valueForKey:kUser_id]] password:kTestUsersDefaultPassword successBlock:^(QBResponse *response, QBUUser *user) {
            
            NSString *newUserQBID = [NSString stringWithFormat:@"%lu",(unsigned long)user.ID];

            // update user info
            
            QBUpdateUserParameters *updateParameters = [QBUpdateUserParameters new];
            updateParameters.phone = [loginInfo valueForKey:kMobileNumber];
            updateParameters.fullName = [NSString stringWithFormat:@"%@ %@",[loginInfo valueForKey:kfirstname],[loginInfo valueForKey:klastname]];
            
            [QBRequest updateCurrentUser:updateParameters successBlock:^(QBResponse *response, QBUUser *user) {
                [Utility hideMBHUDLoader];
                
            }
                              errorBlock:^(QBResponse *response)
             {
                 [Utility hideMBHUDLoader];
                 
                 [Utility showAlertViewControllerIn:self title:@"Error" message:[response.error  description] block:^(int index){}];
             }];
            
        } errorBlock:^(QBResponse *response) {
            
            [Utility hideMBHUDLoader];
            [Utility showAlertViewControllerIn:self title:@"Error" message:[response.error  description] block:^(int index){}];
        }];
    }*/
}

#pragma  Mark Handel Push Notification


- (void)registerForRemoteNotifications {
    
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |
                                                  UIUserNotificationTypeAlert |
                                                  UIUserNotificationTypeBadge)
                                      categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}




- (void)getAllUser {
    
    [Utility ShowMBHUDLoader];
    QBGeneralResponsePage *page = [QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10];
    
    [QBRequest usersForPage:page successBlock:^(QBResponse *response, QBGeneralResponsePage *pageInformation, NSArray *users) {
        
        NSLog(@"%@",users);
        if(users.count>0)
        {
            NSInteger currentTimeInterval = [[NSDate date] timeIntervalSince1970];
            NSInteger userLastRequestAtTimeInterval   = [[[users objectAtIndex:0] lastRequestAt] timeIntervalSince1970];
            
            NSLog(@"%@",[users objectAtIndex:0]);
            // if user didn't do anything last 5 minutes (5*60 seconds)
            if((currentTimeInterval - userLastRequestAtTimeInterval) > 5*60){
                // user is offline now
            }
            
            userList = [NSMutableArray arrayWithArray:users];
            
        }
        
        
    } errorBlock:^(QBResponse *response) {
        [Utility hideMBHUDLoader];
        
    }];
    
}

#pragma mark - Navigation




-(void)BannerServerFinishedWithSuccessMessage
{
    //    _bannerArr = [[NSMutableArray alloc] initWithArray:dataArray];
    imageBannerArr = [[NSMutableArray alloc] init];
    textBannerArr = [[NSMutableArray alloc] init];
    imageArr = [[NSMutableArray alloc] init];
    titleArr = [[NSMutableArray alloc] init];
    desArray= [[NSMutableArray alloc] init];
    imageArrayOfUrl = [[NSMutableArray alloc] init];
    navigationArr = [[NSMutableArray alloc] init];

    [self loadImages];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
                   {
                       
                       dispatch_sync(dispatch_get_main_queue(), ^(void)
                                     {
                                         [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeBannerImage) userInfo:nil repeats:YES];
                                     });
                   });
    //[_mainScrollView reloadData];
}

#pragma  mark -  change banner image

-(void)changeBannerImage
{
    if (i>=0 && _bannerArr.count>0) {
        
        int j = i % (_bannerArr.count);
        pageControl.currentPage = j;
        [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.frame.size.width*j,0) animated:YES];
        i++;
    }
}
-(void)loadImages
{
    int scrollWidth=0;
    
    NSArray *subViews = _mainScrollView.subviews;
    
    for(UIView *view in subViews){
        [view removeFromSuperview];
    }
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:app.window animated:YES];
    });
    
    pageControl.numberOfPages = [_bannerArr count];
    for ( i=0;i<_bannerArr.count;i++)
    {
        UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(scrollWidth,0,kiPhoneWidth,_mainScrollView.frame.size.height)];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        imageView1.backgroundColor = [UIColor whiteColor];
        activityIndicator.center = imageView1.center;
        [activityIndicator startAnimating];
        [_mainScrollView addSubview:activityIndicator];
        
        
        NSString *url  = [[_bannerArr objectAtIndex:i]valueForKey:@"banner_url"];
        
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRefreshCached];
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapGuesture:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        [imageView1 addGestureRecognizer:singleTap];
        
        imageView1.userInteractionEnabled = YES;
        
        [_mainScrollView addSubview:imageView1];
        scrollWidth=scrollWidth+kiPhoneWidth;
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:app.window animated:YES];
        });
    }
    
    [_mainScrollView setContentSize:CGSizeMake(scrollWidth, _mainScrollView.frame.size.height)];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        
        _indexOfPage =    floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        pageControl.currentPage = _indexOfPage;
    }
}

-(void)hideLeftAndRightButtonsOnScrollView{
    
    if (_mainScrollView) {
        
        int offset=_mainScrollView.contentOffset.x/_mainScrollView.frame.size.width;
        
        if (offset==0&&(_bannerArr.count>1)) {
            [self rightButton_Clicked:nil];
        }else if ((offset+1)==_bannerArr.count){
            
            [self leftButton_Clicked:nil];
        }
    }
    
}


#pragma mark - Button _Clicked
-(void)leftButton_Clicked:(UIButton *)sende{
    
    if (_mainScrollView.contentOffset.x != 0) {
        
        [_mainScrollView setContentOffset:CGPointMake(-kiPhoneWidth+_mainScrollView.contentOffset.x, 0) animated:YES];
        
        //    int count = (_mainScrollView.contentOffset.x - kiPhoneWidth) / kiPhoneWidth;
        
    }
    
}
-(void)rightButton_Clicked:(UIButton *)sende{
    
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        [_mainScrollView setContentOffset:CGPointMake(kiPhoneWidth+_mainScrollView.contentOffset.x, 0) animated:YES];
        
        
    }
    
    
}


-(void)getbanner{
    
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"dashboard-banners.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
//                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    _bannerArr = [dictionary valueForKey:kAPIPayload];
                    
                    [self loadImages];
                    ;
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
                                   {
                                       
                                       dispatch_sync(dispatch_get_main_queue(), ^(void)
                                                     {
                                                         [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeBannerImage) userInfo:nil repeats:YES];
                                                     });
                                   });
                    
                    
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
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


-(void)imageTapGuesture:(UITapGestureRecognizer *)tapGuesture{
    
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        
        int index =    floor((_mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) +1;
        
        if([Utility replaceNULL:[[_bannerArr objectAtIndex:index] valueForKey:@"link_url"] value:@""].length>0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_bannerArr objectAtIndex:index] valueForKey:@"link_url"]]]];
        }
    }
    else
    {
        if([Utility replaceNULL:[[_bannerArr objectAtIndex:0] valueForKey:@"link_url"] value:@""].length>0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_bannerArr objectAtIndex:0] valueForKey:@"link_url"]]]];
        }
    }
    
}
- (IBAction)bannerButton_Click:(id)sender {
    
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        
        int index =    floor((_mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) +1;
        
        if([Utility replaceNULL:[[_bannerArr objectAtIndex:index] valueForKey:@"link_url"] value:@""].length>0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_bannerArr objectAtIndex:index] valueForKey:@"link_url"]]]];
        }
    }
    else
    {
        if([Utility replaceNULL:[[_bannerArr objectAtIndex:0] valueForKey:@"link_url"] value:@""].length>0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_bannerArr objectAtIndex:0] valueForKey:@"link_url"]]]];
        }
    }
}

- (IBAction)businesscard_ButtonAction:(id)sender {
    [self showCamera];
//    [self performSegueWithIdentifier:KScanBusinessCardScanner sender:nil];
}

- (IBAction)qrCode_ButtonAction:(id)sender {
    [self performSegueWithIdentifier:KScanQrCode sender:nil];
}

- (IBAction)tapAddChangeEvent:(UIButton *)sender {
    [self addEventOverlay];
}

- (IBAction)eventButtonAction:(id)sender {
    
    NSMutableArray *filtredArray =(NSMutableArray*)[eventArray valueForKey:@"event_name"];
    
    self.picker = [GKActionSheetPicker stringPickerWithItems:filtredArray selectCallback:^(id selected) {
    
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"event_name=%@",selected];
            self.basicCellSelectedString = (NSString *)selected;

        selectedEventArray = [eventArray filteredArrayUsingPredicate:predicate];
        
        if ([selectedEventArray[0][@"event_name"] isEqualToString:@"Other"]){
            [self addEventOverlay];
        }
        else {
            if (dictEventDetail == nil) {
                dictEventDetail = [[NSMutableDictionary alloc] init];
            }
            dictEventDetail[@"name"] = selectedEventArray[0][@"event_name"];
            dictEventDetail[@"end_date"] =  selectedEventArray[0][@"scheduled_date"];
            dictEventDetail[@"event_id"] = selectedEventArray[0][@"event_id"];
            [self apiCallToAddUpdateEvent];
        }
        } cancelCallback:nil];
    
        self.picker.title = @"Select Event";
        [self.picker presentPickerOnView:self.view];
        [self.picker selectValue:self.basicCellSelectedString];
}

-(IBAction)calenderAction:(id)sender{
    [popView.txtFieldEvent resignFirstResponder];
    picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:0] to:[NSDate dateWithTimeIntervalSinceNow:(365*24*60*60)] interval:5
                                               selectCallback:^(id selected) {
                                                   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                   [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                                                   // [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                                                   NSString *selectedDate = [dateFormatter stringFromDate:selected];
                                                   
                                                   txtFieldEndDate.text = [NSString stringWithFormat:@"%@", selectedDate];
                                                   
                                                   NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                                   [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                                                   strEndDate = [dateFormatter2 stringFromDate:selected];
                                                   
                                               } cancelCallback:^{
                                               }];
        
    picker.title = @"Event End Date";
    [picker presentPickerOnView:self.view];
}

-(IBAction)submitAction:(id)sender{
    [self.view endEditing:true];
    
    if([self Validation]) {
        [overlayView removeFromSuperview];
        if (dictEventDetail == nil) {
            dictEventDetail = [[NSMutableDictionary alloc] init];
        }
        dictEventDetail[@"name"] = popView.txtFieldEvent.text;
        dictEventDetail[@"end_date"] = strEndDate;

        [self apiCallToAddUpdateEvent];
    } else {
        popView.lblMsg.text = strMsg;
    }
}

-(IBAction)cancelAction:(id)sender {
    [overlayView removeFromSuperview];
}

#pragma mark - Private Methods

- (void)currentLocationIdentifier {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 100;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}


- (void)addEventOverlay {
    overlayView =[[TPKeyboardAvoidingScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    overlayView.layer.cornerRadius = 5;
    
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"AddEventPopUp" owner:self options:nil];
    
    popView = [nibArray objectAtIndex:0];
    popView.frame = CGRectMake(10, (kiPhoneHeight/2)-90,kiPhoneWidth-20, 160);
    popView.layer.cornerRadius = 5;
    popView.clipsToBounds = YES;
    popView.viewEndDate.layer.cornerRadius = 3;
    popView.viewEndDate.layer.borderWidth = 1;
    popView.viewEndDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    popView.viewEvent.layer.cornerRadius = 3;
    popView.viewEvent.layer.borderWidth = 1;
    popView.viewEvent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    popView.txtFieldEvent.delegate = self;
    [popView.btnTemplate setHidden:YES];
    
    CGRect frame2 = CGRectMake(kiPhoneWidth/2 + 5, 40, kiPhoneWidth/2-48, 40);
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    txtFieldEndDate = [Control newTextFieldWithOptions:optionDictionary frame:frame2 delgate:self];
    txtFieldEndDate.placeholder = @"End Date";
    txtFieldEndDate.textAlignment = NSTextAlignmentLeft;
    txtFieldEndDate.textColor = [UIColor darkGrayColor];
    txtFieldEndDate.userInteractionEnabled = false;
    txtFieldEndDate.font = kDefaultFontForTextField;
    
    [popView addSubview:txtFieldEndDate];
    [popView.btnCalender addTarget:self action:@selector(calenderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [popView.btnCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [popView.btnOk addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [overlayView addSubview:popView];
    
    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
    [self.window addSubview:overlayView];
}

-(BOOL)Validation{
    if (![Utility validateField:popView.txtFieldEvent.text]) {
//        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please enter event name" block:^(int sum) {
//
//        }];
        strMsg = @"Please enter event name";
        return false;
    } else if (![Utility validateField:txtFieldEndDate.text]) {
//        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select event end date" block:^(int sum) {
//
//        }];
        strMsg = @"Please select event end date";
        return false;
    } else if(![Utility connectedToInternet]) {
//        [Utility showAlertViewControllerIn:self title:@"" message:@"Please check internet connection" block:^(int index){
//
//        }];
        strMsg = @"Please check internet connection";
        return false;
    }
    return true;
}

- (void)showCamera {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Set Profile Picture" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Upload from Gallery" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:^{}];
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Camera Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //[_profileButton setBackgroundImage:image forState:UIControlStateNormal];
    
    // _profileImage.image = image;
    CGRect rect = CGRectMake(0,0,200,200);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
//    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   // isImageUploaded= true;
    //cardImageView.image = picture1;
    cardimg =image;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self presentCropViewController];
    //     [self getCarddetailDic];
    
}
- (void)presentCropViewController
{
    UIImage *image = cardimg; //Load an image
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
    cropViewController.delegate = self;
    
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    cardimg =[Utility compressImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self getCarddetailDic:image];
    [self getCarddetailDic:[Utility compressImage:image]];
    // 'image' is the newly cropped version of the original image
}
-(void)getCarddetailDic:(UIImage*)img{
    
    //NSMutableDictionary *resultsDictionary;
    dispatch_async( dispatch_get_main_queue(), ^{
        
        [Utility ShowMBHUDLoader];
    });
    NSData *imageData = UIImagePNGRepresentation(img);
    NSString *encodedString= [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    
    [userDictionary setValue:encodedString forKey:@"image"];
    
    //    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"first title", @"title",@"1",@"blog_id", nil];//if your json structure is something like {"title":"first title","blog_id":"1"}
    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {//validate it
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
        NSURL* url = [NSURL URLWithString:@"http://103.91.90.242/cloud-api"];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];//use POST
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:jsonData];//set data
        __block NSError *error1 = [[NSError alloc] init];
        
        //use async way to connect network
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse* response,NSData* data,NSError* error)
         {
             if ([data length]>0 && error == nil) {
                 NSMutableDictionary * resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [Utility hideMBHUDLoader];
                     if(resultsDictionary.count>0)
                     {
                         //[self setdetailDic:resultsDictionary];
                         [self performSegueWithIdentifier:KScanBusinessCardScanner sender:resultsDictionary];
                     }
                 });
                 
                 NSLog(@"resultsDictionary is %@",resultsDictionary);
                 
             } else if ([data length]==0 && error ==nil) {
                 NSLog(@" download data is null");
             } else if( error!=nil) {
                 NSLog(@" error is %@",error);
             }
         }];
    }
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //if dictEventdetail is nil sent location otherwise send event detail
    if([segue.identifier isEqualToString:KScanBusinessCardScanner])
    {
        AddBusinessCardVC *controller = segue.destinationViewController;
        controller.carddetailDictionary = sender;
        controller.compressedcardImage = cardimg;
        controller.eventName = [dictEventDetail valueForKey:@"name"];
    } else if ([segue.identifier isEqualToString:KScanQrCode]) {
        QRCodeScanViewController *controller = segue.destinationViewController;
        controller.eventName = [dictEventDetail valueForKey:@"name"];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - UILocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    
//    self.lat = (double) currentLocation.coordinate.latitude;
//    self.lon = (double)  currentLocation.coordinate.longitude;
    
//    if (geocoder) {
//        [geocoder cancelGeocode];
//    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             //             NSString *area = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
             //             NSString *nameString = [placemark.addressDictionary valueForKey:@"Name"];
             NSString *city = [placemark.addressDictionary objectForKey:@"City"];
//             NSString *country = [placemark.addressDictionary objectForKey:@"Country"];
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
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    self.lat = 0;
//    self.lon = 0;
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
    [self currentLocationIdentifier];
}

#pragma mark - API Call

-(void)getEventList{
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-events.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    eventArray = [[dictionary valueForKey:kAPIPayload] valueForKey:@"events"];
                }
            });
        }
    }];
}

-(void)getEventID{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-mandatory-status.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:false showSystemError:false completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    app.userEventId =  dictionary[kAPIPayload][kevent_id];
                    app.menuArray = dictionary[kAPIPayload][@"menus"];
                    app.webLoginUrl = dictionary[@"login_url"];
                   [self creatUserOnQuickBlock:loginDictionary];

                }
            });
        }
    }];
}

-(void)saveQBID:(NSString *)qbid{
    
    NSMutableDictionary*dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:qbid forKey:kQbId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-save-chat-id.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:false showSystemError:false completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",dictionary);
                [dictLogin setValue:qbid forKey:kQbId];
                [kUserDefault setValue:[Utility archiveData:dictLogin] forKey:kLoginInfo];
                loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
   
            });
        }
    }];
}
- (void)getEventDetail {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:userId forKey:@"user_id"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"attending_event_view.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    NSArray *arrEvents = [payloadDictionary valueForKey:@"event"];
                    if (arrEvents.count > 0) {
                        if (dictEventDetail == nil) {
                            dictEventDetail = [[NSMutableDictionary alloc] init];
                        }
                        dictEventDetail = arrEvents[0];
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"yyyy-MM-dd"];
                        [dateFormat setLocale:[NSLocale currentLocale]];
                        NSDate *serverDate = [dateFormat dateFromString:dictEventDetail[@"end_date"]];
                        selectedEventLabel.text = dictEventDetail[@"name"];

                        if (![self compareDate:[NSDate date] serverDate:serverDate]) {
                            viewInEvent.hidden = true;
                            viewSelectEvent.hidden = true;
                        } else {
                            viewInEvent.hidden = true;
                            viewSelectEvent.hidden = true;
                            strEndDate = dictEventDetail[@"end_date"];
                        }
                    } else {
                        viewInEvent.hidden = true;
                        viewSelectEvent.hidden = true;
                    }
                } else {
                    viewInEvent.hidden = true;
                    viewSelectEvent.hidden = true;
                }
            });
        } else{
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


- (BOOL)compareDate:(NSDate *)current serverDate:(NSDate *)serverDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    
    NSDateComponents *date1Components = [calendar components:comps
                                                    fromDate: current];
    NSDateComponents *date2Components = [calendar components:comps
                                                    fromDate: serverDate];
    
    current = [calendar dateFromComponents:date1Components];
    serverDate = [calendar dateFromComponents:date2Components];
    
    NSComparisonResult result = [current compare:serverDate];
    if(result == NSOrderedAscending)
    {
        NSLog(@"current date is less");
        return true;
    }
    else if(result == NSOrderedDescending)
    {
        NSLog(@"server date is less");
        return false;
    }
    else if(result == NSOrderedSame)
    {
        NSLog(@"Both dates are same");
        return true;
    }
    
    else
    {
        NSLog(@"Date cannot be compared");
        return false;
    }
}

- (void)apiCallToAddUpdateEvent {
    NSLog(@"Event information %@", dictEventDetail);
    [overlayView removeFromSuperview];
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[dictEventDetail valueForKey:@"name"] forKey:@"name"];
    [dic setValue:[dictEventDetail valueForKey:@"end_date"] forKey:@"end_date"];
    [dic setValue:[dictEventDetail valueForKey:@"event_id"] forKey:@"event_id"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"attending_event.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    [self getEventDetail];
                }
                else {
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:@"Message"]  block:^(int index) {
                        
                    }];
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

@end
