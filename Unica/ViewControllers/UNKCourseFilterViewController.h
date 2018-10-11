//
//  UNKCourseFilterViewController.h
//  Unica
//
//  Created by vineet patidar on 28/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "countryDataCell.h"

@protocol delegateForCheckApplyButtonAction <NSObject>
- (void)checkApplyButtonAction:(NSInteger)index;

@end

@interface UNKCourseFilterViewController : UIViewController


<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextFieldDelegate>{
    
    __weak IBOutlet UITableView *courseFilterTable;
    __weak IBOutlet NSLayoutConstraint *headerViewY_Axis;
    __weak IBOutlet UIImageView *searchImage;
    __weak IBOutlet UITextField *_searchTextField;
    __weak IBOutlet UIButton *_applyButton;
    __weak IBOutlet UIView *_locationView;
    
    __weak IBOutlet UIView *_locationBackgroundView;
    
    NSTimer *_timer;
    NSString *_searchAddress;
    
    NSMutableArray *searchArray;
    NSMutableArray *filterArray;
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    UILabel *messageLabel;
    __weak IBOutlet NSLayoutConstraint *headerViewHeight;
    __weak IBOutlet UITableView *dataTable;
}


@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) id<delegateForCheckApplyButtonAction> applyButtonDelegate;

@property (nonatomic,retain) NSMutableArray *institutionFilter;
@property (nonatomic,retain) NSMutableArray *countryFilter;
@property (nonatomic,retain) NSMutableArray *scholarShipFilter;
@property (nonatomic,retain) NSMutableArray *perfectFilter;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyBtnFloatConstant;

@property (nonatomic,retain) NSMutableArray *eventCityFilterArray;
@property (nonatomic,retain) NSMutableArray *eventCountryFilterArray;


- (IBAction)applyButton_clicked:(id)sender;
@end
