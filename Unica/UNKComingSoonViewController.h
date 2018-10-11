//
//  UNKComingSoonViewController.h
//  Unica
//
//  Created by vineet patidar on 13/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKComingSoonViewController : UIViewController<SWRevealViewControllerDelegate>{

    __weak IBOutlet UIBarButtonItem *backButton;
}

@property (nonatomic,retain) NSString *incomingViewType;

- (IBAction)backButton_clicked:(id)sender;

@end
