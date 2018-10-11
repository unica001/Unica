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

}

@end

@implementation UNKRecordExpressionViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Student" bundle:[NSBundle mainBundle]];
    
    recordAllParticipantViewC = [storyBoard instantiateViewControllerWithIdentifier:@"UNKRecordAllParticipantViewC"];
    recordAllParticipantViewC.title = @"All Participant";
    
    recordExpressionListViewC = [storyBoard instantiateViewControllerWithIdentifier:@"UNKRecordExpressionListViewC"];
    recordExpressionListViewC.title = @"Record Expression";
    
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[recordAllParticipantViewC, recordExpressionListViewC]
                                                            topBarHeight:0
                                                    parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:14];
    containerVC.menuBackGroudColor = kDefaultBlueColor;
    containerVC.menuItemSelectedTitleColor = [UIColor whiteColor];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];

    containerVC.menuIndicatorColor = [UIColor whiteColor];
    [self.viewContainer addSubview:containerVC.view];
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
    [controller viewWillAppear:YES];
}

- (void)searchInformation:(NSString *)strSearch {
    if (currentIndex == 1) {
        [recordExpressionListViewC recordParticipantList:YES type:@"I" searchText:strSearch];
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
    [self searchInformation:_searchBar.text];
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
    
    NSLog(@"%@",_searchBar.text);
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self searchInformation:_searchBar.text];
}

@end
