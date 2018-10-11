//
//  UNKComingSoonViewController.m
//  Unica
//
//  Created by vineet patidar on 13/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKComingSoonViewController.h"

@interface UNKComingSoonViewController ()

@end

@implementation UNKComingSoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";

    if (![self.incomingViewType isEqualToString:kHomeView]) {
    
        backButton.image = [UIImage imageNamed:@"menuicon"];

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [backButton setTarget: self.revealViewController];
            [backButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    }
    self.revealViewController.delegate = self;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
