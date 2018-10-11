//
//  userSelectionVC.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "userSelectionVC.h"
#import "AgentLoginVC.h"

@interface userSelectionVC ()

@end

@implementation userSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    view1.layer.borderWidth = 1;
    view1.layer.borderColor = [UIColor whiteColor].CGColor;
    view2.layer.borderWidth = 1;
    view2.layer.borderColor = [UIColor whiteColor].CGColor;
    view3.layer.borderWidth = 1;
    view3.layer.borderColor = [UIColor whiteColor].CGColor;
    if(kIs_Iphone5)
    {
         topspacingConstant.constant = 30;
    }
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation



- (IBAction)instituteButton_Action:(id)sender {
    [self performSegueWithIdentifier:@"userSelectionSegue" sender:@"I"];
}

- (IBAction)consultantButton_Action:(id)sender {
    [self performSegueWithIdentifier:@"userSelectionSegue" sender:@"A"];
}

- (IBAction)studentButton_Action:(id)sender {
    if ([[kUserDefault valueForKey:kshowTutorialScreen] isEqualToString:@"False"]) {
        
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//            //            if (isAutoLogin == YES) {
//            //                [self autoLogin:self.application];
//            //            }
//
//        });
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        
    }
    else{
        
        [kUserDefault setValue:@"False" forKey:kshowTutorialScreen];
        [self performSegueWithIdentifier:@"tutorialSegue" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"userSelectionSegue"])
    {
        AgentLoginVC *controller = segue.destinationViewController;
        controller.loginType = sender;
    }
    
}
@end
