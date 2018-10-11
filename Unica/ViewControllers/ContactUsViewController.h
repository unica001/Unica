//
//  ContactUsViewController.h
//  Unica
//
//  Created by vineet patidar on 09/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *_contactUsArray;
    __weak IBOutlet UITableView *_contactUsTable;
    __weak IBOutlet UIBarButtonItem *_backButton;
    NSAttributedString *_htmlString;
    
    NSArray *_phoneArray;
    
    NSMutableDictionary *contactUsDictionary;
}
- (IBAction)backButton_clicked:(id)sender;

@end
