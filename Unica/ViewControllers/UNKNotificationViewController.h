//
//  UNKNotificationViewController.h
//  Unica
//
//  Created by Chankit on 7/20/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "notificationCell.h"

@interface UNKNotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate>
{
    __weak IBOutlet UITableView *_notificationTable;
    __weak IBOutlet UIBarButtonItem *_backButton;
    BOOL isLoading;
    BOOL isHude;
    int totalRecord;
    
}
@property (nonatomic,retain) NSString *incommingViewType;

@end
