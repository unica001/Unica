//
//  AgentLoginVC.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "AgentLoginVC.h"
#import "SignInCell.h"
#import "AgentHomeVC.h"
#import "AgentRevelMenuVC.h"
#import "AgentForgotPasswordVC.h"

@interface AgentLoginVC ()
@end

typedef enum
{   email = 0,
    password
    
} textFieldType;

@implementation AgentLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = NO;
    
    _infoDictionary = [[NSMutableDictionary alloc]init];
    [self getActions];
    [self getCategories];
    
    // set initial layout
    [self setupInitialLayout];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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
    //_emailText.text  = @"sanjay@uniagents.com";
    //Setup  password Field
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Password" forKey:kTextFeildOptionPlaceholder];
    _passwordText = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    _passwordText.returnKeyType = UIReturnKeyDone;
   // _passwordText.text = @"123";
    
    
   
    
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
        
        cell.headerLabel.text = @"Login ID";
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Clicked

- (IBAction)loginButton_clicked:(id)sender {
    
       /* UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"agent" bundle:nil];
    
        AgentHomeVC * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"AgentHomeVC"];
    
        AgentRevelMenuVC *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AgentRevelMenuVC"];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
        revealController.delegate = self;
    
        self.revealViewController = revealController;
    
        self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
        self.window.backgroundColor = [UIColor redColor];
    
        self.window.rootViewController =self.revealViewController;
        [self.window makeKeyAndVisible];*/
    
    if ([self validatePassword]) {

        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        NSString *deviceToken = [kUserDefault valueForKey:kDeviceid];

        [dictionary setValue:_emailText.text forKey:@"user_id"];
        [dictionary setValue:_passwordText.text forKey:@"password"];
        [dictionary setValue:self.loginType forKey:@"user_type"];
        [dictionary setValue:deviceToken forKey:kDeviceToken];
        [dictionary setValue:@"I" forKey:kDeviceType];
        [self login:dictionary];
    }
}



- (IBAction)forgotPasswordButton_clicked:(id)sender {
    
    [self performSegueWithIdentifier:kForgotPasswordSegueIdentifier sender:nil];
}

- (IBAction)registerButton_Action:(id)sender {
    if([self.loginType isEqualToString:@"I"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.uniagents.com/ga-institution/institution-sub-user.php"]];
    }
    else
    {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.uniagents.com/register_agent.php?id=1c383cd30b7c298ab50293adfecb7b18"]];
    }
}

- (IBAction)backButton_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - APIS

-(void)login:(NSMutableDictionary*)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"login_inst_agent.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    NSMutableDictionary *_loginInfo = [dictionary valueForKey:kAPIPayload];
                    [[_loginInfo valueForKey:@"id"] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                    [kUserDefault setValue:[Utility archiveData:_loginInfo] forKey:kLoginInfo];
                    
                    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"agent" bundle:nil];
                    
                    AgentHomeVC * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"AgentHomeVC"];
                    
                    AgentRevelMenuVC *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AgentRevelMenuVC"];
                    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                    
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                    
                    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                    
                    revealController.delegate = self;
                    
                    self.revealViewController = revealController;
                    
                    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                    
                    self.window.rootViewController =self.revealViewController;
                    [self.window makeKeyAndVisible];
                    
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

-(void)getActions{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"master-actions.php"];
    
//    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *payloadDictionary = dictionary ;
                        [UtilityPlist saveData:payloadDictionary fileName:KActions];
                        
                        
                    });
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       // [self getActions];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                   // [self getActions];
                });
            }
        }
    }];
    
}
-(void)getCategories{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"master-categories.php"];
    
//    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
    
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *payloadDictionary = dictionary ;
                        [UtilityPlist saveData:payloadDictionary fileName:Kcategories];
                        
                        
                    });
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       // [self getCategories];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                   // [self getCategories];
                });
            }
        }
    }];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    AgentForgotPasswordVC *controller = segue.destinationViewController;
    controller.type = self.loginType;
    
    
}
@end

