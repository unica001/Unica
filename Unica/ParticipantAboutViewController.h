//
//  ParticipantAboutViewController.h
//  Unica
//
//  Created by Ram Niwas on 08/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticipantAboutViewController : UIViewController{
    
    __weak IBOutlet UIWebView *webView;
}
@property(nonatomic,retain) NSString *aboutString;
@end
