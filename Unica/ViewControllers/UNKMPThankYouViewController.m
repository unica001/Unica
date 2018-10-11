//
//  UNKMPThankYouViewController.m
//  Unica
//
//  Created by vineet patidar on 14/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKMPThankYouViewController.h"

@interface UNKMPThankYouViewController ()

@end

@implementation UNKMPThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
   // checkMarkImage.layer.cornerRadius = checkMarkImage.frame.size.width/2;
  //  [checkMarkImage.layer setMasksToBounds:YES];
    
    thanksLabel.text = [self.thanksDictionary valueForKey:@"Message"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextButton_clicked:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;

    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
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
    [self.window makeKeyAndVisible];

}
@end
