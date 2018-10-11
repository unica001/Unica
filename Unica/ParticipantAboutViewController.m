//
//  ParticipantAboutViewController.m
//  Unica
//
//  Created by Ram Niwas on 08/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "ParticipantAboutViewController.h"

@interface ParticipantAboutViewController ()

@end

@implementation ParticipantAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [webView loadHTMLString:self.aboutString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
