//
//  UNKQuestionnaireViewController.h
//  Unica
//
//  Created by vineet patidar on 18/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKMPThankYouViewController.h"

#import "RadioButtonStep3.h"

@interface UNKQuestionnaireViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
   
    NSString *selectedCountryID;
    NSMutableArray *questionArray;
    NSMutableArray *selectedquestionArray;

    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isAlreadyPay;
- (IBAction)submitButton_clicked:(id)sender;

@end
