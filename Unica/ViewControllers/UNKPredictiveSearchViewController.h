//
//  UNKPredictiveSearchViewController.h
//  Unica
//
//  Created by vineet patidar on 11/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchDelegate <NSObject>
-(void)getSearchData:(NSMutableDictionary *)searchDictionary type:(NSString *)type;
@end

@interface UNKPredictiveSearchViewController : UIViewController<
UISearchBarDelegate>{
    
    NSTimer *_timer;
    NSString *_searchAddress;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UITableView *_searchTable;
    
    NSMutableArray *searchArray;
}

@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) NSMutableDictionary *locationDict;
@property (nonatomic,retain) NSString *searchPlaceholder;

@property (nonatomic,retain) id <searchDelegate> delegate;
- (IBAction)doneButton_Clicked:(id)sender;
- (IBAction)backButton_Clicked:(id)sender;
@end
