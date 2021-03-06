//
//  UNKRecordExpressionViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKRecordExpressionViewC.h"

@interface UNKRecordExpressionViewC ()<YSLContainerViewControllerDelegate, delegateAgentService, delegateEvent, delegateForCheckApply, delegateRemoveAllFilter,delegateEvent> {
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
    recordAllParticipantViewC.title = @"VIEW PARTICIPANTS";
    
    recordExpressionListViewC = [storyBoard instantiateViewControllerWithIdentifier:@"UNKRecordExpressionListViewC"];
    recordExpressionListViewC.title = @"RECORD EXPRESSION";
    
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
    
    if ([self.fromView isEqualToString:@"meetingReport"]) {
        [menuButton setImage:[UIImage imageNamed:@"BackButton"]];
    }
    else{
        
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
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    searchField.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountryRecord]];
    if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountryRecord] isKindOfClass:[NSMutableArray class]]) {
        self.countryFilter = [dict valueForKey:kselectCountryRecord];
    } else {
        [self.countryFilter removeAllObjects];
    }
    if (self.countryFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *countyArray = [self.countryFilter valueForKey:Kid];
        countryIDsString = [countyArray componentsJoinedByString:@","];
    } else {
        countryIDsString = @"";
    }
    NSMutableDictionary *dictType = [Utility unarchiveData:[kUserDefault valueForKey:kselectTypeRecord]];
    if ([dictType isKindOfClass:[NSMutableDictionary class]] && [[dictType valueForKey:kselectTypeRecord] isKindOfClass:[NSMutableArray class]]) {
        self.typeFilter = [dictType valueForKey:kselectTypeRecord];
    } else {
        [self.typeFilter removeAllObjects];
    }
    if (self.typeFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *typeArray = [self.typeFilter valueForKey:@"filterId"];
        typeIDsString = [typeArray componentsJoinedByString:@","];
    } else {
        typeIDsString = @"";
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
        recordExpressionListViewC.pageNumber = 1;
        [recordExpressionListViewC recordParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    } else {
        recordAllParticipantViewC.pageNumber = 1;
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


#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    currentIndex = index;
    if (currentIndex == 0) {
        recordExpressionListViewC.pageNumber = 1;
        [recordExpressionListViewC recordParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    } else {
        recordAllParticipantViewC.pageNumber = 1;
        [recordAllParticipantViewC recordAllParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    }
    [controller viewWillAppear:YES];
}

- (void)searchInformation:(NSString *)strSearch {
    if (currentIndex == 0) {
        recordExpressionListViewC.pageNumber = 1;
        [recordExpressionListViewC recordParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    } else {
        recordAllParticipantViewC.pageNumber = 1;
        [recordAllParticipantViewC recordAllParticipantList:YES type:@"I" searchText:strSearch countryId:countryIDsString typeId:typeIDsString eventId:eventIDsString];
    }
}

#pragma mark - IBAction Methods
- (IBAction)filterButtonAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
    UNKFilterViewC *filterViewC = [sb instantiateViewControllerWithIdentifier:@"UNKFilterViewC"];
    filterViewC.incomingViewType = kRecordParticpantFilter;
    filterViewC.removeAllFilter = self;
    filterViewC.applyButtonDelegate = self;
    filterViewC.agentService = self;
    [self.navigationController pushViewController:filterViewC animated:YES];
    // Apply filter
}

#pragma mark - Filter delegate

-(void)checkApplyButtonAction:(NSInteger)index{
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
    isFromFilter = true;
}

-(void)removeAllFilter:(NSInteger)index{
    isFromFilter = true;
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
}

-(void)agentServiceMethod:(NSString *)index{
    self.isFilterApply = index;
    isFromFilter = true;
}

- (void)eventMethod:(NSString *)index {
    self.isFilterApply = index;
    isFromFilter = true;
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
@end
