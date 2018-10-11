//
//  UNKTutorialViewController.m
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKTutorialViewController.h"

@interface UNKTutorialViewController (){
    NSMutableArray *tutorialArray;
}

@end

@implementation UNKTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [self loadImages];
 
}


-(void)loadImages
{
    
    int scrollWidth=0;
    
    NSArray *subViews = _scrollview.subviews;
    
    for(UIView *view in subViews){
        [view removeFromSuperview];
    }
    
     tutorialArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    
    for (int i=0;i<tutorialArray.count;i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollWidth,0,kiPhoneWidth,kiPhoneHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Tutorial-%@",[tutorialArray objectAtIndex:i]]];

        [_scrollview addSubview:imageView];
        scrollWidth=scrollWidth+kiPhoneWidth;
        
        
        UIButton *buttonSkip = [[UIButton alloc]initWithFrame:CGRectMake(scrollWidth- (kiPhoneWidth-20), kiPhoneHeight-70,kiPhoneWidth-40, 70)];
        buttonSkip.backgroundColor = [UIColor clearColor];
        [buttonSkip addTarget:self action:@selector(skinButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollview addSubview:buttonSkip];
        buttonSkip.tag  = i;
  
        if (i == 2) {
           // [buttonSkip setTitle:@"Next" forState:UIControlStateNormal];
        }
        else{
       //[buttonSkip setTitle:@"Skip" forState:UIControlStateNormal];
        }
        [_scrollview  insertSubview:_pageIndicator aboveSubview:imageView];

    }
    
    [_scrollview setContentSize:CGSizeMake(scrollWidth, kiPhoneHeight)];
    
    
}


-(void)skinButton_clicked:(UIButton *)sender{

    [self performSegueWithIdentifier:kSignInViewSegueIdentifier sender:nil];
    
    NSLog(@"%ld",(long)sender.tag);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
        if ((_scrollview.contentSize.width) > _scrollview.contentOffset.x + kiPhoneWidth) {
            
            CGFloat pageWidth = self.view.frame.size.width;
            
            _indexOfPage =    floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            
            _pageIndicator.currentPage = _indexOfPage;
  
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
