//
//  UNKEventDetailsViewController.h
//  Unica
//
//  Created by ramniwas on 02/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKEventDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate>{
    NSMutableDictionary *_eventDetailDictionary;
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UITableView *_eventDetailTable;

    IBOutlet UIBarButtonItem *_backButton;
    __weak IBOutlet UIButton *registerButton;
}

@property (nonatomic,retain) NSString *incomingViewType;;

@property (nonatomic,retain) NSMutableDictionary *evenDictionary;
- (IBAction)backButton_clicked:(id)sender;
- (IBAction)registerButton_clicked:(id)sender;
@end
