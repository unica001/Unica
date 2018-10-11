//
//  UNKDocumentViewController.m
//  Unica
//
//  Created by Chankit on 8/1/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//


#import "UNKDocumentViewController.h"
#import "Documentcell.h"

@interface UNKDocumentViewController ()
{
    NSMutableArray *selectedFiles;
}

@end

@implementation UNKDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationController.navigationBarHidden = YES;
    
    searchArray = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSError *error;
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    
    
    NSLog(@"%@", directoryContents);
    NSLog(@"files %@",directoryContents);
    
    NSArray *filter = @[@"*.doc", @".docx", @"pdf"];
    NSArray *contentss = [directoryContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"((pathExtension IN[cd] %@) OR (lastPathComponent IN[cd] %@)) ", filter, filter]];

    
    searchArray = [[NSMutableArray alloc]initWithArray:contentss];
    //searchArray = [[NSMutableArray alloc]initWithArray:directoryContents];
    selectedFiles =[[NSMutableArray alloc] init];
    
}


#pragma mark - APIS
/****************************
 * Function Name : - getSearchData
 * Create on : - 14 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for move in previous screen
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/



#pragma  mark - Table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [searchArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
       Documentcell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"Documentcell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.fileNameHightConstraint.constant =[Utility getTextHeight:[searchArray objectAtIndex:indexPath.row] size:CGSizeMake(kiPhoneWidth-60, CGFLOAT_MAX) font:kDefaultFontForApp];

    cell.fileNameLabel.text = [searchArray objectAtIndex:indexPath.row];
    if([selectedFiles containsObject:[searchArray objectAtIndex:indexPath.row]])
    {
        cell.checkImageView.image =[UIImage imageNamed:@"Checked"];
    }
    else
    {
        cell.checkImageView.image =[UIImage imageNamed:@"unchecked_gray"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([Utility getTextHeight:[searchArray objectAtIndex:indexPath.row] size:CGSizeMake(kiPhoneWidth-60, CGFLOAT_MAX) font:kDefaultFontForApp]+10 <40)
        return 40;
    else
    return [Utility getTextHeight:[searchArray objectAtIndex:indexPath.row] size:CGSizeMake(kiPhoneWidth-60, CGFLOAT_MAX) font:kDefaultFontForApp]+10;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *localDocumentsDirectoryVideoFilePath = [documentsPath stringByAppendingPathComponent:[searchArray objectAtIndex:0]];
    
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:localDocumentsDirectoryVideoFilePath error:nil];
    
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    if(fileSize> (1024*1024)*2)
    {
          [Utility showAlertViewControllerIn:self title:@"" message:@"Max file size is 2MB" block:^(int index){}];
    }
    else{
        if([selectedFiles containsObject:[searchArray objectAtIndex:indexPath.row]])
        {
            [selectedFiles removeObject:[searchArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [selectedFiles addObject:[searchArray objectAtIndex:indexPath.row]];
        }
        [_searchTable reloadData];

    }
   
       
   
}

#pragma  mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = NO;
    return YES;
}



#pragma mark - Button clicked Action

/****************************
 * Function Name : - button clicked Action
 * Create on : - 14 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for get button clicked Action
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (IBAction)doneButton_Clicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(getDocumentData:)]) {
        [self.delegate getDocumentData:selectedFiles];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
}

- (IBAction)backButton_Clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

@end

