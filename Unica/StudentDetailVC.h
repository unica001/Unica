//
//  StudentDetailVC.h
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "PNChart.h"

@interface StudentDetailVC : UIViewController<XYPieChartDelegate, XYPieChartDataSource,PNChartDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIButton *discardButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UITextView *remarkView;
    
    IBOutlet UIView *headerView;
}

@property (strong, nonatomic) IBOutlet XYPieChart *pieChartLeft;
//@property (nonatomic) PNPieChart *pieChart;
@property (strong, nonatomic) IBOutlet PNPieChart *pieChart;
@property (nonatomic,retain) NSMutableDictionary *detail;
@property (nonatomic,retain) NSString *isEdit;
@property (nonatomic, strong) NSString *eventName;
- (IBAction)discardButton_Action:(id)sender;
- (IBAction)saveButton_Action:(id)sender;

@end
