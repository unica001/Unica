//
//  TimeSlotViewController.h
//  Unica
//
//  Created by Ram Niwas on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSlotCell.h"

@protocol reloadParticipantTable <NSObject>
-(void)loadAcceptCellData:(NSDictionary *)reloadDic;
@end

@interface TimeSlotViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UIImageView *myTableImgView;
    __weak IBOutlet UIImageView *yourTableImgView;
    __weak IBOutlet UILabel *yourTableLabel;
    __weak IBOutlet UILabel *myTableLabel;
    
    __weak IBOutlet NSLayoutConstraint *bottomViewHeight;
    __weak IBOutlet UIButton *submitButton;
    __weak IBOutlet UIView *footerView;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    BOOL isHude;
    BOOL isFromFilter;
    BOOL LoadMoreData;
}
- (IBAction)backButtonAction:(id)sender;
- (IBAction)myTableButtonAction:(id)sender;
- (IBAction)submitButtonAction:(id)sender;
- (IBAction)yourTableButtonAction:(id)sender;

@property(nonatomic,retain) id<reloadParticipantTable>  reloadDelegate;
@property(nonatomic,retain) NSDictionary *dictDetail;
@property(nonatomic,retain) NSString *participantID;
@property(nonatomic,retain) NSString *eventID;
@end
