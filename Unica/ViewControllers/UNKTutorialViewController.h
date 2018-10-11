//
//  UNKTutorialViewController.h
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKTutorialViewController : UIViewController<UIScrollViewDelegate>{

    __weak IBOutlet UIScrollView *_scrollview;
    NSInteger _indexOfPage;
    __weak IBOutlet UIPageControl *_pageIndicator;
}

@end
