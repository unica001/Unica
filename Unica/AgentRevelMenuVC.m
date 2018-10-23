
#import "AgentRevelMenuVC.h"
#import "MenuCell.h"
#import "userSelectionVC.h"
#import "UNKMeetingReportViewC.h"
#import "UNKRecordExpressionController.h"
#import "UNKRecordExpressionViewC.h"

typedef enum
{
    viewParticipant = 1,
    mySchedule,
    meetingReport,
    participantAll
} eventMenuType;

@interface AgentRevelMenuVC ()
{
    NSMutableArray *menuImagesArray;
    NSMutableArray *menuLabelArray;
    NSMutableDictionary *loginDictionary;
    UISwitch * notificationSwitch;
    NSString *userType;
    NSString *userId;

    
    NSInteger selectedHeaderIndex;
    BOOL isEventSelected;
    AppDelegate *appDelegate;
    
}
@end

@implementation AgentRevelMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedHeaderIndex = 0;
    isEventSelected = true;
    selectedHeaderIndex = 103;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    menuImagesArray=[NSMutableArray arrayWithObjects:@"Home",@"Business",@"Student-1",@"event_menu",@"Tutorials",@"login-1",@"About",@"Logout-1", nil];
    
    menuLabelArray=[NSMutableArray arrayWithObjects:@"Home",@"View Business Cards", @"View Interested Students", @"Events",@"Tutorials", @"Login to UNICA Web Account", @"About UNICA",@"Logout", nil];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [menuTable selectRowAtIndexPath:indexPath
                           animated:YES
                     scrollPosition:UITableViewScrollPositionNone];
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        userId = [dictLogin valueForKey:Kid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    else{
        userId =[dictLogin valueForKey:Kuserid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    userType = [dictLogin valueForKey:@"user_type"] ;
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
    if (indexPath.section == 3) {
        return (appDelegate.menuArray.count > 0) ? 50 : 0;
    }
    return  50;
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
    
    if ((selectedHeaderIndex-100 == section)) {
        headerView.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:151.0f/255.0f blue:242.0f/255.0f alpha:1];
    }
    else{
        headerView.backgroundColor = kDefaultBlueColor;
    }
    if (section == 3) {
        return (appDelegate.menuArray.count != 0) ? headerView : nil;
    }
    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return (appDelegate.menuArray.count != 0) ? 50 : 0;
    }
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
      
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: appDelegate.webLoginUrl]];
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
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
    
    NSLog(@"%ld",(long)indexPath.row);
    
    if ([appDelegate.menuArray[indexPath.row][@"type"] isEqualToString:@"A"]) {
        
        if ([appDelegate.menuArray[indexPath.row][@"action"]integerValue] == viewParticipant) {
            [self performSegueWithIdentifier:kviewParticipantsSegueIdentifier sender:nil];
        }
       else if ([appDelegate.menuArray[indexPath.row][@"action"]integerValue] == mySchedule) {
            [self performSegueWithIdentifier:kmyScheduleSegueIdentifier sender:nil];
        }
       else if ([appDelegate.menuArray[indexPath.row][@"action"]integerValue] == meetingReport) {
            UNKMeetingReportViewC *meetingView = [storyBoard instantiateViewControllerWithIdentifier:@"UNKMeetingReportViewC"];
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[meetingView] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        }
        else if ([appDelegate.menuArray[indexPath.row][@"action"]integerValue] == participantAll) {
            UNKRecordExpressionViewC *meetingView = [storyBoard instantiateViewControllerWithIdentifier:@"UNKRecordExpressionViewC"];
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[meetingView] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];        }
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
    else if ([sender isEqualToString:kredordExpressionSegueIdentifier]) {
        destViewController.title = @"Record Espression";
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

@end


