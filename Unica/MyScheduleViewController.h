//
//  MyScheduleViewController.h
//  Unica
//
//  Created by Ram Niwas on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScheduleCell.h"

@interface MyScheduleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate>{
    
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UILabel *noRecordLabel;
    __weak IBOutlet UIBarButtonItem *menuButton;
}
- (IBAction)filterButtonAction:(id)sender;
- (IBAction)menuButtonAction:(id)sender;

@end
