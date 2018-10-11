//
//  UNKAgentReviewViewController.h
//  Unica
//
//  Created by vineet patidar on 24/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKAgentReviewViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate>{

    NSMutableArray *_reviewArray;
    __weak IBOutlet UITableView *_reviewTable;
    __weak IBOutlet UIBarButtonItem *_revealMenu;
    __weak IBOutlet UIButton *_reviewButton;
    
}
- (IBAction)addReviewButton_clicked:(id)sender;
@property (nonatomic,retain) NSMutableDictionary *agentDictionary;

@end
