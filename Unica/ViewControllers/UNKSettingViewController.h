//
//  UNKSettingViewController.h
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKSettingViewController :UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate>{
    NSMutableArray *applicationStatusArray;
    
    __weak IBOutlet UITableView *_settingTable;
    __weak IBOutlet UIBarButtonItem *_menuButton;
    
    NSMutableArray *settingArray;
}
- (IBAction)menuButtonButton_clicked:(id)sender;

@property (nonatomic,retain) NSString *incommingViewType;
@property (strong, nonatomic) UIWindow *window;
@end
