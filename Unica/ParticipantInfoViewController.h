//
//  ParticipantInfoViewController.h
//  Unica
//
//  Created by Ram Niwas on 08/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDescriptionCell.h"

@interface ParticipantInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UILabel *performanceStatusLabel;
    __weak IBOutlet UIView *bottomView;
    
}
- (IBAction)performanceStatusButtonAction:(id)sender;
@property(nonatomic,retain) NSDictionary *infoDictionary;
@end
