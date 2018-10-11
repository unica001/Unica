//
//  UNKMPStep4ViewController.h
//  Unica
//
//  Created by vineet patidar on 10/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKPredictiveSearchViewController.h"
#import "MPCountrySelectionCell.h"
@interface UNKMPStep4ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,searchDelegate,SWRevealViewControllerDelegate>{

    __weak IBOutlet UITableView *_miniprofileTable;
    __weak IBOutlet UITableView *_countryTable;

    __weak IBOutlet UIView *_viewCountryBG;
    
    __weak IBOutlet NSLayoutConstraint *countryTableWidth;
    __weak IBOutlet NSLayoutConstraint *countryViewWidth;
    NSMutableArray *_sectionTextArray;
    NSMutableArray *_priceArray;
    NSMutableArray *_predictLevel;
    NSMutableArray *_countryArray;
    NSMutableArray *_selectedCountryArray;

    NSMutableDictionary *_selectedPriceDictionary;
    
    NSInteger selectedScore;
    NSInteger deleteCountryIndex;

    __weak IBOutlet UIImageView *_countryImage;
    __weak IBOutlet UILabel *_countryNameLabel;
    __weak IBOutlet UIButton *_countryButton;
//    __weak IBOutlet NSLayoutConstraint *selectCountryLableWidth;
        
    __weak IBOutlet UIView *_backgroundView;
}
@property (nonatomic,retain) NSMutableDictionary *miniProfileDictionary;
@property (nonatomic,retain) NSMutableDictionary *editMPDictionary;
@property (nonatomic,retain) NSString *incomingViewType;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;

- (IBAction)finishButton_clicked:(id)sender;
- (IBAction)countyButton_clicked:(id)sender;
- (IBAction)infoButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;

@end
