//
//  AgentRevelMenuVC.h
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentRevelMenuVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *menuTable;
    __weak IBOutlet UIImageView *userImage;
    __weak IBOutlet UILabel *userNameLabel;
}
@property (strong, nonatomic) UIWindow *window;

@end
