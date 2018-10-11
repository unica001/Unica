//
//  UNKRevealMenuViewController.m
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKRevealMenuViewController.h"
#import "GlobalApplicationStep1ViewController.h"
#import "UNKRegistrationViewController.h"
#import "UNKRegistrationViewController.h"
#import "MenuCell.h"


@interface UNKRevealMenuViewController ()
{
    NSMutableArray *menuImagesArray;
    NSMutableArray *menuLabelArray;
    NSMutableDictionary *loginDictionary;
    UISwitch * notificationSwitch;
    NSString *userType;
    
}
@end

@implementation UNKRevealMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
        menuImagesArray=[NSMutableArray arrayWithObjects:@"MenuHome",@"EditProfile",@"MenuUnicaCode",@"NotificationWhite",@"MenuAgents",@"MenuSearch",@"MenuEvents",@"MenuFavorites",@"MenuGlobalApplication",@"MenuMyApplication",@"MenuSettings", nil];
    
        menuLabelArray=[NSMutableArray arrayWithObjects:@"HOME",@"EDIT PROFILE",@"MY UNICA CODE",@"NOTIFICATIONS",@"SEARCH AGENTS",@"SEARCH COURSES",@"SEARCH EVENTS",@"FAVOURITES",@"GLOBAL APPLICATION",@"MY APPLICATIONS",@"SETTINGS", nil];

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
        
        NSString *fullNameString;
        
        if (![[loginDictionary valueForKey:klastname] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:klastname] length]>0) {
        fullNameString = [NSString stringWithFormat:@"%@ %@",[loginDictionary valueForKey:kfirstname],[loginDictionary valueForKey:klastname]];
        }
        else {
             fullNameString = [NSString stringWithFormat:@"%@",[loginDictionary valueForKey:kfirstname]];
        }
        
        userNameLabel.text = fullNameString;
        
        userImage.layer.cornerRadius =  userImage.frame.size.width/2;
        [userImage.layer setMasksToBounds:YES];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = userImage.center;
        
        [activityIndicator startAnimating];
        
        
        if (![[loginDictionary valueForKey:kProfile_image] isKindOfClass:[NSNull class]]) {
            
            
            [userImage sd_setImageWithURL:[NSURL URLWithString:[loginDictionary valueForKey:kProfile_image]] placeholderImage:[UIImage imageNamed:@"RegisterUser"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
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
    
    return [menuImagesArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    
    static NSString *cellIdentifier  =@"menuCell";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    cell.backgroundColor = kDefaultBlueColor;
    
    cell.menuImage.image = [UIImage imageNamed:[menuImagesArray objectAtIndex:indexPath.row]];
    cell.menuLabel.text=[menuLabelArray objectAtIndex:indexPath.row];
    
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:151.0f/255.0f blue:242.0f/255.0f alpha:1];
    cell.selectedBackgroundView = myBackView;
   
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:kHomeSegueIdentifier sender:nil];
    }
    else if (indexPath.row == 1){
     [self performSegueWithIdentifier:kRegistrationSegueIdentifier sender:kEditMode];
    }
    else  if (indexPath.row == 2) {
        [self performSegueWithIdentifier:kmyUnicaCodeSegueIdentifier sender:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
    else if (indexPath.row == 3){
        [self performSegueWithIdentifier:knotificationSegueIdentifier sender:kHomeView];
        
    }
   else if (indexPath.row == 4) {
       [self performSegueWithIdentifier:kAgentSegueIdentifier sender:nil];
    }
    
    else if (indexPath.row == 5) {
  [self performSegueWithIdentifier:kCourseSegueIdentifier sender:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    else if (indexPath.row == 6) {
        [self  performSegueWithIdentifier:keventSegueIdentifier sender:nil];
    }
    else if (indexPath.row == 7){
        
        // favourite
        [self performSegueWithIdentifier:kAgentFilterSegueIdentifier sender:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
      
    }
    else if (indexPath.row == 8) {
 
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"GAF" bundle:[NSBundle mainBundle]];
        GlobalApplicationStep1ViewController *_GAFStep1ViewController = [storyBoard instantiateViewControllerWithIdentifier:kGAFStepp1StoryboardID];

        
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            navController.title = @"RevealMenu";
//            [navController setViewControllers: @[_GAFStep1ViewController] animated: NO ];
//        
//               navController.navigationBar.barStyle =UIBarStyleDefault;
//        [navController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"header"]
//                                                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
//        [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//        [navController.navigationBar setTintColor:[UIColor whiteColor]];
//        
        navController.title = @"RevealMenu";
        [navController setViewControllers: @[_GAFStep1ViewController] animated: NO ];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
          
        

    }
    else if (indexPath.row == 9){
        [self performSegueWithIdentifier:kapplicationStatusSegueIdentifier sender:nil];

    }
    
    else if (indexPath.row == 10){
        [self performSegueWithIdentifier:ksettingSegueIdentifier sender:nil];
    }
}


-(void)signOutFuntionality{
    
//    [kUserDefault removeObjectForKey:kLoginInfo];
//    [kUserDefault removeObjectForKey:kUserLoginType];
//    [kUserDefault removeObjectForKey:kSkinpAndTry];
//    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    
//    AppDelegate *appDelegateTemp = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    TRLUserInitialController *initialController = [storyBoard instantiateViewControllerWithIdentifier:kInitialControllerStoryBoardID];
//    
//    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:initialController];
//    appDelegateTemp.window.rootViewController = navigation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    
   if ([sender isEqualToString:kEditMode]) {
        destViewController.title = kMyProfile;
    }
   else if ([sender integerValue] ==0) {
        destViewController.title = @"Home";
    }
    else if ([sender integerValue] ==0) {
        destViewController.title = @"My UNICA Code";
    }
    else  if ([sender integerValue] ==1) {
        destViewController.title = @"My Booking";
    }
    
    else  if ([sender integerValue] ==7) {
        destViewController.title = kMenuFavourite;
    }
    
    
    else  if ([sender integerValue] == 9) {
        destViewController.title = @"Profile";
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


- (IBAction)editButton_clicked:(id)sender {
    
    [menuTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                             animated:NO
                       scrollPosition:UITableViewScrollPositionTop];    [self performSegueWithIdentifier:kRegistrationSegueIdentifier sender:kEditMode];
}
@end
