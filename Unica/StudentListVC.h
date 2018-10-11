//
//  StudentListVC.h
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "GKActionSheetPicker.h"
@interface StudentListVC : UIViewController<SWRevealViewControllerDelegate,UISearchBarDelegate,GKActionSheetPickerDelegate>
{
    __weak IBOutlet UIBarButtonItem *_backButton;
    __weak IBOutlet UITableView *detailtable;
    
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UIButton *_filterButton;
    
    NSTimer *_timer;
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    UILabel *messageLabel;
    
    BOOL isShowHude;
    
    BOOL LoadMoreData;

}
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartLeft;
@property (nonatomic, strong) GKActionSheetPicker *picker;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;
@property (strong, nonatomic) UIWindow *window;


@end
