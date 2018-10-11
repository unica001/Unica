//
//  UNKSettingViewController.m
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKSettingViewController.h"
#import "UNKSettingViewController.h"
#import "settingCell.h"
#import "UNKWebViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "userSelectionVC.h"

@interface UNKSettingViewController (){
    NSMutableDictionary *loginDictionary;
    NSMutableDictionary *statusDictionary;
}

@end

@implementation UNKSettingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
      loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    [self getStatus:YES];
    // make table round up
    
    _settingTable.layer.cornerRadius = 10.0;
    [_settingTable.layer setMasksToBounds:YES];
        
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {  SWRevealViewController *revealViewController = self.revealViewController;
            if ( revealViewController )
            {
                [_menuButton setTarget: self.revealViewController];
                [_menuButton setAction: @selector( revealToggle: )];
                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            }
        }
        self.revealViewController.delegate = self;
    
    
    settingArray = [[NSMutableArray alloc]initWithObjects:@"About Us",@"Contact Us",@"App Version",@"Change Password",@"Notification",@"Logout", nil];
    
    self.title = @"Settings";

}



#pragma mark - Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [settingArray count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 20)];
        [label setFont:kDefaultFontForApp];
        label.text = @"Notification";
        [view addSubview:label];
        return view;
    }
    else
    {
        return nil;
    }

   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 4) {
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 4)
    {
        return 40;
    }
    else
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"settingCell";
    settingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"settingCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = [settingArray objectAtIndex:indexPath.section];
    
    if (indexPath.section == 4) {
        cell.arrowImage.hidden = YES;
        cell.swithButton.hidden = NO;
        cell.nameLabel.hidden = NO;
        cell.labelLeadingConstraint.constant =20;
        cell.swithButton.tag = indexPath.row;
        [cell.swithButton addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventValueChanged];
        NSString *key;
        if(indexPath.row==0)
        {
            key=@"unica";

           
        }
        else if(indexPath.row==1)
        {
             key=@"institute";
          
        }
        else
        {
              key=@"agent";
           }
        NSString *status;
        if(statusDictionary.count>0)
        status =[NSString stringWithFormat:@"%@",[[statusDictionary valueForKey:key] valueForKey:@"status"]];
        if([status isEqualToString:@"true"])
        {
            [cell.swithButton setOn:YES animated:YES];
        }
        else
        {
            [cell.swithButton setOn:NO animated:YES];
        }
        
        
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"Unica";
            
        }
        else if (indexPath.row == 1) {
            cell.nameLabel.text = @"University";
        }
        else if (indexPath.row == 2) {
            cell.nameLabel.text = @"Agent";
        }
        
    }
    else  if (indexPath.section == 3) {
        cell.arrowImage.hidden = NO;
        cell.swithButton.hidden = YES;
        cell.nameLabel.hidden = NO;
    }
    else if (indexPath.section == 5){
        cell.arrowImage.hidden = NO;
        cell.swithButton.hidden = YES;
    }
    else if (indexPath.section ==2){
        
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.nameLabel.text = [NSString stringWithFormat:@"App Version - %@",version];
        
        cell.arrowImage.hidden = YES;
        cell.swithButton.hidden = YES;
    }
    else {
        cell.arrowImage.hidden = NO;
        cell.swithButton.hidden = YES;
    }

    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:nil];
    }
    else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:kcontactUSegueIdentifier sender:nil];
    }
   else if (indexPath.section == 3) {
        [self performSegueWithIdentifier:kchangePasswordSegueIdentifier sender:nil];
    }
   else if (indexPath.section == 5) {
    
       [Utility showAlertViewControllerIn:self withAction:@"Yes" actionTwo:@"No" title:@"Logout" message:@"Are you sure to Logout?" block:^(int index){
           
           if (index == 0) {
               [[GIDSignIn sharedInstance] signOut];
               [[GIDSignIn sharedInstance] disconnect];
               [[FBSDKLoginManager new] logOut];
               
               AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
               [appDelegate.twoMinTimer invalidate];
               
               [kUserDefault removeObjectForKey:kLoginInfo];
//               [kUserDefault removeObjectForKey:kGAPStep1];
//               [kUserDefault removeObjectForKey:kGAPStep2];
//               [kUserDefault removeObjectForKey:kGAPStep3];
//               [kUserDefault removeObjectForKey:kGAPStep4]; //              [kUserDefault removeObjectForKey:KglobalApplicationData];
//               [kUserDefault removeObjectForKey:kStep4Dictionary];
  //             [kUserDefault removeObjectForKey:KisGlobalApplicationDataUpdated];
               
               
               // remove data from plist
                [UtilityPlist saveData:nil fileName:kAGENT];
                [UtilityPlist saveData:nil fileName:kCOURSES];
                [UtilityPlist saveData:nil fileName:kINSTITUDE];
               self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
               
               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
               
               //                UNKSignInViewController *_signViewController = [storyboard instantiateViewControllerWithIdentifier:@"signViewStoryBoardId"];
               userSelectionVC *userSelectionVC = [storyboard instantiateViewControllerWithIdentifier:@"userSelectionVC"];
               UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:userSelectionVC];
               self.window.rootViewController = nav;
               [self.window makeKeyAndVisible];
//        [self performSegueWithIdentifier:kSignInViewSegueIdentifier sender:nil];
           }
           
       }];
   }

}

-(void)menuButtonButton_clicked:(UIButton*)sender{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - Button Clicked

- (void)changeStatus:(UISwitch *)twistedSwitch
{
    int tag = (int)twistedSwitch.tag;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSArray *str = [[NSArray alloc] initWithObjects:@"unica",@"institute",@"agent", nil];
     [dictionary setValue:[str objectAtIndex:tag] forKey:@"type"];
    
    if (![twistedSwitch isOn] )
    {
        [dictionary setValue:@"false" forKey:@"notification_status"];
        
        //Write code for SwitchON Action
    }
    else
    {
       [dictionary setValue:@"true" forKey:@"notification_status"];
        //Write code for SwitchOFF Action
    }
    [self updateStatus:dictionary];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:kwebviewSegueIdentifier]) {
        UNKWebViewController *_wevView = segue.destinationViewController;
        _wevView.webviewMode = UNKAboutUs;
    }
    
}

#pragma mark - APIS

-(void)getStatus:(BOOL )showHud{
    
    NSMutableDictionary *dictionary =[[NSMutableDictionary alloc] init];
    if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
        [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:Kuserid];
    }
    NSString *message =@"Please wait..";
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"get-notification-settings.php"];
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHud showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    statusDictionary = [dictionary valueForKey:kAPIPayload];
                    [_settingTable reloadData];
                    
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

-(void)updateStatus:(NSMutableDictionary *)dic{
    
    if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
        [dic setValue:[loginDictionary valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dic setValue:[loginDictionary valueForKey:Kuserid] forKey:Kuserid];
    }

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"notification-settings.php"];
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dic  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [self getStatus:NO];
                    
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
@end
