//
//  UNKGradeViewController.m
//  Unica
//
//  Created by vineet patidar on 02/09/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKGradeViewController.h"

@interface UNKGradeViewController ()

@end

@implementation UNKGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Gradings";
}


#pragma mark - Table view delegate methods



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.gradingArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[self.gradingArray objectAtIndex:section]valueForKey:@"divisions"]count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 40)];
    headerView.backgroundColor = [UIColor grayColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kiPhoneWidth-20, 40)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = kDefaultFontForApp;
    titleLabel.text = [[self.gradingArray objectAtIndex:section] valueForKey:@"name"];
    
    [headerView addSubview:titleLabel];
    
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text =  [NSString stringWithFormat:@"  %@",[[[[self.gradingArray objectAtIndex:indexPath.section] valueForKey:@"divisions"] objectAtIndex:indexPath.row] valueForKey:@"name"]];
   
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.gradingDelegate respondsToSelector:@selector(selectedGrading:index:)]) {
        [self.gradingDelegate selectedGrading:[[[self.gradingArray objectAtIndex:indexPath.section] valueForKey:@"divisions"] objectAtIndex:indexPath.row] index:indexPath.row];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
