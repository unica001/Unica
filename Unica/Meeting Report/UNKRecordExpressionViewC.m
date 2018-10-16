//
//  UNKRecordExpressionViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKRecordExpressionViewC.h"

@interface UNKRecordExpressionViewC ()<YSLContainerViewControllerDelegate> {
    YSLContainerViewController *containerVC;
    
    UNKRecordExpressionListViewC *recordExpressionListViewC;
    UNKRecordAllParticipantViewC *recordAllParticipantViewC;
    
    NSInteger currentIndex;
    NSTimer *_timer;

    NSString *countryIDsString;
    NSString *typeIDsString;
    NSString *eventIDsString;
    NSString *strSearch;
    BOOL isFromFilter;
}

@end

@implementation UNKRecordExpressionViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _countryFilter = [[NSMutableArray alloc] init];
    _typeFilter = [[NSMutableArray alloc] init];
    _eventFilter = [[NSMutableArray alloc] init];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Student" bundle:[NSBundle mainBundle]];
    
    recordAllParticipantViewC = [storyBoard instantiateViewControllerWithIdentifier:@"UNKRecordAllParticipantViewC"];
    recordAllParticipantViewC.title = @"View Participant";
    
    recordExpressionListViewC = [storyBoard instantiateViewControllerWithIdentifier:@"UNKRecordExpressionListViewC"];
    recordExpressionListViewC.title = @"Record Expression";
    
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[recordExpressionListViewC, recordAllParticipantViewC]
                                                            topBarHeight:0
                                                    parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:14];
    containerVC.menuBackGroudColor = kDefaultBlueColor;
    containerVC.menuItemSelectedTitleColor = [UIColor whiteColor];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];

    containerVC.menuIndicatorColor = [UIColor whiteColor];
    [self.viewContainer addSubview:containerVC.view];
    self.isFilterApply = @"1";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [menuButton setTarget: self.revealViewController];
            [menuButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    }
    self.revealViewController.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountryRecord]];
    if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountryRecord] isKindOfClass:[NSMutableArray class]]) {
        self.countryFilter = [dict valueForKey:kselectCountryRecord];
    }
    if (self.countryFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *countyArray = [self.countryFilter valueForKey:Kid];
        countryIDsString = [countyArray componentsJoinedByString:@","];
    }
    NSMutableDictionary *dictType = [Utility unarchiveData:[kUserDefault valueForKey:kselectTypeRecord]];
    if ([dictType isKindOfClass:[NSMutableDictionary class]] && [[dictType valueForKey:kselectTypeRecord] isKindOfClass:[NSMutableArray class]]) {
        self.typeFilter = [dictType valueForKey:kselectTypeRecord];
    }
    if (self.typeFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *typeArray = [self.typeFilter valueForKey:@"filterId"];
        typeIDsString = [typeArray componentsJoinedByString:@","];
    }
    
    NSMutableDictionary *dictevent = [Utility unarchiveData:[kUserDefault valueForKey:kselectEventRecord]];
    if ([dictevent isKindOfClass:[NSMutableDictionary class]] && [[dictevent valueForKey:kselectEventRecord] isKindOfClass:[NSMutableArray class]]) {
        self.eventFilter = [dictevent valueForKey:kselectEventRecord];
    } else {
        [self.eventFilter removeAllObjects];
    }
    if (self.eventFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *eventArray = [self.eventFilter valueForKey:Kid];
        eventIDsString = [eventArray componentsJoinedByString:@","];
    } else {
        eventIDsString = @"";
    }
    strSearch = _searchBar.text;
    NSLog(@"Country id %@, type id %@ event id %@", countryIDsString, typeIDsString, eventIDsString);
    if (currentIndex == 0) {
        [recordExpressionListViewC recordParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    } else {
        [recordAllParticipantViewC recordAllParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction Methods
- (IBAction)tapBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    currentIndex = index;
    if (currentIndex == 0) {
        [recordExpressionListViewC recordParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    } else {
        [recordAllParticipantViewC recordAllParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    }
    [controller viewWillAppear:YES];
}

- (void)searchInformation:(NSString *)strSearch {
    if (currentIndex == 0) {
        [recordExpressionListViewC recordParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    } else {
        [recordAllParticipantViewC recordAllParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    }
}

#pragma  mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    strSearch = _searchBar.text;
    [self searchInformation:_searchBar.text];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (_timer) {
        if ([_timer isValid]){
            [ _timer invalidate];
        }
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];
    
}

-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"%@",_searchBar.text);
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    strSearch = _searchBar.text;
    [self searchInformation:_searchBar.text];
}

@end
