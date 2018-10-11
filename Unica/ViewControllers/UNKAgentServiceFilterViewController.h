//
//  UNKAgentServiceFilterViewController.h
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol delegateAgentService <NSObject>

-(void)agentServiceMethod:(NSString*)index;

@end

@interface UNKAgentServiceFilterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{


    __weak IBOutlet UITableView *_serviceTable;
    __weak IBOutlet UIButton *_applyButton;
    
    NSMutableArray *_serviceArray;
    NSMutableArray *_selectedServiceArray;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    UILabel *messageLabel;
}
@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) id <delegateAgentService> agentService;

-(void)searchSeavices;

- (IBAction)applyButton_clicked:(id)sender;

@end
