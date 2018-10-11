//
//  UNKReferFriendViewController.h
//  Unica
//
//  Created by vineet patidar on 08/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReferFriendCell.h"

@interface UNKReferFriendViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{


    __weak IBOutlet UITableView *_referFriendTable;
    __weak IBOutlet UIBarButtonItem *_backButton;
    __weak IBOutlet UIButton *_submitButon;
    __weak IBOutlet UILabel *_addMoreLabel;
    __weak IBOutlet UIView *_lineView;
    __weak IBOutlet UIButton *_addMoreButton;
    
    __weak IBOutlet UILabel *_headerLabel;
    __weak IBOutlet UIButton *removeButton;
    NSUInteger referFriendCount;
    __weak IBOutlet UIView *removeLineView;
}
- (IBAction)submitButton_clicked:(id)sender;

- (IBAction)backButton_clicked:(id)sender;
- (IBAction)removeButton_clicked:(id)sender;
- (IBAction)addMoreButton_clicked:(id)sender;

// Refer Friend 1
@property (strong, nonatomic) UITextField *RF1NameTextField;
@property (strong, nonatomic) UITextField *RF1EmailTextField;
@property (strong, nonatomic) UITextField *RF1pphoneNumberTextField;

// Refer Friend 2
@property (strong, nonatomic) UITextField *RF2NameTextField;
@property (strong, nonatomic) UITextField *RF2EmailTextField;
@property (strong, nonatomic) UITextField *RF2pphoneNumberTextField;

// Refer Friend 3
@property (strong, nonatomic) UITextField *RF3NameTextField;
@property (strong, nonatomic) UITextField *RF3EmailTextField;
@property (strong, nonatomic) UITextField *RF3pphoneNumberTextField;

@end
