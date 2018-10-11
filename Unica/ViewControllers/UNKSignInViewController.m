//
//  UNKSignInViewController.m
//  Unica
//
//  Created by vineet patidar on 01/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKSignInViewController.h"
#import "SignInCell.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UNKRegistrationViewController.h"
#import "MiniProfileStep1ViewController.h"


/* commented on 6 March by Krati @interface UNKSignInViewController ()<GPPSignInDelegate>*/
@interface UNKSignInViewController ()
@end

typedef enum
{   email = 0,
    password
    
} textFieldType;

@implementation UNKSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    //[[GIDSignIn sharedInstance] signInSilently];
    
    _infoDictionary = [[NSMutableDictionary alloc]init];
    
    // set initial layout
    [self setupInitialLayout];
    
    // direct login
    
    /* UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
     
     UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
     UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
     
     UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
     
     SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
     
     revealController.delegate = self;
     
     self.revealViewController = revealController;
     
     self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
     self.window.backgroundColor = [UIColor redColor];
     
     self.window.rootViewController =self.revealViewController;
     [self.window makeKeyAndVisible]; */
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

/****************************
 * Function Name : - setUPInitialLayout
 * Create on : - 02 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - In this function initilization all the basic control before screen load
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)setupInitialLayout{
    
    //Intialize Common Options for TextField
    
    CGRect frame = CGRectMake(10,25 , kiPhoneWidth-20, 30);
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
     [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeEmailAddress] forKey:kTextFeildOptionKeyboardType];
    
    //Setup  email Field
    [optionDictionary setValue:@"Email" forKey:kTextFeildOptionPlaceholder];
    _emailText = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    
    //Setup  password Field
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Password" forKey:kTextFeildOptionPlaceholder];
    _passwordText = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    _passwordText.returnKeyType = UIReturnKeyDone;
    
    
    [_webView loadHTMLString:@"<font face = 'arial'><span style='font-size:14px;text-align: center; color:#3B455D'><p>New user?<a href='' style='color:#FFFFFF;'> Click here to register now</a></p></span></font> " baseURL:nil];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    
}

#pragma mark - GPPSignInDelegate
/* commented on 6 March by Krati
 - (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
 error:(NSError *)error {
 [self refreshUserInfo];
 }
 
 - (void)didDisconnectWithError:(NSError *)error {
 
 [self refreshUserInfo];
 }
 */
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    NSString *userId = user.userID;                  // For client-side use only!
    // NSString *idToken = user.authentication.idToken; // Safe to send to the server
    // NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    
    CGSize thumbSize=CGSizeMake(300, 300);
    NSURL *imageURL;
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage){
        
        NSUInteger dimension = round(thumbSize.width * [[UIScreen mainScreen] scale]);
        imageURL = [user.profile imageURLWithDimension:dimension];
        NSLog(@"image url=%@",imageURL);
    }
    
    NSString *deviceToken = [kUserDefault valueForKey:kDeviceid];
    
    if (userId.length>0 && ![userId isKindOfClass:[NSNull class]]) {
        [_infoDictionary setObject:familyName forKey:klastname];
        [_infoDictionary setObject:givenName forKey:kfirstname];
        [_infoDictionary setObject:userId forKey:kSocialId];
        [_infoDictionary setObject:email forKey:kEmail];
        [_infoDictionary setObject:@"S" forKey:kRegister_type];
        [_infoDictionary setObject:@"G" forKey:kStype];
        [_infoDictionary setObject:[NSString stringWithFormat:@"%@",imageURL] forKey:kProfile_image];
        [_infoDictionary setValue:deviceToken forKey:kDeviceToken];
        [_infoDictionary setValue:@"I" forKey:kDeviceType];
        
        // check user already register or not
        [self checkUserAlreadyRegisterOrnot:_infoDictionary];
    }
    
    
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier3  =@"signIn";
    
    
    SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SignInCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == email) {
        [cell.textField removeFromSuperview];
        cell.textField = _emailText;
        [cell.contentView addSubview:cell.textField];
        
        cell.headerLabel.text = @"Email";
    }
    else  if (indexPath.row == password) {
        [cell.textField removeFromSuperview];
        cell.textField = _passwordText;
        cell.textField.secureTextEntry = true;
        [cell.contentView addSubview:cell.textField];
        
        cell.headerLabel.text = @"Password";
    }
    
   
    
    cell._imageView.hidden = YES;
    cell._imageViewWidth.constant = 0;
    
    
    //_passwordText.text = @"123456";
    //_emailText.text = @"test002@gmail.com";
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

#pragma mark - Text Field delegate

-(void)textFieldDidChange:(UITextField *)text{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _emailText) {
        [_passwordText becomeFirstResponder];
    }
    if (textField == _passwordText) {
        [_passwordText resignFirstResponder];
    }
    return YES;
}


#pragma mark - Webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        [self performSegueWithIdentifier:kRegistrationSegueIdentifier sender:nil];
        
        return NO;
    }
    return YES;
}

/****************************
 * Function Name : - validatePassword
 * Create on : - 2 march 2017
 * Developed By : -  Ramniwas
 * Description : -  This funtion are use for check validation in registration form
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (BOOL)validatePassword{
    
    if(![Utility validateField:_emailText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter your email" block:^(int index) {
            [_emailText becomeFirstResponder];
        }];
        return false;
    }
   else if(![Utility validateEmail:_emailText.text]){
       [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid email" block:^(int index) {
           [_emailText becomeFirstResponder];
       }];
       return false;
   }
    //    else  if(![Utility validateEmail:_emailText.text] ){
    //        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please enter valid email Id" block:^(int index) {
    //
    //        }];
    //        return false;
    //    }
    else if(![Utility validateField:_passwordText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter your password" block:^(int index) {
             [_passwordText becomeFirstResponder];
        }];
        return false;
    }
    
    /*else if(![Utility isValidPassword:_passwordText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please enter valid password. It must be a combination of alphanumeric characters and length should be between 6 to 15 character" block:^(int index) {
            
        }];
        return false;
    }*/
    
    return true;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;
    
    if ([segue.identifier isEqualToString:kRegistrationSegueIdentifier]) {
        UNKRegistrationViewController *registrationController = segue.destinationViewController;
        registrationController.infoDictionary = sender;
        
    }
    else if ([segue.identifier isEqualToString:kMPStep1SegueIdentifier]) {
        MiniProfileStep1ViewController *miniProfile = segue.destinationViewController;
        miniProfile.incomingViewType = sender;
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Google Logout
// If there is an option for Google Logout use this
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

#pragma mark - Button Clicked

- (IBAction)loginButton_clicked:(id)sender {
    
    if ([self validatePassword]) {
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        NSString *deviceToken = [kUserDefault valueForKey:kDeviceid];
        
        [dictionary setValue:_emailText.text forKey:Kusername];
        [dictionary setValue:_passwordText.text forKey:kPassword];
        [dictionary setValue:@"N" forKey:kRegister_type];
        [dictionary setValue:@"" forKey:kSocialId];
        [dictionary setValue:@"" forKey:kStype];
        [dictionary setValue:deviceToken forKey:kDeviceToken];
        [dictionary setValue:@"I" forKey:kDeviceType];
        [self login:dictionary];
    }
}

- (IBAction)googlePluseButton_clicked:(id)sender {
    
    NSError* configureError;
//    [[GGLContext sharedInstance] configureWithError: &configureError];
    
    NSLog(@"%@", configureError);
    
    [[GIDSignIn sharedInstance] signIn];
    
    
}

- (IBAction)forgotPasswordButton_clicked:(id)sender {
    
    [self performSegueWithIdentifier:kForgotPasswordSegueIdentifier sender:nil];
}

- (IBAction)fbLoginButton_Clicked:(id)sender {
    
    [_infoDictionary setValue:@"S" forKey:kRegister_type];
    [_infoDictionary setValue:@"F" forKey:kStype];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
             NSLog(@"%@,%@",result,error);
             [Utility showAlertViewControllerIn:self title:kErrorTitle message:@"Unable to process with facebook login please try later" block:^(int index) {
                 
             }];
             
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             NSLog(@"%@",result);
         } else {
             
             [self fetchFbInfo];
         }
     }];
}



/****************************
 * Function Name : - facebookButton_Clicked
 * Create on : - 3 march 2017
 * Developed By : -  Ramniwas Patidar
 * Description : - This fucntion fetches facebook profile information
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)fetchFbInfo{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,first_name,gender,last_name,picture.type(large)" forKey:@"fields"];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error){
         [Utility hideMBHUDLoader];
         
         if (!error) {
             NSLog(@"%@",result);
             [self getFBDate:result];
         }
         else{
             NSLog(@"%@",error);
         }
     }];
}

/****************************
 * Function Name : - getFBDate
 * Create on : - 3 march 2017
 * Developed By : -  Ramniwas Patidar
 * Description : - This fucntion are used for get FB date
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)getFBDate:(id)result{
    
    if (result[@"last_name"]) {
        [_infoDictionary setObject:result[@"last_name"] forKey:klastname];}
    
    if (result[@"first_name"]) {
        [_infoDictionary setObject:result[@"first_name"] forKey:kfirstname];}
    
    if (result[@"gender"]) {
        [_infoDictionary setObject:result[@"gender"] forKey:kGender];}
    
    NSString *url = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
    
    if (url) {
        [_infoDictionary setObject:url forKey:kProfile_image];}
    
    if (result[@"id"]) {
        [_infoDictionary setObject:result[@"id"] forKey:kSocialId];}
    
    if (result[@"email"]) {
        
        [_infoDictionary setObject:result[@"email"] forKey:kEmail];
    }
    
    NSString *deviceToken = [kUserDefault valueForKey:kDeviceid];
    
    [_infoDictionary setValue:deviceToken forKey:kDeviceToken];
    [_infoDictionary setValue:@"I" forKey:kDeviceType];
    
    //check user already register or not
    
    [self checkUserAlreadyRegisterOrnot:_infoDictionary];
    
}


#pragma mark - APIS

-(void)login:(NSMutableDictionary*)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"login-student.php"];
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [payloadDictionary setValue:@"1" forKey:kLoginStatus];
                    
                    NSString *userID = [payloadDictionary valueForKey:Kuserid];
                    userID = [userID  stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                    
                    [payloadDictionary setValue:userID forKey:Kuserid];
                     [payloadDictionary setValue:@"true" forKey:@"verifyOtp"];
                    
                    [kUserDefault setValue:[Utility archiveData:payloadDictionary] forKey:kLoginInfo];
                    
                    
                    if (![kUserDefault valueForKey:kPreviousUserId]) {
                       [kUserDefault setValue:userID forKey:kPreviousUserId];
                    }
                    NSLog(@"%@",[kUserDefault valueForKey:kPreviousUserId]);
                    
                    if (![userID isEqualToString:[kUserDefault valueForKey:kPreviousUserId]]) {
                        
                                       [kUserDefault removeObjectForKey:kGAPStep1];
                                       [kUserDefault removeObjectForKey:kGAPStep2];
                                       [kUserDefault removeObjectForKey:kGAPStep3];
                                       [kUserDefault removeObjectForKey:kGAPStep4];
                                      [kUserDefault removeObjectForKey:KglobalApplicationData];
                                       [kUserDefault removeObjectForKey:kStep4Dictionary];
                                     [kUserDefault removeObjectForKey:KisGlobalApplicationDataUpdated];
                        
                        [kUserDefault setValue:userID forKey:kPreviousUserId];
                    }
                    
                    if ([payloadDictionary valueForKey:kisGlobalFormCompleted]) {
                         [kUserDefault setValue:[payloadDictionary valueForKey:kisGlobalFormCompleted] forKey:kisGlobalFormCompleted];
                    }
                    
                    if ([[payloadDictionary valueForKey:kmini_profile_status] boolValue] == FALSE) {
                        [self performSegueWithIdentifier:kMPStep1SegueIdentifier sender:klogin];
                    }
                    else{
                        
                        UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
                        homeViewController.isQuickShown = YES;

                        UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                        
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                        
                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                        
                        revealController.delegate = self;
                        
                        self.revealViewController = revealController;
                        
                        self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                        self.window.backgroundColor = [UIColor redColor];
                        
                        self.window.rootViewController =self.revealViewController;
                        [self.window makeKeyAndVisible];
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
-(void)checkUserAlreadyRegisterOrnot:(NSMutableDictionary*)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"login-social-student.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [payloadDictionary setValue:@"true" forKey:@"verifyOtp"];
                    
                    if ([[payloadDictionary valueForKey:kmini_profile_status] boolValue] == false) {
                        
                        NSString *userId = [NSString stringWithFormat:@"%@",[payloadDictionary valueForKey:Kid]];
                        
                        if (![[Utility replaceNULL:userId value:@""] isEqualToString:@""] && [userId isKindOfClass:[NSString class]]) {
                            userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                        }
                        [payloadDictionary setValue:userId forKey:Kuserid];
                        [payloadDictionary setValue:userId forKey:Kid];
                        
                        [kUserDefault setValue:[Utility archiveData:payloadDictionary] forKey:kLoginInfo];
                        
                        [self performSegueWithIdentifier:kMPStep1SegueIdentifier sender:klogin];
                        
                    }
                    else{
                        
                        
                        [payloadDictionary setValue:@"1" forKey:kLoginStatus];
                        [payloadDictionary setValue:@"true" forKey:kmini_profile_status];
                        
                        if ([payloadDictionary valueForKey:kisGlobalFormCompleted]) {
                            [kUserDefault setValue:[payloadDictionary valueForKey:kisGlobalFormCompleted] forKey:kisGlobalFormCompleted];
                        }
                        
                        NSString *userId = [NSString stringWithFormat:@"%@",[payloadDictionary valueForKey:Kid]];
                        
                        if (![[Utility replaceNULL:userId value:@""] isEqualToString:@""] && [userId isKindOfClass:[NSString class]]) {
                            userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                        }
                        
                        [payloadDictionary setValue:userId forKey:Kuserid];
                        [payloadDictionary setValue:userId forKey:Kid];
                        
                        [kUserDefault setValue:[Utility archiveData:payloadDictionary] forKey:kLoginInfo];
                        
                        if (![kUserDefault valueForKey:kPreviousUserId]) {
                            [kUserDefault setValue:userId forKey:kPreviousUserId];
                        }
                        
                        
                        if (![userId isEqualToString:[kUserDefault valueForKey:kPreviousUserId]]) {
                            
                            [kUserDefault removeObjectForKey:kGAPStep1];
                            [kUserDefault removeObjectForKey:kGAPStep2];
                            [kUserDefault removeObjectForKey:kGAPStep3];
                            [kUserDefault removeObjectForKey:kGAPStep4];
                            [kUserDefault removeObjectForKey:KglobalApplicationData];
                            [kUserDefault removeObjectForKey:kStep4Dictionary];
                            [kUserDefault removeObjectForKey:KisGlobalApplicationDataUpdated];
                            
                            [kUserDefault setValue:userId forKey:kPreviousUserId];
                        }
                        
                        UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
                        homeViewController.isQuickShown = YES;

                        UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                        
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                        
                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                        
                        revealController.delegate = self;
                        
                        self.revealViewController = revealController;
                        
                        self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                        self.window.backgroundColor = [UIColor redColor];
                        
                        self.window.rootViewController =self.revealViewController;
                        [self.window makeKeyAndVisible];
                    }
                    
                    
                }else{
                    
                    [self performSegueWithIdentifier:kRegistrationSegueIdentifier sender:_infoDictionary];
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
