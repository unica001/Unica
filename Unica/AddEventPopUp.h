//
//  AddEventPopUp.h
//  Unica
//
//  Created by meenakshi on 5/18/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventPopUp : UIView

@property (weak, nonatomic) IBOutlet UITextField *txtFieldEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnCalender;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEndDate;
@property (weak, nonatomic) IBOutlet UIView *viewEndDate;
@property (weak, nonatomic) IBOutlet UIView *viewEvent;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnTemplate;

@end
