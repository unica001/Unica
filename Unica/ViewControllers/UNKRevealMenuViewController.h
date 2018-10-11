//
//  UNKRevealMenuViewController.h
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKRevealMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *menuTable;
    __weak IBOutlet UIImageView *userImage;
    __weak IBOutlet UILabel *userNameLabel;
}
- (IBAction)editButton_clicked:(id)sender;

@end
