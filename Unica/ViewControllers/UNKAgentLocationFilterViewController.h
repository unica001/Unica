//
//  UNKAgentLocationFilterViewController.h
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleageAgentLocationFilter <NSObject>

-(void)agentLocationFilter:(NSString*)index;

@end

@interface UNKAgentLocationFilterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate,CLLocationManagerDelegate>{

    __weak IBOutlet UITableView *_locationTable;
    __weak IBOutlet UIImageView *searchImage;

    __weak IBOutlet UIButton *_applyButton;
    __weak IBOutlet UIView *_locationView;
    
    __weak IBOutlet UIView *_locationBackgroundView;
    
    NSTimer *_timer;
    NSString *_searchAddress;
    
    NSMutableArray *searchArray;
    NSMutableDictionary *_filterDictionaty;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    UILabel *messageLabel;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyBtnFloatConstant;
@property (nonatomic,retain) id<deleageAgentLocationFilter> agentLocation;

-(void)searchLocationData;
- (IBAction)applyButton_clicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property ( nonatomic) double lat;
@property ( nonatomic) double lon;
@property ( nonatomic,retain) NSString *addressString;

@end
