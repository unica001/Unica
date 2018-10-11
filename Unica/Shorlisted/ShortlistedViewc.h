//
//  ShortlistedViewc.h
//  Unica
//
//  Created by Shilpa Sharma on 03/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortlistedViewc : UIViewController {
    NSMutableArray *_courseArray;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    BOOL isHude;
    UIView  *popupView;
    NSString *textMessage;
    NSString *subTitle;
    NSString *amount;
    UIView  *bgView;
    BOOL isInfoClicked;
}

@property (weak, nonatomic) IBOutlet UITableView *tblViewShortlisted;
@property (nonatomic,retain) NSString *isFilterApply;

@end
