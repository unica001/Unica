//
//  UNKAddAgentReviewViewController.h
//  Unica
//
//  Created by vineet patidar on 27/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKAddAgentReviewViewController : UIViewController<UITextViewDelegate,SWRevealViewControllerDelegate,getRatingValue>{

    __weak IBOutlet UIView *_reatingView;
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UIButton *_submitButton;
    __weak IBOutlet UIView *_addReviewBackgroundView;
    __weak IBOutlet UIBarButtonItem *_backButton;
    __weak IBOutlet UILabel *_ratingLabel;
    
}
- (IBAction)backButton_clicked:(id)sender;

@property (nonatomic,retain) NSMutableDictionary *agentDictionary;

- (IBAction)sunbmitButton_clicked:(id)sender;

@end
