//
//  UNKInstitudeVideoViewController.m
//  Unica
//
//  Created by vineet patidar on 30/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKInstitudeVideoViewController.h"
#import "VideoCell.h"
#import "YTPlayerView.h"

@interface UNKInstitudeVideoViewController ()<YTPlayerViewDelegate>

@end

@implementation UNKInstitudeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _videoTabel.layer.cornerRadius = 5.0;
    [_videoTabel.layer setMasksToBounds:YES];
    
    _imageView.layer.cornerRadius = 5.0;
    [_imageView.layer setMasksToBounds:YES];
    
    isHude = YES;
    
}


-(void)getVideoLiberayData:(NSMutableDictionary *)selectedDictionary{
    
    _videoLiberayDictionary = selectedDictionary;
    _videoArray = [_videoLiberayDictionary valueForKey:kvideos];
    [_videoTabel reloadData];
    [collectionView reloadData];
    
    [self setHeadeViewData:0];
    
   /* NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    [dictionary setValue:[selectedDictionary valueForKey:kinstitute_id] forKey:kinstitute_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"institute_detail.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:isHude showSystemError:isHude completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                isHude = NO;
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _videoLiberayDictionary = [dictionary valueForKey:kAPIPayload];
                    _videoArray = [_videoLiberayDictionary valueForKey:kvideos];
                    [_videoTabel reloadData];
                    [collectionView reloadData];
                    
                    [self setHeadeViewData:0];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];*/
}

-(void)getInstitudeInfo:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    [dictionary setValue:[selectedDictionary valueForKey:kinstitute_id] forKey:kinstitute_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"institute_detail.php"];
    
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _videoLiberayDictionary = payloadDictionary;
                    [_videoTabel reloadData];
                    [self setHeadeViewData:0];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}

-(void)setHeadeViewData:(NSInteger)index{
    
    // name
    institudeNameLabel.text = [_videoLiberayDictionary valueForKey:kName];
    
    // image
    if (![[_videoLiberayDictionary valueForKey:kinstitute_image] isKindOfClass:[NSNull class]]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[_videoLiberayDictionary valueForKey:kinstitute_image]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%@",error);
        }];
    }
 
    // like
    
    if ([[_videoLiberayDictionary valueForKey:kis_like]boolValue] ==true || [[_videoLiberayDictionary valueForKey:kIslike]boolValue] ==true) {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"FavoriteTransparent"] forState:UIControlStateNormal];
    }
    else{
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"UnFavoriteTransparent"] forState:UIControlStateNormal];
    }
    
    
    // load video
    
    if (_videoArray.count>0) {
     NSString *str = [self extractYoutubeIdFromLink:[[_videoArray objectAtIndex:index] valueForKey:kvideos_url]];

        if (str.length>0) {
            [self.playerView loadWithVideoId:str];
        }
    }
    
}

#pragma mark - Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
}



-(NSString*)convertHtmlPlainText:(NSString*)HTMLString{
    
    NSData *HTMLData = [HTMLString dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:HTMLData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:NULL error:NULL];
    NSString *plainString = attrString.string;
    return plainString;
}

#pragma  mark - Collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_videoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionview cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
  
    [cell.cellTopButton addTarget:self action:@selector(cellTopButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.cellTopButton.tag = indexPath.row;
    
    
    NSString *str = [self extractYoutubeIdFromLink:[[_videoArray objectAtIndex:indexPath.row] valueForKey:kvideos_url]];
  
    if (str.length>0) {
        [cell.playerView loadWithVideoId:str];
    }
    
    if (![str isKindOfClass:[NSNull class]]) {
        
        NSString *videoUrl = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",str];
        
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:videoUrl] placeholderImage:[UIImage imageNamed:@"banner"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            NSLog(@"%@",error);
        }];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self setHeadeViewData:indexPath.row];
}

- (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(120, 60);
//}


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

- (IBAction)messageButton_clicked:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MessagePopViewController *messageView = [storyBoard instantiateViewControllerWithIdentifier:@"MessagePopViewController"];
    messageView.dictionary = self.institudeDictionary;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:messageView];
    [self presentViewController:nav animated:YES completion:nil];}



- (IBAction)likeButton_clicked:(id)sender {
    [self institudeLike:_videoLiberayDictionary];

}

- (IBAction)fbButton_clicked:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[_videoLiberayDictionary valueForKey:@"facebook_url"]]];
}

- (IBAction)twitterButton_clicked:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[_videoLiberayDictionary valueForKey:@"twitter_url"]]];
}

- (IBAction)linkedInButton_clicked:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[_videoLiberayDictionary valueForKey:@"linkedin_url"]]];
}

- (IBAction)youTubeButton_clicked:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[_videoLiberayDictionary valueForKey:@"youtube_url"]]];
}

-(void)cellTopButton_clicked:(UIButton *)sender{

    [self setHeadeViewData:sender.tag];
}

#pragma  APIs for Like/Unlike

-(void)institudeLike:(NSMutableDictionary*)videoDictionary{
    
    NSString *likeString;
    NSString *message;
    
    if ([[videoDictionary valueForKey:kis_like] boolValue] == true || [[videoDictionary valueForKey:kIslike] boolValue] == true) {
        likeString = @"false";
        message = @"Removing this from your Favourites ";
    }
    else{
        likeString = @"true";
        message = @"Adding this to your Favourites";
       
    }
    
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    
    [dictionary setValue:likeString forKey:kstatus];
    
    if ([_videoLiberayDictionary  valueForKey:Kid]) {
        [dictionary setValue:[_videoLiberayDictionary  valueForKey:Kid] forKey:kinstitute_id];
    }
    else{
        [dictionary setValue:[_videoLiberayDictionary  valueForKey:kinstitute_id] forKey:kinstitute_id];
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-like_institute.php"];
    
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
      
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    if (![self.incomingViewType isEqualToString:kFavourite]) {
                        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        [appDelegate getFavouriteList:@"student-fav-institutes.php" :kINSTITUDE];
                    }
                    
                    if ([self.institudeDictionary valueForKey:kis_like]) {
                        [self.institudeDictionary setValue:likeString forKey:kis_like];
                    }
                    else{
                        
                        if ([self.incomingViewType isEqualToString:kFavourite]) {
                            NSMutableDictionary *favDict = [[NSMutableDictionary alloc]init];
                            [_favouriteArray removeObject:self.institudeDictionary];
                            [favDict setValue:_favouriteArray forKey:kinstitute];
                            [UtilityPlist saveData:favDict fileName:kINSTITUDE];
                            
                        }
                        [self.institudeDictionary setValue:likeString forKey:kIslike];
                        
                      
                    }
                    
                    [self setHeadeViewData:0];
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}



@end
