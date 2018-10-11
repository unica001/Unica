//
//  MessagePopViewController.h
//  Unica
//
//  Created by vineet patidar on 30/07/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagePopViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *popView;

@property(nonatomic,retain) NSMutableDictionary *dictionary;

- (IBAction)sendButton_clicked:(id)sender;
- (IBAction)cancelButtonButton:(id)sender;

@end
