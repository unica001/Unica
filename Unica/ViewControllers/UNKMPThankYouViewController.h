//
//  UNKMPThankYouViewController.h
//  Unica
//
//  Created by vineet patidar on 14/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKRevealMenuViewController.h"
#import "UNKHomeViewController.h"

@interface UNKMPThankYouViewController : UIViewController<SWRevealViewControllerDelegate>{

    __weak IBOutlet UIImageView *checkMarkImage;
    __weak IBOutlet UILabel *thanksLabel;
}

@property (nonatomic,retain) NSMutableDictionary *thanksDictionary;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;

- (IBAction)nextButton_clicked:(id)sender;

@end
