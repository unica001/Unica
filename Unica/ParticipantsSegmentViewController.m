

#import "ParticipantsSegmentViewController.h"

@interface ParticipantsSegmentViewController (){
    
    NSInteger selectedIndex;
    NSString *selectedTap;
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

-(void)favouriteSliderController:(NSString*)eventID{
    
    // SetUp ViewControllers
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    
    // participantsView All
    participantsViewAll = [storyBoard instantiateViewControllerWithIdentifier:kparticipantsStoryboardID];
    participantsViewAll.title = @"ALL";
    
    participantsViewRecieved = [storyBoard instantiateViewControllerWithIdentifier:kparticipantsStoryboardID];
    participantsViewRecieved.title = @"RECEIVED";

    
    participantsViewSend = [storyBoard instantiateViewControllerWithIdentifier:kparticipantsStoryboardID];
    participantsViewSend.title = @"SEND";

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
    /*if (_timer) {
     if ([_timer isValid]){ [
     _timer invalidate];
     }
     _timer = nil;
     }
     _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];*/
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    [participantsViewAll reloadParticipantsData:selectedIndex type:selectedTap searchText:searchBar.text fromSearch: true];
    
    searchBar.text = @"";

}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    
    if (index == 0){
        selectedTap =  @"All";
        [participantsViewAll reloadParticipantsData:index type:selectedTap searchText:searchBar.text fromSearch: true];
    }
    else if (index == 1){
        selectedTap =  @"Received";
        [participantsViewRecieved reloadParticipantsData:index type:selectedTap searchText:searchBar.text fromSearch: true];
    }
    else if (index == 2){
        selectedTap =  @"Send";
        [participantsViewSend reloadParticipantsData:index type:selectedTap searchText:searchBar.text fromSearch: true];
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation-=s\


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction)backButtonAction:(id)sender {
}

- (IBAction)filterButtonAction:(id)sender {
    
    // Apply filter
}


@end
