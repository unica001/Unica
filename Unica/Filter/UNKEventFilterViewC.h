//
//  UNKEventFilterViewC.h
//  Unica
//
//  Created by Shilpa Sharma on 08/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol delegateEvent <NSObject>
-(void)eventMethod:(NSString*)index;
@end

@interface UNKEventFilterViewC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    __weak IBOutlet UITableView *tblEvent;
    __weak IBOutlet UIButton *applyButton;
    
    NSMutableArray *eventArray;
    NSMutableArray *selectedEventArray;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    UILabel *messageLabel;
}
@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) NSString *eventID;

@property (nonatomic,retain) id <delegateEvent> eventDelegate;

-(void)eventList;

- (IBAction)applyButton_clicked:(id)sender;
@end
