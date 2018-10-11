//
//  UNKAgentMessageViewController.h
//  Unica
//
//  Created by vineet patidar on 24/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKAgentMessageViewController : UIViewController<UITextViewDelegate>{
    
   
   
    __weak IBOutlet UIButton *_submitButton;
    __weak IBOutlet UIView *_addReviewBackgroundView;
    __weak IBOutlet UIBarButtonItem *_backButton;
}
- (IBAction)backButton_clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,retain) NSMutableDictionary *agentDictionary;

- (IBAction)sunbmitButton_clicked:(id)sender;

@end
