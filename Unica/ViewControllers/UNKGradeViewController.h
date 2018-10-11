//
//  UNKGradeViewController.h
//  Unica
//
//  Created by vineet patidar on 02/09/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButtonStep4.h"

@protocol delegateGradingSelection <NSObject>
-(void)selectedGrading:(NSMutableDictionary*)dictionary index:(NSInteger)index;
@end

@interface UNKGradeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

    __weak IBOutlet UITableView *gradingTable;
    
}
@property (nonatomic,retain) id <delegateGradingSelection> gradingDelegate;
@property (nonatomic,retain) NSMutableArray *gradingArray;

@end
