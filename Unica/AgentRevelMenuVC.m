//
//  AgentRevelMenuVC.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "AgentRevelMenuVC.h"
#import "MenuCell.h"
#import "userSelectionVC.h"
#import "UNKMeetingReportViewC.h"
@interface AgentRevelMenuVC ()
{
    NSMutableArray *menuImagesArray;
    NSMutableArray *menuLabelArray;
    NSMutableDictionary *loginDictionary;
    UISwitch * notificationSwitch;
    NSString *userType;
    
    NSInteger selectedHeaderIndex;
    BOOL isEventSelected;
    AppDelegate *appDelegate;
    
}
@end

@implementation AgentRevelMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedHeaderIndex = 0;
    isEventSelected = false;
    
    menuImagesArray=[NSMutableArray arrayWithObjects:@"Home",@"Business",@"Student-1",@"Student-1",@"Tutorials",@"login-1",@"About",@"Logout-1", nil];
    
    menuLabelArray=[NSMutableArray arrayWithObjects:@"Home",@"View Business Cards", @"View Interested Students", @"Events",@"Tutorials", @"Login to UNICA Web Account", @"About UNICA",@"Logout", nil];
    
     appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [menuTable selectRowAtIndexPath:indexPath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
   // [self tableView:menuTable didSelectRowAtIndexPath:indexPath];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    [self setupInitialLayout];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)setupInitialLayout{
    
    userImage.layer.cornerRadius= 40;
    [userImage.layer setMasksToBounds:YES];
    
    // get login details
    
    NSLog(@"%@",[Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]]);
    
    
    if (![[kUserDefault valueForKey:kLoginInfo] isKindOfClass:[NSNull class]]) {
        loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        NSLog(@"%@",loginDictionary);
        
      
        
        userNameLabel.text = [NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"name"]];
        
        userImage.layer.cornerRadius =  userImage.frame.size.width/2;
        [userImage.layer setMasksToBounds:YES];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = userImage.center;
        
        [activityIndicator startAnimating];
        
        
        if (![[loginDictionary valueForKey:@"logo"] isKindOfClass:[NSNull class]]) {
            
            
            [userImage sd_setImageWithURL:[NSURL URLWithString:[loginDictionary valueForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"RegisterUser"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    userImage.image = [UIImage imageNamed:@"RegisterUser"];
                }
                [activityIndicator stopAnimating];
                NSLog(@"%@",error);
            }];
        }
        
    }
    
}


#pragma mark - Table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 3 && isEventSelected == true){
        return appDelegate.menuArray.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [menuImagesArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AjentHeaderCell" owner:self options:nil]firstObject];
    
    // image view
    UIImageView *img = (UIImageView*)[headerView viewWithTag:101];
    img.image = [UIImage imageNamed:[menuImagesArray objectAtIndex:section]];
    
    UILabel *lblMenu = (UILabel*)[headerView viewWithTag:102];
    lblMenu.text = [menuLabelArray objectAtIndex:section];
    
    
    //header button
    UIButton * btnHeader = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    btnHeader.tag = section;
    [btnHeader addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btnHeader];
    
    if ((selectedHeaderIndex-100 == section)){
        headerView.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:151.0f/255.0f blue:242.0f/255.0f alpha:1];
    }
    else{
        headerView.backgroundColor = kDefaultBlueColor;
    }
   
    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"menuCell";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    cell.backgroundColor = kDefaultBlueColor;
    
//    cell.menuImage.image = [UIImage imageNamed:[menuImagesArray objectAtIndex:indexPath.section]];
    cell.menuLabel.text= appDelegate.menuArray[indexPath.row][@"name"];
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:151.0f/255.0f blue:242.0f/255.0f alpha:1];
    cell.selectedBackgroundView = myBackView;
    
    return  cell;
    
}

-(void)headerButtonAction:(UIButton*)sender{
    
    selectedHeaderIndex = 100 + sender.tag;
    if (sender.tag == 0) {
        [self performSegueWithIdentifier:kHomeSegueIdentifier sender:nil];
    } else  if (sender.tag == 1) {
        [self performSegueWithIdentifier:kBusinessCardListSegue sender:nil];
    } else if (sender.tag == 2){
        [self performSegueWithIdentifier:KstudentListSegue sender:nil];
    }
    else if (sender.tag ==3){
        
        if (isEventSelected == false){
            isEventSelected = true;
            selectedHeaderIndex = 100 + sender.tag;
        }
        else {
            isEventSelected = false;
            selectedHeaderIndex = 0;
        }
    }
    
    else if (sender.tag == 4) { // Tutorial
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.uniagents.com/unica-tutorials.php"]];
    } else if (sender.tag == 5) { //Login to web account
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.uniagents.com/unica-web-login.php"]];
    } else if (sender.tag == 6) { // About
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.uniagents.com/about-unica.php"]];
    } else if (sender.tag == 7) {
        [Utility showAlertViewControllerIn:self withAction:@"Yes" actionTwo:@"No" title:@"Logout" message:@"Are you sure to Logout?" block:^(int index){
            
            if (index == 0) {
                
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate.twoMinTimer invalidate];
                
                [kUserDefault removeObjectForKey:kLoginInfo];
                
                self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             
                userSelectionVC *userSelectionVC = [storyboard instantiateViewControllerWithIdentifier:@"userSelectionVC"];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:userSelectionVC];
                self.window.rootViewController = nav;
                [self.window makeKeyAndVisible];
            }
            
        }];
    }
    [menuTable reloadData];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([appDelegate.menuArray[indexPath.row][@"type"] isEqualToString:@"A"]) {
        
        if ([appDelegate.menuArray[indexPath.row][kName] isEqualToString:kViewParticipants]) {
            [self performSegueWithIdentifier:kviewParticipantsSegueIdentifier sender:nil];
        }
        else if ([appDelegate.menuArray[indexPath.row][kName] isEqualToString:kMySchedule]) {
            [self performSegueWithIdentifier:kmyScheduleSegueIdentifier sender:nil];
        }
        else if ([appDelegate.menuArray[indexPath.row][kName] isEqualToString:kMeetingreport]) {
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
            
            UNKMeetingReportViewC *meetingView = [storyBoard instantiateViewControllerWithIdentifier:@"UNKMeetingReportViewC"];
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[meetingView] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            

//            if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
//            {
//                SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
//
//                swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
//
//                    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//
//                    [navController setViewControllers: @[dvc] animated: NO ];
//                    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//                };
//            }

        }
    }
    else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appDelegate.menuArray[indexPath.row][@"url"]] options:@{} completionHandler:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:kHomeSegueIdentifier]) {
        destViewController.title = @"Home";
    }
    else if ([sender isEqualToString:kBusinessCardListSegue]) {
        destViewController.title = @"View Business Cards";
    }
    else if ([sender isEqualToString:KstudentListSegue]) {
        destViewController.title = @"View Interested Students";
    }
    else if ([sender isEqualToString:kviewParticipantsSegueIdentifier]) {
        destViewController.title = @"View Participants";
    }
    else if ([sender isEqualToString:kmyScheduleSegueIdentifier]) {
        destViewController.title = @"My Schedule";
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
    
}

#pragma mark - API call

/****************************
 * Function Name : - signout
 * Create on : - 16 Feb 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used for signout user
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)signout{
    
    /*  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
     [dictionary setValue:[loginDictionary valueForKey:kUserId] forKey:kUserId];
     [dictionary setValue:[kUserDefault valueForKey:kDeviceid] forKey:kDeviceid];
     [dictionary setValue:@"ios" forKey:kPlatform];
     
     NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"userLogout"];
     
     [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
     
     if (!error) {
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     
     if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
     
     [self signOutFuntionality];
     
     
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
     
     if([error.domain isEqualToString:kTRLError]){
     dispatch_async(dispatch_get_main_queue(), ^{
     [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
     
     }];
     });
     }
     }
     
     }];*/
    
}




@end


