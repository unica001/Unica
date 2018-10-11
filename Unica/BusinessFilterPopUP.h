//
//  BusinessFilterPopUP.h
//  Unica
//
//  Created by meenakshi on 5/18/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessFilterPopUP : UIView

@property (strong, nonatomic) NSMutableArray *arrAction, *arrCategory;

@property (weak, nonatomic) IBOutlet UITableView *tblAction;
@property (weak, nonatomic) IBOutlet UITableView *tblCategory;
@property (weak, nonatomic) IBOutlet UIView *viewFromDate;
@property (weak, nonatomic) IBOutlet UIView *viewToDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFromDate;
@property (weak, nonatomic) IBOutlet UITextField *txtToDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnClearAll;
@property (weak, nonatomic) IBOutlet UIButton *btnApply;

- (void)resetArrayValues;
@end
