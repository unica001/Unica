

#import "ParticipantsSegmentViewController.h"

@interface ParticipantsSegmentViewController() <delegateAgentService, delegateEvent, delegateForCheckApply, delegateRemoveAllFilter>{
    
    NSInteger selectedIndex;
    NSString *selectedTap;
    BOOL isFromFilter;
    NSString *countryIDsString;
    NSString *typeIDsString;
    NSTimer *_timer;
    NSInteger currentIndex;
}

@end

@implementation ParticipantsSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self favouriteSliderController:self.eventID];
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    searchField.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isFilterApply = @"1";
    NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountryParticipant]];
    if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountryParticipant] isKindOfClass:[NSMutableArray class]]) {
        self.countryFilter = [dict valueForKey:kselectCountryParticipant];
    } else {
        [self.countryFilter removeAllObjects];
    }
    if (self.countryFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *countyArray = [self.countryFilter valueForKey:Kid];
        countryIDsString = [countyArray componentsJoinedByString:@","];
    } else {
        countryIDsString = @"";
    }
    NSMutableDictionary *dictType = [Utility unarchiveData:[kUserDefault valueForKey:kselectTypeParticipant]];
    
    if ([dictType isKindOfClass:[NSMutableDictionary class]] && [[dictType valueForKey:kselectTypeParticipant] isKindOfClass:[NSMutableArray class]]) {
        self.typeFilter = [dictType valueForKey:kselectTypeParticipant];
    } else {
        [self.typeFilter removeAllObjects];
    }
    if (self.typeFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *typeArray = [self.typeFilter valueForKey:@"filterId"];
        typeIDsString = [typeArray componentsJoinedByString:@","];
    } else {
        typeIDsString = @"";
    }

    [self reloadSegment];
}

-(void)favouriteSliderController:(NSString*)eventID{
    
    // SetUp ViewControllers
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    
    // participantsView All
    participantsViewAll = [storyBoard instantiateViewControllerWithIdentifier:kparticipantsStoryboardID];
    participantsViewAll.title = @"ALL";
    
    participantsViewRecieved = [storyBoard instantiateViewControllerWithIdentifier:kparticipantsStoryboardID];
    participantsViewRecieved.title = @"RECEIVED";

    
    participantsViewSend = [storyBoard instantiateViewControllerWithIdentifier:kparticipantsStoryboardID];
    participantsViewSend.title = @"SENT";

    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[participantsViewAll,participantsViewRecieved,participantsViewSend]
                                                            topBarHeight:0
                                                    parentViewController:self];
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:12];
    containerVC.menuBackGroudColor = kDefaultBlueColor;
    containerVC.menuItemSelectedTitleColor = [UIColor whiteColor];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];
    containerVC.menuIndicatorColor = [UIColor whiteColor];
    [segmentView addSubview:containerVC.view];
}

#pragma  mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (_timer) {
        if ([_timer isValid]){ [
                                _timer invalidate];
        }
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];
    
}

-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
   
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    
    [self reloadSegment];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self reloadSegment];
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    currentIndex = index;
    [self reloadSegment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation-=s\


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - IBAction Methods
- (IBAction)backButtonAction:(id)sender {
}

- (IBAction)filterButtonAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
    UNKFilterViewC *filterViewC = [sb instantiateViewControllerWithIdentifier:@"UNKFilterViewC"];
    filterViewC.incomingViewType = kParticipantFilter;
    filterViewC.removeAllFilter = self;
    filterViewC.applyButtonDelegate = self;
    filterViewC.agentService = self;
    [self.navigationController pushViewController:filterViewC animated:YES];
    // Apply filter
}

#pragma mark - Filter delegate

-(void)reloadSegment{
    if (currentIndex == 0){
        selectedTap =  @"All";
        [participantsViewAll reloadParticipantsData:currentIndex type:selectedTap searchText:searchBar.text fromSearch: true countryId:countryIDsString typeId:typeIDsString];
    }
    else if (currentIndex == 1){
        selectedTap =  @"Received";
        [participantsViewRecieved reloadParticipantsData:currentIndex type:selectedTap searchText:searchBar.text fromSearch: true countryId:countryIDsString typeId:typeIDsString];
    }
    else if (currentIndex == 2){
        selectedTap =  @"Send";
        [participantsViewSend reloadParticipantsData:currentIndex type:selectedTap searchText:searchBar.text fromSearch: true countryId:countryIDsString typeId:typeIDsString];
    }
}

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

@end
