//
//  UNKApplicationStatusViewController.h
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKCourseDetailsViewController.h"

@interface UNKApplicationStatusViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate>{
    NSMutableArray *applicationStatusArray;
    
    __weak IBOutlet UITableView *_statusTable;
    __weak IBOutlet UIBarButtonItem *_backButton;
    
    BOOL isHude;
}
- (IBAction)backButton_clicked:(id)sender;

@property (nonatomic,retain) NSString *incommingViewType;
@end
