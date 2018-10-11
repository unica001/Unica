//
//  userSelectionVC.h
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userSelectionVC : UIViewController
{
    
    __weak IBOutlet NSLayoutConstraint *topspacingConstant;
    __weak IBOutlet UIView *view1;
    __weak IBOutlet UIView *view2;
    __weak IBOutlet UIView *view3;
    
}
- (IBAction)instituteButton_Action:(id)sender;
- (IBAction)consultantButton_Action:(id)sender;
- (IBAction)studentButton_Action:(id)sender;


@end
