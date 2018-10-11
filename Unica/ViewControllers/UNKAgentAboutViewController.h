//
//  UNKAgentAboutViewController.h
//  Unica
//
//  Created by vineet patidar on 24/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKAgentAboutViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate>{

    __weak IBOutlet UIBarButtonItem *_backButton;
    __weak IBOutlet UITableView *_aboutTable;
    
    NSMutableArray *_aboutArray;
}

@property (nonatomic,retain) NSMutableDictionary *agentDictionary;

- (IBAction)backButton_clicked:(id)sender;

@end
