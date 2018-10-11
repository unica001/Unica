//
//  UNKSMPStep3ViewController.m
//  Unica
//
//  Created by vineet patidar on 09/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKSMPStep3ViewController.h"
#import "MPSetp1Cell.h"
#import "MPStep1TextFieldCell.h"
#import "GreScoreCell.h"
#import "PredictLevelCell.h"
#import "UNKMPStep4ViewController.h"




@interface UNKSMPStep3ViewController ()
{
    NSMutableDictionary *_loginDictionary;
    NSIndexPath *currentTouchPosition;

}

@end

typedef enum _UNKMPSection {
    UNKMPInvalidScore = 1,
    UNKMPValidScore = 2,
    UNKMPPredictSection = 10,
    UNKMGMATSection = 11,
    UNKMSATSection = 12
    
} UNKMPSection;


@implementation UNKSMPStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sectionTextArray = [NSMutableArray arrayWithObjects:@"Do you have IELTS, TOEFL IBT, TOEFL CBT, PTE, GRE, SAT or GMAT scores?",@"I don't have valid scores",@"I have valid scores",@"How Do you rate your English Proficiency? Predict your level",nil];
    
    _GMATScoreArray = [[NSMutableArray alloc]initWithObjects:@"Date",@"Verbal(130-170)",@"Verbal%",@"Quantitative(130-170)",@"Quantitative%",@"Analytical Writing(0-6)",@"Analytical Writing%",@"Total Score",@"Total Score%", nil];
    
    
    _greScoreArray = [[NSMutableArray alloc]initWithObjects:@"Date",@"Verbal(130-170)",@"Verbal%",@"Quantitative(130-170)",@"Quantitative%",@"Analytical Writing(0-6)",@"Analytical Writing%", nil];
    
    _SATScoreArray = [[NSMutableArray alloc]initWithObjects:@"Date",@"Raw Score",@"Math Score",@"Reading Score",@"Writing Score",@"Language Score", nil];
    
    _miniProfileTable.layer.cornerRadius = 5.0;
    [_miniProfileTable.layer setMasksToBounds:YES];
    
    _selectedScoreArray = [[NSMutableArray alloc] init];
    _invalidScoreDictionary = [[NSMutableDictionary alloc] init];
    _selectedScoreDictionary = [[NSMutableDictionary alloc] init];
    _validScoreSelectedSectionArray = [[NSMutableArray alloc]init];
    dictQualifiedExamArray = [[NSMutableArray alloc] init];
    
    // get prect level date from  .plist
    
    NSMutableString *jsonData = (NSMutableString*)[[NSBundle mainBundle]pathForResource:@"predictLevel" ofType:@"json"];
    
    NSError *error;
    
    NSMutableString* fileContents = (NSMutableString*)[NSString stringWithContentsOfFile:jsonData encoding:NSUTF8StringEncoding error:&error];
    
    
    NSData *data = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    _predictLevel = [json valueForKey:@"predictLevel"];
    
    _loginDictionary= [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    if ([[_loginDictionary valueForKey:kmini_profile_status] boolValue] == true)
    {
        nextFullButton.hidden = YES;
        
    }
    
    [self setupInitialLayout];
    
    [self getExamTypeData];
    
    //[self setEditMiniProfileData];
    
    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = kDefaultlightBlue.CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor = [UIColor lightGrayColor].CGColor;
    sublayer.shadowOpacity = 1.0;
    sublayer.cornerRadius = 5.0;
  sublayer.frame = CGRectMake(_miniProfileTable.frame.origin.x, _miniProfileTable.frame.origin.y+40, _miniProfileTable.frame.size.width, _miniProfileTable.frame.size.height-100);    [self.view.layer addSublayer:sublayer];
    [self.view.layer addSublayer:_miniProfileTable.layer];
}


-(void)setEditMiniProfileData{
    
    NSLog(@"%@",self.miniProfileDictionary);
    NSLog(@"%@",self.editMPDictionary);
    
    if ([[self.editMPDictionary valueForKey:kValid_scores]boolValue] == NO) {
        
        [self.miniProfileDictionary setValue:@"false" forKey:kValid_scores];
        
        NSString *ielts = [[self.editMPDictionary  valueForKey:@"english_exam_level"] valueForKey:@"IELTS"];
        
        NSString *toffel = [[self.editMPDictionary  valueForKey:@"english_exam_level"] valueForKey:@"TOEFLIBT"];
        
        selecteInvalidScoreDict = [[NSMutableDictionary alloc]init];
        [selecteInvalidScoreDict setValue:ielts forKey:@"IELTS"];
        [selecteInvalidScoreDict setValue:toffel forKey:@"TOEFLIBT"];
        _selectedHeaderString = @"1";
        
        NSError * err;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:selecteInvalidScoreDict options:0 error:&err];
        NSString *stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [self.miniProfileDictionary setValue:stringData forKey:kenglish_exam_level];
    }
    else if ([[self.editMPDictionary valueForKey:kValid_scores]boolValue] == YES) {
        [self.miniProfileDictionary setValue:@"true" forKey:kValid_scores];
        _selectedHeaderString = @"2";
    }
    
   
    
    NSMutableArray *editExamArray = [self.editMPDictionary valueForKey:kQualified_exams];
    
    NSArray * newArray =
    [[NSOrderedSet orderedSetWithArray:editExamArray] array];
    editExamArray =[[NSMutableArray alloc] initWithArray:newArray];
    [self.editMPDictionary setObject:editExamArray forKey:kQualified_exams];
    
    if (editExamArray.count>0) {
        
        for (NSMutableDictionary *dict in editExamArray) {
            
            NSPredicate *examIdPredicate = [NSPredicate predicateWithFormat:@"id == %@",[dict valueForKey:@"exam_id"]];
            
            NSArray *examFilterArray = [_examArray filteredArrayUsingPredicate:examIdPredicate];
            
            if (examFilterArray.count>0) {
                
                
                NSPredicate *scoreIDPredicate = [NSPredicate predicateWithFormat:@"id == %@",[dict valueForKey:@"score_id"]];
                
                NSArray *scoreArray = [[[examFilterArray objectAtIndex:0]valueForKey:kInputparameters] filteredArrayUsingPredicate:scoreIDPredicate];
                
                
                
                if([[[[examFilterArray objectAtIndex:0] valueForKey:@"title"] lowercaseString] isEqualToString:@"gmat"])
                {
                    _isGMAT =YES;
                    
                    if(![_validScoreSelectedSectionArray containsObject:[examFilterArray objectAtIndex:0]])
                    {
                        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
                        [_selectedScoreArray addObject:dic];
                        [_validScoreSelectedSectionArray addObject:[examFilterArray objectAtIndex:0]];
                    }
                    
                    
                    NSString *str = [self.editMPDictionary valueForKey:kgmat_exam_date];
                    self.GMATDateTextField.text = [str stringByReplacingOccurrencesOfString:@"0000-00-00" withString:@""];
                    [self.miniProfileDictionary setValue:self.GMATDateTextField.text forKey:kgmat_exam_date];
                    
                    
                    
                    self.GMATVerbalTextField.text = [[self.editMPDictionary valueForKey:kgmat_verbal_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.GMATVerbalTextField.text forKey:kgmat_verbal_score];
                    
                    self.GMATVerbalPercentageTextField.text = [[self.editMPDictionary valueForKey:kgmat_verbal] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.GMATVerbalPercentageTextField.text forKey:kgmat_verbal];
                    
                    self.GMATQuantitativeTextField.text = [[self.editMPDictionary valueForKey:kgmat_quantitative_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.GMATQuantitativeTextField.text forKey:kgmat_quantitative_score];
                    
                    self.GMATQuantitativePercentageTextField.text = [[self.editMPDictionary valueForKey:kgmat_quantitative] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.GMATQuantitativePercentageTextField.text forKey:kgmat_quantitative];
                    
                    self.GMATAnalyticalTextField.text = [[self.editMPDictionary valueForKey:kgmat_analytical_writing_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.GMATAnalyticalTextField.text forKey:kgmat_analytical_writing_score];
                    
                    self.GMATAnalyticalPercentageTextField.text = [[self.editMPDictionary valueForKey:kgmat_analytical_writing] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.GMATAnalyticalPercentageTextField.text forKey:kgmat_analytical_writing];
                    
                    self.GMATTotalScoreTextField.text = [[self.editMPDictionary valueForKey:kgmat_Total_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.GMATTotalScoreTextField.text forKey:kgmat_Total_score];
                    
                    self.GMATTotalScorePercentageTextField.text = [[self.editMPDictionary valueForKey:kgmat_Total_Percentage] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.GMATTotalScorePercentageTextField.text forKey:kgmat_Total_Percentage];
                }
                if([[[[examFilterArray objectAtIndex:0] valueForKey:@"title"] lowercaseString] isEqualToString:@"gre"])
                {
                    _isGRE =YES;
                    if(![_validScoreSelectedSectionArray containsObject:[examFilterArray objectAtIndex:0]])
                    {
                        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
                        [_selectedScoreArray addObject:dic];
                        [_validScoreSelectedSectionArray addObject:[examFilterArray objectAtIndex:0]];
                    }
                    
                    self.dateTextField.text = [self.editMPDictionary valueForKey:kgre_exam_date];
                    [self.miniProfileDictionary setValue:self.dateTextField.text forKey:kgre_exam_date];
                    
                    self.verbalTextField.text = [[self.editMPDictionary valueForKey:kgre_verbal_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.verbalTextField.text forKey:kgre_verbal_score];
                    
                    self.verbalPercentageTextField.text = [[self.editMPDictionary valueForKey:kgre_verbal] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.verbalPercentageTextField.text forKey:kgre_verbal];
                    
                    self.quantitativeTextField.text = [[self.editMPDictionary valueForKey:kgre_quantitative_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.quantitativeTextField.text forKey:kgre_quantitative_score];
                    
                    self.quantitativePercentageTextField.text = [[self.editMPDictionary valueForKey:kgre_quantitative] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.quantitativePercentageTextField.text forKey:kgre_quantitative];
                    
                    self.analyticalTextField.text = [[self.editMPDictionary valueForKey:kgre_analytical_writing_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.analyticalTextField.text forKey:kgre_analytical_writing_score];
                    
                    self.analyticalPercentageTextField.text = [[self.editMPDictionary valueForKey:kgre_analytical_writing] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.analyticalPercentageTextField.text forKey:kgre_analytical_writing];
                }
                if([[[[examFilterArray objectAtIndex:0] valueForKey:@"title"] lowercaseString] isEqualToString:@"sat"])
                {
                    
                    _isSAT =YES;
                    if(![_validScoreSelectedSectionArray containsObject:[examFilterArray objectAtIndex:0]])
                    {
                        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
                        [_selectedScoreArray addObject:dic];
                        [_validScoreSelectedSectionArray addObject:[examFilterArray objectAtIndex:0]];
                    }
                    
                    self.SATDateTextField.text = [[self.editMPDictionary valueForKey:ksat_Date_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.SATDateTextField.text forKey:ksat_Date_score];
                    
                    self.SATRawTextField.text = [[self.editMPDictionary valueForKey:ksat_raw_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.SATRawTextField.text forKey:ksat_raw_score];
                    
                    self.SATMathTextField.text = [[self.editMPDictionary valueForKey:ksat_math_score]stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.SATMathTextField.text forKey:ksat_math_score];
                    
                    self.SATReadingTextField.text = [[self.editMPDictionary valueForKey:ksat_reading_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.SATReadingTextField.text forKey:ksat_reading_score];
                    
                    self.SATWritingTextField.text = [[self.editMPDictionary valueForKey:ksat_writing_language_score] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.SATWritingTextField.text forKey:ksat_writing_language_score];
                    
                    self.SATLanguageTextField.text = [[self.editMPDictionary valueForKey:ksat_language] stringByReplacingOccurrencesOfString:@"0.00" withString:@""];
                    [self.miniProfileDictionary setValue:self.SATWritingTextField.text forKey:ksat_language];
                }
                else
                {
                    if(![_validScoreSelectedSectionArray containsObject:[examFilterArray objectAtIndex:0]])
                    {
                       
                        [_validScoreSelectedSectionArray addObject:[examFilterArray objectAtIndex:0]];
                        if ([scoreArray count]>0) {
                            [_selectedScoreArray addObject:[scoreArray objectAtIndex:0]];
                        }
                        else
                        {
                            NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
                            [_selectedScoreArray addObject:dic];
                        }
                    }
                    
                   
                }
            }
        }
    }
    
    
    NSMutableDictionary *englishExamLevel = [self.editMPDictionary valueForKey:kenglish_exam_level];
    
    if (englishExamLevel.count>0) {
        
        NSPredicate *examIdPredicate = [NSPredicate predicateWithFormat:@"id == %@",[englishExamLevel valueForKey:@"IELTS"]];
        
        NSArray *examFilterArray = [_examArray filteredArrayUsingPredicate:examIdPredicate];
        
        NSLog(@"%@",examFilterArray);
        
        if (examFilterArray.count>0) {
            
            NSPredicate *scoreIDPredicate = [NSPredicate predicateWithFormat:@"id == %@",[englishExamLevel valueForKey:@"TOEFLIBT"]];
            
            //NSPredicate *scoreIDPredicate = [NSPredicate predicateWithFormat:@"id == %@",@"24"];
            
            if (examFilterArray.count>0) {
                NSArray *scoreArray = [[[examFilterArray objectAtIndex:0]valueForKey:kInputparameters] filteredArrayUsingPredicate:scoreIDPredicate];
                
                if (scoreArray.count>0) {
                    [selecteInvalidScoreDict setValue:[scoreArray objectAtIndex:0] forKey:@"IELTS"];
                    selecteInvalidScoreDict = [[NSMutableDictionary alloc]init];
                    [selecteInvalidScoreDict setValue:[examFilterArray objectAtIndex:0] forKey:@"TOEFLIBT"];
                }
                
            }
        }
        
        
        
    }
    
    
    [_miniProfileTable reloadData];
    
}


#pragma mark - APIs call
/****************************
 * Function Name : - getExamTypeData
 * Create on : - 16 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This method are used for call get type APIs
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getExamTypeData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"valid-exams.php"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    ;
                    _examArray = [payloadDictionary valueForKey:kExams];
                    
                    if ([self.incomingViewType isEqualToString:kMyProfile]) {
                        [self setEditMiniProfileData];
                        
                    }
                    
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


/****************************
 * Function Name : - setUPInitialLayout
 * Create on : - 03 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - In this function initilization all the basic control before screen load
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)setupInitialLayout{
    
    self.dateTextField.delegate = self;
    self.verbalTextField.delegate = self;
    self.verbalPercentageTextField.delegate = self;
    self.quantitativeTextField.delegate = self;
    self.quantitativePercentageTextField.delegate = self;
    self.analyticalTextField.delegate = self;
    self.analyticalPercentageTextField.delegate = self;
    
    
    // GMAT TEXT FIELD
    self.GMATDateTextField.delegate = self;
    self.GMATVerbalTextField.delegate = self;
    self.GMATVerbalPercentageTextField.delegate = self;
    self.GMATQuantitativeTextField.delegate = self;
    self.GMATQuantitativePercentageTextField.delegate = self;
    self.GMATAnalyticalTextField.delegate = self;
    self.GMATAnalyticalPercentageTextField.delegate = self;
    self.GMATTotalScoreTextField.delegate = self;
    self.GMATTotalScorePercentageTextField.delegate = self;
    
    
    // SAT
    
    self.SATDateTextField.delegate = self;
    self.SATRawTextField.delegate = self;
    self.SATMathTextField.delegate = self;
    self.SATReadingTextField.delegate = self;
    self.SATWritingTextField.delegate = self;
    self.SATLanguageTextField.delegate = self;
    
    
    //Intilize Common Options for TextField
    CGRect frame = CGRectMake(kiPhoneWidth-150,5, 120, 30);
    
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    //Setup  first name Field
    CGRect stateFrame = frame;
    stateFrame.size.width = 120;
    
    
    //GRE
    
    // date TextField
    self.dateTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.dateTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.dateTextField.userInteractionEnabled  = NO;
    self.dateTextField.textColor = [UIColor blackColor];
    self.dateTextField.tag = 500;
    
    // verbal TextField
    self.verbalTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.verbalTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.verbalTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    self.verbalTextField.textColor = [UIColor blackColor];
    self.verbalTextField.tag = 501;
    
    // verbal Percentage TextField
    self.verbalPercentageTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.verbalPercentageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.verbalPercentageTextField.keyboardType =UIKeyboardTypeDecimalPad;
    
    self.verbalPercentageTextField.textColor = [UIColor blackColor];
    self.verbalPercentageTextField.tag = 502;
    self.verbalTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    // quantitative TextField
    self.quantitativeTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.quantitativeTextField.textColor = [UIColor blackColor];
    self.quantitativeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.quantitativeTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    self.quantitativeTextField.tag = 503;
    
    
    // quantitative Percentage TextField
    self.quantitativePercentageTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.quantitativePercentageTextField.textColor = [UIColor blackColor];
    self.quantitativePercentageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.quantitativePercentageTextField.keyboardType =UIKeyboardTypeDecimalPad;
    self.quantitativePercentageTextField.tag = 504;
    
    
    // analytical TextField
    self.analyticalTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.analyticalTextField.textColor = [UIColor blackColor];
    self.analyticalTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.analyticalTextField.keyboardType =UIKeyboardTypeDecimalPad;
    self.analyticalTextField.tag = 505;
    
    // analytical Percentage TextField
    self.analyticalPercentageTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.analyticalPercentageTextField.textColor = [UIColor blackColor];
    self.analyticalPercentageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.analyticalPercentageTextField.keyboardType =UIKeyboardTypeDecimalPad;
    self.analyticalPercentageTextField.returnKeyType = UIReturnKeyDone;
    self.analyticalPercentageTextField.tag = 506;
    
    
    //GMAT
    
    // GMATEDate TextField
    self.GMATDateTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.GMATDateTextField.textColor = [UIColor blackColor];
    self.GMATDateTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.GMATDateTextField.returnKeyType = UIReturnKeyNext;
    self.GMATDateTextField.tag = 601;
    self.GMATDateTextField.userInteractionEnabled  = NO;
    //self.verbalTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    // GMAT Verbal TextField
    self.GMATVerbalTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.GMATVerbalTextField.textColor = [UIColor blackColor];
    self.GMATVerbalTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.GMATVerbalTextField.returnKeyType = UIReturnKeyNext;
    self.GMATVerbalTextField.tag = 602;
    self.GMATVerbalTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    
    // GMATVerbal Percentage TextField
    self.GMATVerbalPercentageTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.GMATVerbalPercentageTextField.textColor = [UIColor blackColor];
    self.GMATVerbalPercentageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.GMATVerbalPercentageTextField.returnKeyType = UIReturnKeyNext;
    self.GMATVerbalPercentageTextField.tag = 603;
    self.GMATVerbalPercentageTextField.keyboardType =UIKeyboardTypeDecimalPad;
    
    // GMATQuantitative  TextField
    self.GMATQuantitativeTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.GMATQuantitativeTextField.textColor = [UIColor blackColor];
    self.GMATQuantitativeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.GMATQuantitativeTextField.returnKeyType = UIReturnKeyNext;
    self.GMATQuantitativeTextField.tag = 604;
    self.GMATQuantitativeTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    // GMATQuantitative Percentage  TextField
    self.GMATQuantitativePercentageTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.GMATQuantitativePercentageTextField.textColor = [UIColor blackColor];
    self.GMATQuantitativePercentageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.GMATQuantitativePercentageTextField.returnKeyType = UIReturnKeyNext;
    self.GMATQuantitativePercentageTextField.tag = 605;
    self.GMATQuantitativePercentageTextField.keyboardType =UIKeyboardTypeDecimalPad;
    
    // GMATAnalytical TextField
    self.GMATAnalyticalTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.GMATAnalyticalTextField.textColor = [UIColor blackColor];
    self.GMATAnalyticalTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.GMATAnalyticalTextField.returnKeyType = UIReturnKeyNext;
    self.GMATAnalyticalTextField.tag = 606;
    self.GMATAnalyticalTextField.keyboardType =UIKeyboardTypeDecimalPad;
    
    
    
    //GMATAnalytical Percentage TextField
    self.GMATAnalyticalPercentageTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.GMATAnalyticalPercentageTextField.textColor = [UIColor blackColor];
    self.GMATAnalyticalPercentageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.GMATAnalyticalPercentageTextField.returnKeyType = UIReturnKeyNext;
    self.GMATAnalyticalPercentageTextField.tag = 607;
    self.GMATAnalyticalPercentageTextField.keyboardType =UIKeyboardTypeDecimalPad;
    
    // GMAT TotalScore TextField
    self.GMATTotalScoreTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.GMATTotalScoreTextField.textColor = [UIColor blackColor];
    self.GMATTotalScoreTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.GMATTotalScoreTextField.returnKeyType = UIReturnKeyNext;
    self.GMATTotalScoreTextField.tag = 608;
    self.GMATTotalScoreTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    // GMAT TotalScore Percentage TextField
    self.GMATTotalScorePercentageTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.GMATTotalScorePercentageTextField.textColor = [UIColor blackColor];
    self.GMATTotalScorePercentageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.GMATTotalScorePercentageTextField.returnKeyType = UIReturnKeyNext;
    self.GMATTotalScorePercentageTextField.tag = 608;
    self.GMATTotalScorePercentageTextField.keyboardType =UIKeyboardTypeDecimalPad;
    
    
    // SAT
    
    // SATDate TextField
    
    
    
    self.SATDateTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.SATDateTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.SATDateTextField.textColor = [UIColor blackColor];
    self.SATDateTextField.tag = 700;
    self.SATDateTextField.userInteractionEnabled = NO;
    // self.SATDateTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    // SAT Verbal TextField
    self.SATRawTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.SATRawTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.SATRawTextField.textColor = [UIColor blackColor];
    self.SATRawTextField.tag = 701;
    self.SATRawTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    // SATVerbal Percentage TextField
    self.SATMathTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.SATMathTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.SATMathTextField.textColor = [UIColor blackColor];
    self.SATMathTextField.tag = 702;
    self.SATMathTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    // SATQuantitative TextField
    self.SATReadingTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.SATReadingTextField.textColor = [UIColor blackColor];
    self.SATReadingTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.SATReadingTextField.tag = 703;
    self.SATReadingTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    // SATQuantitative Percentage TextField
    self.SATWritingTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.SATWritingTextField.textColor = [UIColor blackColor];
    self.SATWritingTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.SATWritingTextField.tag = 704;
    self.SATWritingTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    
    //  SATAnalytical TextField
    self.SATLanguageTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.SATLanguageTextField.textColor = [UIColor blackColor];
    self.SATLanguageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.SATLanguageTextField.tag = 705;
    self.SATLanguageTextField.keyboardType =UIKeyboardTypeNumberPad;
    
    
    
    
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_examArray count]+6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // set number of section according to check mark button selection
    
    if (section == UNKMPValidScore && [_selectedHeaderString integerValue] == UNKMPValidScore ) { // for valid score section
        return 0;
    }
    else if (section == UNKMPPredictSection && [_selectedHeaderString integerValue] == UNKMPInvalidScore) {
        
        return [[[_examArray objectAtIndex:0] valueForKey:kInputparameters] count]+1;
    }
    else if ((section > 2 && section < [_examArray count]+3) && [_selectedHeaderString integerValue] == UNKMPValidScore) {
        
        if ([_validScoreSelectedSectionArray containsObject:[_examArray objectAtIndex:section-3]]) {
            
            return [[[_examArray objectAtIndex:section-3] valueForKey:kInputparameters] count];
        }
    }
    else if (_isGRE == YES && section == UNKMPPredictSection){
        return [_greScoreArray count];
    }
    else if (_isGMAT == YES && section == UNKMGMATSection){
        return [_GMATScoreArray count];
    }
    else if (_isSAT == YES && section == UNKMSATSection){
        return [_SATScoreArray count];
    }
    return 0;
}

/****************************
 * Function Name : - sectionButton_clicked
 * Create on : - 09 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This method are used for section top clicked event
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)sectionButton_clicked:(UIButton *)sender{
 
    
    if (sender.tag>0) {
    currentTouchPosition = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
       
    }
   
    if (sender.tag == UNKMPValidScore || sender.tag == UNKMPInvalidScore) {
        
        _selectedHeaderString = [NSString stringWithFormat:@"%@",[NSNumber numberWithUnsignedInteger:sender.tag]];
        
        if ([_selectedHeaderString integerValue] == 1) {
            [self.miniProfileDictionary setValue:@"false" forKey:kValid_scores];
            _isGRE = NO;
            _isGMAT = NO;
            _isSAT = NO;
            
            [_validScoreSelectedSectionArray removeAllObjects];
        }
        else  if ([_selectedHeaderString integerValue] == 2) {
            [self.miniProfileDictionary setValue:@"true" forKey:kValid_scores];
        }
        
    }
    else if ((sender.tag > 2 && sender.tag < [_examArray count]+3) && [_selectedHeaderString integerValue] == UNKMPValidScore) {
        // code for add or remove section valid score data
        if ([_validScoreSelectedSectionArray containsObject:[_examArray objectAtIndex:sender.tag-3]]) {
            
            [self setFeilds:[_examArray objectAtIndex:sender.tag-3]];
            NSDictionary *dic = [_examArray objectAtIndex:sender.tag-3];
            
           if([[dic valueForKey:kInputparameters] count]<=0)
            {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
                [_selectedScoreArray removeObject:dic];
            }
            else
            {
               NSMutableSet* set1 = [NSMutableSet setWithArray:_selectedScoreArray];
                NSMutableSet* set2 = [NSMutableSet setWithArray:[dic valueForKey:kInputparameters]];
                [set1 intersectSet:set2];
                NSArray* result = [set1 allObjects];
                if(result.count>0)
                {
                    [_selectedScoreArray removeObject:[result objectAtIndex:0]];
                }
            }
            [_validScoreSelectedSectionArray removeObject:[_examArray objectAtIndex:sender.tag-3]];
            
            if (sender.tag == 7) {
                _isGRE = NO;
            }
            if (sender.tag == 8) {
                _isGMAT = NO;
            }
            if (sender.tag == 9) {
                _isSAT = NO;
            }
        }
        else{
            
            if (sender.tag == 7) {
                _isGRE = YES;
            }
            if (sender.tag == 8) {
                _isGMAT = YES;
            }
            if (sender.tag == 9) {
                _isSAT = YES;
            }
            
            if(![_validScoreSelectedSectionArray containsObject:[_examArray objectAtIndex:sender.tag-3]])
            {
                [_validScoreSelectedSectionArray addObject:[_examArray objectAtIndex:sender.tag-3] ];
            }
            
        }
    }
    
    [_miniProfileTable reloadData];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{ // add fooder line for seperate sections
    if ((section == UNKMPValidScore && ![_selectedHeaderString isEqualToString:@"2"]) || (section == UNKMPPredictSection && _isGRE == YES) || (section == UNKMGMATSection && _isGMAT == YES)||(section == UNKMSATSection && _isSAT == YES)) {
        
        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
        UILabel *lblLine =[[UILabel alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 5)];
        lblLine.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        [footerView addSubview:lblLine];
        
        return footerView;
    }
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == UNKMPValidScore ||section == UNKMPInvalidScore ){
        
        return 40;
    }
    else if (section == 0){
        
        return 60;
    }
    else if ((section > 2 && section < [_examArray count]+3) && [_selectedHeaderString integerValue] == UNKMPValidScore) {
        
        return 40;
    }
    else  if (section == UNKMPPredictSection && [_selectedHeaderString integerValue] == UNKMPInvalidScore) {
        return 60;
    }
    else if (section > 2 && section < [_examArray count]+3){        return 0.1;
    }
    else if ([_selectedHeaderString integerValue] == UNKMPValidScore && section == UNKMPPredictSection &&  _isGRE == YES) {
        
        return 40;
    }

    else if ((_isGMAT == YES && section == UNKMGMATSection)||(_isSAT == YES && section == UNKMSATSection)){
        return 40;
    }
    
    
   
    return 0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    
    // heade label
    UILabel* headerLbl = [[UILabel alloc]init];
    headerLbl.font =[UIFont fontWithName:kFontSFUITextSemibold size:16];
    headerLbl.backgroundColor = [UIColor clearColor];
    headerLbl.numberOfLines= 0;
    headerLbl.frame =  CGRectMake(10, 0,kiPhoneWidth-20, 40);
    [headerView addSubview:headerLbl];
    
    // check mark button
    UIButton *roundButton = [[UIButton alloc]init];
    roundButton.tag = section+100;
    roundButton.backgroundColor = [UIColor clearColor];
    
    
    
    // creat seaction top button
    UIButton *sectionButton = [[UIButton alloc]init];
    sectionButton.backgroundColor = [UIColor clearColor];
    sectionButton.frame = CGRectMake(0, 0, kiPhoneWidth, 40);
    [sectionButton addTarget:self action:@selector(sectionButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    sectionButton.tag = section;
    
    
    
    
   /* // add live view in botton of section
    UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 39, kiPhoneWidth-20, 1)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineLabel];*/
    
    if (section == 0) {
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.frame = CGRectMake(0, 0, kiPhoneWidth, 60);
        headerLbl.frame =  CGRectMake(10, 0,kiPhoneWidth-20, 60);

        headerLbl.text = [_sectionTextArray objectAtIndex:section];
    }
    else   if (section == UNKMPValidScore ||section == UNKMPInvalidScore) {
        
        headerLbl.frame = CGRectMake(40, 0, kiPhoneWidth-60, 40);
        headerLbl.text = [_sectionTextArray objectAtIndex:section];
        headerLbl.textColor = [UIColor darkGrayColor];
        
        [headerView addSubview:roundButton];
        
        [headerView addSubview:sectionButton];
       
        headerView.backgroundColor = [UIColor whiteColor];

    }
    else if ((section > 2 && section < [_examArray count]+3) && [_selectedHeaderString integerValue] == UNKMPValidScore){
        // middle section
        headerLbl.frame = CGRectMake(90, 0, kiPhoneWidth-110, 40);
        headerLbl.text = [[_examArray objectAtIndex:section-3] valueForKey:Ktitle];
        headerLbl.textColor = [UIColor darkGrayColor];
        
        [headerView addSubview:roundButton];
        [headerView addSubview:sectionButton];
        headerView.backgroundColor = kDefaultlightBlue;

        
    }
    else  if (section == UNKMPPredictSection && [_selectedHeaderString integerValue] == UNKMPInvalidScore) {
        headerLbl.text = @"How Do you rate your English Proficiency? Predict your level";
        headerView.backgroundColor = [UIColor whiteColor];
        
        headerView.frame = CGRectMake(0, 0, kiPhoneWidth, 60);
        headerLbl.frame =  CGRectMake(10, 00,kiPhoneWidth-20, 60);

    }
    else  if ([_selectedHeaderString integerValue] == UNKMPValidScore && section == UNKMPPredictSection &&  _isGRE == YES) {
        headerLbl.text = @"Please fill your GRE scores";
        headerView.backgroundColor = [UIColor whiteColor];

    }
    else  if ([_selectedHeaderString integerValue] == UNKMPValidScore && section == UNKMGMATSection && _isGMAT == YES) {
        headerLbl.text = @"Please fill your GMAT scores";
        headerView.backgroundColor = [UIColor whiteColor];

    }
    else  if ([_selectedHeaderString integerValue] == UNKMPValidScore && section == UNKMSATSection && _isSAT == YES) {
        headerLbl.text = @"Please fill your SAT scores";
        headerView.backgroundColor = [UIColor whiteColor];

    }
    else{
        headerLbl.text = @"";
        headerLbl.hidden = YES;
    }
    
    
   /* if ( (section == UNKMPPredictSection && _isGRE == YES) || (section == UNKMGMATSection && _isGMAT == YES)||(section == UNKMSATSection && _isSAT == YES)){
        
        lineLabel.frame =  CGRectMake(10, 39, kiPhoneWidth-20, 1);
    }
    else{// remove line for score section
        lineLabel.backgroundColor = [UIColor clearColor];
    }*/
    
    
    // checmark selection
    
    roundButton.frame = CGRectMake(10, 8, 24, 24);
    if ([_selectedHeaderString isEqualToString:[NSString stringWithFormat:@"%@",[NSNumber numberWithUnsignedInteger:section]]]) {
        
        [roundButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    else{
        [roundButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    }
   
    
    // for valid score section data selction
    
    if (section > 2 && section < [_examArray count]+3) {
        
        roundButton.frame = CGRectMake(65, 8, 20, 20);

        if (([_validScoreSelectedSectionArray containsObject:[_examArray objectAtIndex:section-3]])) {
            [roundButton setBackgroundImage:[UIImage imageNamed:@"CheckBoxActive"] forState:UIControlStateNormal];
        }
        else{
            [roundButton setBackgroundImage:[UIImage imageNamed:@"CheckBox"] forState:UIControlStateNormal];
        }
        
    }
    
    return headerView;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if ((section == UNKMPValidScore && ![_selectedHeaderString isEqualToString:@"2"]) || (section == UNKMPPredictSection && _isGRE == YES) || (section == UNKMGMATSection && _isGMAT == YES)||(section == UNKMSATSection && _isSAT == YES)) {
        return 5.0;
    }
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == UNKMPPredictSection && [_selectedHeaderString integerValue] == UNKMPValidScore && _isGRE == YES) {
        static NSString *cellIdentifier  =@"GreScore";
        
        GreScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GreScoreCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
         UITextField *txtField = [cell.contentView viewWithTag:555];
     
        // date text field
        if (indexPath.row == 0) {
            
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.dateTextField];
     
        }
        else if (indexPath.row == 1) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.verbalTextField];
            self.verbalTextField.inputAccessoryView  = [self addToolBarOnKeyboard:101];
        }
        else if (indexPath.row == 2) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.verbalPercentageTextField];
            self.verbalPercentageTextField.inputAccessoryView  = [self addToolBarOnKeyboard:102];
            
        }
        else if (indexPath.row == 3) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.quantitativeTextField];
            self.quantitativeTextField.inputAccessoryView  = [self addToolBarOnKeyboard:103];
            
        }
        else if (indexPath.row == 4) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.quantitativePercentageTextField];
            self.quantitativePercentageTextField.inputAccessoryView  = [self addToolBarOnKeyboard:104];
            
        }
        else if (indexPath.row == 5) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.analyticalTextField];
            self.analyticalTextField.inputAccessoryView  = [self addToolBarOnKeyboard:105];
            
        }
        else if (indexPath.row == 6) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.analyticalPercentageTextField];
            self.analyticalPercentageTextField.inputAccessoryView  = [self addToolBarOnKeyboard:106];
            
        }
        
        cell.label.text = [_greScoreArray objectAtIndex:indexPath.row];
        
        return  cell;
        
    }
    
  else  if (indexPath.section == UNKMSATSection && [_selectedHeaderString integerValue] == UNKMPValidScore && _isSAT == YES) {
        static NSString *cellIdentifier  =@"GreScore";
        
        GreScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GreScoreCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        UITextField *txtField = [cell.contentView viewWithTag:555];
        
        // date text field
        if (indexPath.row == 0) {
            
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.SATDateTextField];
            
        }
        else if (indexPath.row == 1) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.SATRawTextField];
            self.SATRawTextField.inputAccessoryView  = [self addToolBarOnKeyboard:201];
        }
        else if (indexPath.row == 2) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.SATMathTextField];
            self.SATMathTextField.inputAccessoryView  = [self addToolBarOnKeyboard:202];
        }
        else if (indexPath.row == 3) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.SATReadingTextField];
            self.SATReadingTextField.inputAccessoryView  = [self addToolBarOnKeyboard:203];
        }
        else if (indexPath.row == 4) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.SATWritingTextField];
            self.SATWritingTextField.inputAccessoryView  = [self addToolBarOnKeyboard:204];
        }
        else if (indexPath.row == 5) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.SATLanguageTextField];
            self.SATLanguageTextField.inputAccessoryView  = [self addToolBarOnKeyboard:205];
        }
        
        cell.label.text = [_SATScoreArray objectAtIndex:indexPath.row];
        
        return  cell;
        
    }
    
  else  if (indexPath.section == UNKMGMATSection && [_selectedHeaderString integerValue] == UNKMPValidScore && _isGMAT == YES) {
        
        static NSString *cellIdentifier  =@"GreScore";
        
        GreScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GreScoreCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
      UITextField *txtField = [cell.contentView viewWithTag:555];

      
        // date text field
        if (indexPath.row == 0) {
            
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.GMATDateTextField];
         
            
        }
        else if (indexPath.row == 1) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.GMATVerbalTextField];
            self.GMATVerbalTextField.inputAccessoryView  = [self addToolBarOnKeyboard:301];
        }
        else if (indexPath.row == 2) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.GMATVerbalPercentageTextField];
            self.GMATVerbalPercentageTextField.inputAccessoryView  = [self addToolBarOnKeyboard:302];
        }
        else if (indexPath.row == 3) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.GMATQuantitativeTextField];
            self.GMATQuantitativeTextField.inputAccessoryView  = [self addToolBarOnKeyboard:303];
        }
        else if (indexPath.row == 4) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.GMATQuantitativePercentageTextField];
            self.GMATQuantitativePercentageTextField.inputAccessoryView  = [self addToolBarOnKeyboard:304];
        }
        else if (indexPath.row == 5) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.GMATAnalyticalTextField];
            self.GMATAnalyticalTextField.inputAccessoryView  = [self addToolBarOnKeyboard:305];
        }
        else if (indexPath.row == 6) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.GMATAnalyticalPercentageTextField];
            self.GMATAnalyticalPercentageTextField.inputAccessoryView  = [self addToolBarOnKeyboard:306];
        }
        else if (indexPath.row == 7) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.GMATTotalScoreTextField];
            self.GMATTotalScoreTextField.inputAccessoryView  = [self addToolBarOnKeyboard:307];
            
        }
        else if (indexPath.row == 8) {
            [txtField removeFromSuperview];
            [cell.contentView addSubview:self.GMATTotalScorePercentageTextField];
            self.GMATTotalScorePercentageTextField.inputAccessoryView  = [self addToolBarOnKeyboard:308];
        }
        
        cell.label.text = [_GMATScoreArray objectAtIndex:indexPath.row];
        
        return  cell;
        
    }
    
  else  if (indexPath.section == UNKMPPredictSection && [_selectedHeaderString integerValue] == UNKMPInvalidScore) {
        
        static NSString *cellIdentifier  =@"predictLavel";
        
        PredictLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PredictLevelCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        
        if (indexPath.section == 10 && indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        cell.headerHeightConstant.constant=0;
        // set background color of contain view according to cel count
        
        if (indexPath.row == 0) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:63.0f/255.0f blue:97.0f/255.0f alpha:1.0];
            
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.IELTSLabel.textColor = [UIColor whiteColor];
            cell.TOEFLLabel.textColor = [UIColor whiteColor];
            
            cell.viewLine1Height.constant = 50;
            cell.viewLine2Height.constant = 50;
        }
        
        else if (indexPath.row ==1 || indexPath.row ==2 ){
            cell.contentView.backgroundColor = [UIColor colorWithRed:160.0f/255.0f green:204.0f/255.0f blue:237.0f/255.0f alpha:1.0];
        }
        else if (indexPath.row ==3 || indexPath.row ==4){
            cell.contentView.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:223.0f/255.0f blue:190.0f/255.0f alpha:1.0];
        }
        else if (indexPath.row ==5 || indexPath.row ==6){
            cell.contentView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:227.0f/255.0f blue:142.0f/255.0f alpha:1.0];
        }
        else {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        
        // check condition for row height
        if (indexPath.row == 0) {
            
            // cell.titleLabel.text = [[[[_examArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row] valueForKey:Ktitle];
            cell.titleLabel.text = @"IELTS English\nLevel Description";
            
            NSString *IELTSString = [NSString stringWithFormat:@"%@\n(%@)",[[_examArray objectAtIndex:0] valueForKey:Ktitle],[[_examArray objectAtIndex:0] valueForKey:kSub_title]];
            
            cell.IELTSLabel.text =[NSString stringWithFormat:@"%@",IELTSString] ;
            
            NSString *TOEFLString = [NSString stringWithFormat:@"%@\n(%@)",[[_examArray objectAtIndex:1] valueForKey:Ktitle],[[_examArray objectAtIndex:1] valueForKey:kSub_title]];
            
            cell.TOEFLLabel.text =[NSString stringWithFormat:@"%@",TOEFLString] ;
        }
        else{
            
            cell.titleLabelHeight.constant = 30;
            cell.IELSLabelHeight.constant = 30;
            cell.TOEFlabelHeight.constant = 30;
            
            cell.titleLabel.text = [[[[_examArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Ktitle];
            
            cell.IELTSLabel.text = [[[[_examArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:kValue];
            
            cell.TOEFLLabel.text = [[[[_examArray objectAtIndex:1] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:kValue];
            if(_invalidScoreDictionary.count<=0)
            {
                
                NSString *IEletValue =[[[[_examArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Kid];
                NSString *tofelValue =[[[[_examArray objectAtIndex:1] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Kid];
                
                if (selecteInvalidScoreDict.count>0) {
                    
                    if((([[selecteInvalidScoreDict   valueForKey:@"IELTS"] isEqualToString:IEletValue]) && ([[selecteInvalidScoreDict valueForKey:@"TOEFLIBT"] isEqualToString:tofelValue])))
                    {
                        cell.layer.borderWidth = 1.0;
                        cell.layer.borderColor = kDefaultBlueColor.CGColor;
                        [cell.layer setMasksToBounds:YES];
                    }
                    
                    
                }
                else{
                    if(([[[self.editMPDictionary valueForKey:@"english_exam_level"]  valueForKey:@"IELTS"] isEqualToString:IEletValue])& ([[[self.editMPDictionary valueForKey:@"english_exam_level"]valueForKey:@"TOEFLIBT"] isEqualToString:tofelValue]))
                    {
                        
                        cell.layer.borderWidth = 1.0;
                        cell.layer.borderColor = kDefaultBlueColor.CGColor;
                        [cell.layer setMasksToBounds:YES];
                    }
                    
                }
                
                
            }
            
        }
        
        
        
        return cell;
    }
    
    static NSString *cellIdentifier  =@"step1";
    
    MPSetp1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MPSetp1Cell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ((indexPath.section > 2 && indexPath.section < [_examArray count]+3) && [_selectedHeaderString integerValue] == UNKMPValidScore) {
        cell.backgroundColor = kDefaultlightBlue;
        
        // set X_axis check mark button
        cell.checkButtonX_axis.constant = 80;
        
        NSString *_examString = [NSString stringWithFormat:@"%@ - %@",[[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row] valueForKey:Ktitle],[[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row] valueForKey:kValue]];
        
        
        cell.label.text = _examString;
        //
        //        cell.label.text =[[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row] valueForKey:Ktitle];
        
        
        // set check and unchecked selected button
        if ([_selectedScoreArray containsObject:[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row]]) {
            
            [cell.checkMarkButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
        }
        else{
            
            [cell.checkMarkButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 10 && indexPath.row == 0 && [_selectedHeaderString integerValue] == UNKMPInvalidScore) {
        //return;
        _invalidScoreDictionary = [_examArray objectAtIndex:0];
    }
    
    if (indexPath.section == UNKMPPredictSection && [_selectedHeaderString integerValue] == UNKMPInvalidScore) {
        
        NSString *ielts = [[[[_examArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Kid];
        
        NSString *toffel = [[[[_examArray objectAtIndex:1] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Kid];
        
        selecteInvalidScoreDict = [[NSMutableDictionary alloc]init];
        [selecteInvalidScoreDict setValue:ielts forKey:@"IELTS"];
        [selecteInvalidScoreDict setValue:toffel forKey:@"TOEFLIBT"];
        
        
        NSError * err;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:selecteInvalidScoreDict options:0 error:&err];
        NSString *stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [self.miniProfileDictionary setValue:stringData forKey:kenglish_exam_level];
        
    }else{
        if ((indexPath.section > 2 && indexPath.section < [_examArray count]+3) && [_selectedHeaderString integerValue] == UNKMPValidScore) {
            
            
            if ([_selectedScoreArray containsObject:[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row]]) {
                
                [_selectedScoreArray removeObject:[NSMutableDictionary dictionaryWithDictionary:[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row]]];
            }
            else{
                
                if (_selectedScoreArray.count >0) {
                    
                    NSArray *compareArray = [_selectedScoreArray copy];
                    
                    // remove item if already in array
                    for(int i=0; i<compareArray.count;i++)
                    {
                        NSMutableDictionary *dict =[[NSMutableDictionary alloc] initWithDictionary:[compareArray objectAtIndex:i]];
                        if ([[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] containsObject:dict]) {
                            
                            if ([dict isKindOfClass:[NSMutableDictionary class]]) {
                                [_selectedScoreArray removeObject:dict];
                            }
                            
                        }
                    }
                    // add selected item
                    [_selectedScoreArray addObject:[NSMutableDictionary dictionaryWithDictionary:[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row]]];
                  /*  if( [_selectedScoreArray containsObject:[NSMutableDictionary dictionaryWithDictionary:[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row]]])
                    {
                         [_selectedScoreArray removeObject:[NSMutableDictionary dictionaryWithDictionary:[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row]]];
                    }
                    else
                    {
                        [_selectedScoreArray addObject:[NSMutableDictionary dictionaryWithDictionary:[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row]]];
                    }*/
                    
                }
                else{
                    [_selectedScoreArray addObject:[NSMutableDictionary dictionaryWithDictionary:[[[_examArray objectAtIndex:indexPath.section-3] valueForKey:kInputparameters] objectAtIndex:indexPath.row]]];
                }
            }
            
        }
        
    }
    
    [_miniProfileTable reloadData];
    
    
    // GRE date  picker
    
    if ((indexPath.section == UNKMPPredictSection && [_selectedHeaderString integerValue] == UNKMPValidScore && _isGRE == YES && indexPath.row ==0)|| (indexPath.section == UNKMGMATSection && [_selectedHeaderString integerValue] == UNKMPValidScore && _isGMAT == YES && indexPath.row ==0)||(indexPath.section == UNKMSATSection && [_selectedHeaderString integerValue] == UNKMPValidScore && _isSAT == YES && indexPath.row ==0)) {
        
        self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*48] to:[NSDate date] interval:5 selectCallback:^(id selected) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //[dateFormatter setDateFormat:@"dd/MM/yyyy"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *selectedDate = [dateFormatter stringFromDate:selected];
            
            double seconds = [selected timeIntervalSince1970];
            
            
            if (indexPath.section == UNKMPPredictSection) {
                
                self.dateTextField.text = [NSString stringWithFormat:@"%@", selectedDate];
            }
            else if (indexPath.section == UNKMGMATSection){
                self.GMATDateTextField.text = [NSString stringWithFormat:@"%@", selectedDate];
            }
            else if (indexPath.section == UNKMSATSection){
                self.SATDateTextField.text = [NSString stringWithFormat:@"%@", selectedDate];
            }
            
        } cancelCallback:^{
        }];
        
        self.picker.title = @"Select Date";
        [self.picker presentPickerOnView:self.view];
        [self.picker selectDate:self.dateCellSelectedDate];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == UNKMPPredictSection && [_selectedHeaderString integerValue] == UNKMPInvalidScore && indexPath.row == 0){
        return 50;
    }
    else if (indexPath.section == UNKMPPredictSection && [_selectedHeaderString integerValue] == UNKMPInvalidScore) {
        
        return 40;
    }
    else if ((indexPath.section > 2 && indexPath.section < [_examArray count]+3) && [_selectedHeaderString integerValue] == UNKMPValidScore) {
    
        if ([_validScoreSelectedSectionArray containsObject:[_examArray objectAtIndex:indexPath.section-3]]) {
            
            return 40;
        }
    }
    
    else if (_isGRE == YES && indexPath.section == UNKMPPredictSection){
        
        return 40;
    }
    
    else if (_isGMAT == YES && indexPath.section == UNKMGMATSection){
        
        return 40;
    }
    else if (_isSAT == YES && indexPath.section == UNKMSATSection){
        
        return 40;
    }
    return 0;
    
}


#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    // GRE
    if (textField == self.dateTextField) {
        [self.verbalTextField becomeFirstResponder];
    }
    else if (textField == self.verbalTextField) {
        [self.verbalPercentageTextField becomeFirstResponder];
    }
    else if (textField == self.verbalPercentageTextField) {
        [self.quantitativeTextField becomeFirstResponder];
    }
    else if (textField == self.quantitativeTextField) {
        [self.quantitativePercentageTextField becomeFirstResponder];
    }
    else if (textField == self.quantitativePercentageTextField) {
        [self.analyticalTextField becomeFirstResponder];
    }
    else if (textField == self.analyticalTextField) {
        [self.analyticalPercentageTextField becomeFirstResponder];
    }
    else if (textField == self.analyticalPercentageTextField) {
        [self.analyticalPercentageTextField resignFirstResponder];
    }
    
    // SAT
    
    
    if (textField == self.SATDateTextField) {
        [self.SATRawTextField becomeFirstResponder];
    }
    else if (textField == self.SATRawTextField) {
        [self.SATMathTextField becomeFirstResponder];
    }
    else if (textField == self.SATMathTextField) {
        [self.SATReadingTextField becomeFirstResponder];
    }
    else if (textField == self.SATReadingTextField) {
        [self.SATWritingTextField becomeFirstResponder];
    }
    else if (textField == self.SATWritingTextField) {
        [self.SATLanguageTextField becomeFirstResponder];
    }
    else if (textField == self.SATLanguageTextField) {
        [self.SATLanguageTextField resignFirstResponder];
    }
    
    
    // GMAT
    
    if (textField == self.GMATDateTextField) {
        [self.GMATVerbalTextField becomeFirstResponder];
    }
    else if (textField == self.GMATVerbalTextField) {
        [self.GMATVerbalPercentageTextField becomeFirstResponder];
    }
    else if (textField == self.GMATVerbalPercentageTextField) {
        [self.GMATQuantitativeTextField becomeFirstResponder];
    }
    else if (textField == self.GMATQuantitativeTextField) {
        [self.GMATQuantitativePercentageTextField becomeFirstResponder];
    }
    else if (textField == self.GMATQuantitativePercentageTextField) {
        [self.GMATAnalyticalTextField becomeFirstResponder];
    }
    else if (textField == self.GMATAnalyticalTextField) {
        [self.GMATAnalyticalPercentageTextField becomeFirstResponder];
    }
    else if (textField == self.GMATAnalyticalPercentageTextField) {
        [self.GMATAnalyticalPercentageTextField becomeFirstResponder];
    }
    else if (textField == self.GMATAnalyticalPercentageTextField) {
        [self.GMATAnalyticalPercentageTextField becomeFirstResponder];
    }
    else if (textField == self.GMATTotalScoreTextField) {
        [self.GMATTotalScorePercentageTextField becomeFirstResponder];
    }
    else if (textField == self.GMATTotalScorePercentageTextField) {
        [self.GMATTotalScorePercentageTextField resignFirstResponder];
    }
    
    return  YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *strQueryString;
    if((range.length == 0) && (string.length > 0)){
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        strQueryString = [NSString stringWithFormat:@"%@%@%@",strStarting,string,strEnding];
    }
    else{
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        if(strEnding.length > 0)
            strEnding = [strEnding substringFromIndex:range.length];
        strQueryString = [NSString stringWithFormat:@"%@%@",strStarting,strEnding];
    }
    
    if(strQueryString.length == 0){
        return YES;
    }
    if(textField.keyboardType== UIKeyboardTypeDecimalPad)
    {
        NSString *pattern ;
        if(textField== self.analyticalTextField||textField==self.GMATAnalyticalTextField )
        {
            pattern =  @"^[0-9]{0,1}+(?:\\.[0-9]{0,2})?$";
        }
        else
        {
            pattern =  @"^[0-9]{0,3}+(?:\\.[0-9]{0,2})?$";
        }
        NSString *string1 = [textField.text stringByAppendingString:string];
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        
        NSRange textRange = NSMakeRange(0, string1.length);
        NSRange matchRange = [regex rangeOfFirstMatchInString:string1 options:NSMatchingReportProgress range:textRange];
        
        // Did we find a matching range
        if (matchRange.location != NSNotFound)
            return YES;
        else
            return NO;
    }
    if(textField== self.SATRawTextField ||textField== self.SATMathTextField||textField== self.SATReadingTextField||textField== self.SATWritingTextField||textField== self.SATLanguageTextField)
    {
        if(strQueryString.length >7){
            return NO;
        }
    }
    else
    {
        if(strQueryString.length >3){
            return NO;
        }
        
    }
    
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UNKMPStep4ViewController *_step4ViewController = segue.destinationViewController;
    _step4ViewController.miniProfileDictionary = _miniProfileDictionary;
    _step4ViewController.editMPDictionary =self.editMPDictionary;
    _step4ViewController.incomingViewType = self.incomingViewType;
    
}

- (IBAction)nextButton_clicked:(id)sender {
    
    
    NSLog(@"%@",_validScoreSelectedSectionArray);
    NSLog(@"%@",_selectedScoreArray);
    
    NSLog(@"%@",dictQualifiedExamArray);
    
    
    if ([self  validation]) {
        
        // for valid score data selection
        
        if ([_selectedHeaderString integerValue] == 2) {
            
            if (dictQualifiedExamArray) {
                [dictQualifiedExamArray removeAllObjects];
            }
            
            for (int i=0; i< [_validScoreSelectedSectionArray count]; i++) {
                
                
                /*if ([_selectedScoreArray count] >0 && [[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] ) {
                 
                 for (NSMutableDictionary *dict in _selectedScoreArray) {
                 if ([[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] containsObject:dict]) {
                 
                 NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                 NSLog(@"%@",[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid]);
                 
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                 [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                 [dict setValue:[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid] forKey:@"score_id"];
                 
                 [dictQualifiedExamArray addObject:dict];
                 }
                 
                 }
                 }*/
                if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"gre"])
                {
                    NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    [dict setValue:@"" forKey:@"score_id"];
                    if(![dictQualifiedExamArray containsObject:dict])
                    {
                        [dictQualifiedExamArray addObject:dict];
                    }
                    
                }
                else if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"gmat"])
                {
                    NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    [dict setValue:@"" forKey:@"score_id"];
                    if(![dictQualifiedExamArray containsObject:dict])
                    {
                        [dictQualifiedExamArray addObject:dict];
                    }
                    
                }
                else if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"sat"])
                {
                    NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    [dict setValue:@"" forKey:@"score_id"];
                    if(![dictQualifiedExamArray containsObject:dict])
                    {
                        [dictQualifiedExamArray addObject:dict];
                    }
                    
                }
                else
                {
//                    for (NSMutableDictionary *dict in _selectedScoreArray) {
//                        if ([[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] containsObject:dict]) {
//                            
//                            NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
//                            NSLog(@"%@",[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid]);
//                            
//                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//                            [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
//                            [dict setValue:[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid] forKey:@"score_id"];
//                            
//                            [dictQualifiedExamArray addObject:dict];
//                        }
//                        
//                    }
                    
                    for (NSMutableDictionary *dict in _selectedScoreArray) {
                        if ([[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] containsObject:dict]) {
                            
                            NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                            NSLog(@"%@",[dict valueForKey:Kid]);
                            
                            
                            
                            NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
                            [dict2 setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                            [dict2 setValue:[dict valueForKey:Kid] forKey:@"score_id"];
                            
                            if(![dictQualifiedExamArray containsObject:dict2])
                            {
                                [dictQualifiedExamArray addObject:dict2];
                            }
                            break;
                        }
                        
                    }
                }
                
            }
            
            NSError * err;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictQualifiedExamArray options:0 error:&err];
            NSString *qualifiedExamString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [self.miniProfileDictionary setValue:qualifiedExamString forKey:kQualified_exams];
        }
        
        // GMAT
        
        if (_isGMAT) {
            [self.miniProfileDictionary setValue:self.GMATDateTextField.text forKey:kgmat_exam_date];
            [self.miniProfileDictionary setValue:self.GMATVerbalTextField.text forKey:kgmat_verbal_score];
            [self.miniProfileDictionary setValue:self.GMATVerbalPercentageTextField .text forKey:kgmat_verbal];
            [self.miniProfileDictionary setValue:self.GMATQuantitativeTextField.text forKey:kgmat_quantitative_score];
            [self.miniProfileDictionary setValue:self.GMATQuantitativePercentageTextField.text forKey:kgmat_quantitative];
            [self.miniProfileDictionary setValue:self.GMATAnalyticalTextField.text forKey:kgmat_analytical_writing_score];
            [self.miniProfileDictionary setValue:self.GMATAnalyticalPercentageTextField.text forKey:kgmat_analytical_writing];
            [self.miniProfileDictionary setValue:self.GMATTotalScoreTextField.text forKey:kgmat_Total_score];
            [self.miniProfileDictionary setValue:self.GMATTotalScorePercentageTextField.text forKey:kgmat_Total_Percentage];
        }
        
        // SAT
        
        if (_isSAT) {
            
            [self.miniProfileDictionary setValue:self.SATDateTextField.text forKey:ksat_Date_score];
            [self.miniProfileDictionary setValue:self.SATRawTextField.text forKey:ksat_raw_score];
            [self.miniProfileDictionary setValue:self.SATMathTextField.text forKey:ksat_math_score];
            [self.miniProfileDictionary setValue:self.SATReadingTextField.text forKey:ksat_reading_score];
            [self.miniProfileDictionary setValue:self.SATWritingTextField.text forKey:ksat_writing_language_score];
            [self.miniProfileDictionary setValue:self.SATLanguageTextField.text forKey:ksat_language];
        }
        
        // gre
        if (_isGRE) {
            
            [self.miniProfileDictionary setValue:self.dateTextField.text forKey:kgre_exam_date];
            [self.miniProfileDictionary setValue:self.verbalTextField.text forKey:kgre_verbal_score];
            [self.miniProfileDictionary setValue:self.verbalPercentageTextField.text forKey:kgre_verbal];
            [self.miniProfileDictionary setValue:self.quantitativeTextField.text forKey:kgre_quantitative_score];
            [self.miniProfileDictionary setValue:self.quantitativePercentageTextField.text forKey:kgre_quantitative];
            [self.miniProfileDictionary setValue:self.analyticalTextField.text forKey:kgre_analytical_writing_score];
            [self.miniProfileDictionary setValue:self.analyticalPercentageTextField.text forKey:kgre_analytical_writing];
        }
        
        [self performSegueWithIdentifier:kMPStep4SegieIdentifier sender:nil];
    }
    
    
}


-(BOOL)validation{
    
    BOOL isRegistration = false;

    
    if ([_loginDictionary valueForKey:kmini_profile_status]) {
        if ([[_loginDictionary valueForKey:kmini_profile_status] boolValue] == false) {
            isRegistration = false;
        }
        else{
        isRegistration = true;
        }
    }
    
    NSMutableArray *qualifiedExam =[[NSMutableArray alloc] initWithArray:_validScoreSelectedSectionArray];
    
    for(int i=0;i<_validScoreSelectedSectionArray.count;i++)
    {
        if([[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] count]<=0)
        {
            [qualifiedExam removeObject:[_validScoreSelectedSectionArray objectAtIndex:i]];
        }
       
    }
    NSMutableArray *scoreidArray = [[NSMutableArray alloc] initWithArray:_selectedScoreArray];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [scoreidArray removeObject:dic];
    
    
    
    if ([_selectedHeaderString integerValue] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Do you have any exam score mention above" block:^(int index){
            
            NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
            [_miniProfileTable scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
        return false;
    }
    
    else if ([_selectedHeaderString integerValue] == 1 && [selecteInvalidScoreDict count] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your english proficiency score" block:^(int index){
            NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
            [_miniProfileTable scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
        }];
        return false;
    }
    else if(([_selectedHeaderString integerValue] == 2) &&(qualifiedExam.count!= scoreidArray.count))
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your exam score" block:^(int index){
           
                NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:scoreidArray.count+3];
                [_miniProfileTable scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && [_validScoreSelectedSectionArray count] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your exam and score" block:^(int index){

        }];
        return false;
    }

    else if ([_selectedHeaderString integerValue] == 2 && (self.dateTextField.text.length == 0  && _isGRE == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GRE exam Date" block:^(int index){
           
        CGPoint buttonPosition = [self.dateTextField convertPoint:CGPointZero toView:_miniProfileTable];
         [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
        
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.verbalTextField.text.length == 0  && _isGRE == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GRE verbal score" block:^(int index){
            
            CGPoint buttonPosition = [self.verbalTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.verbalTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!(([self.verbalTextField.text integerValue]>=130 && [self.verbalTextField.text integerValue]<=170)) && _isGRE == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GRE verbal score" block:^(int index) {
            
            CGPoint buttonPosition = [self.verbalTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            
            [self.verbalTextField becomeFirstResponder];
        }];
        return false;
    }
    
    else if ([_selectedHeaderString integerValue] == 2 && (self.verbalPercentageTextField.text.length == 0  && _isGRE == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GRE verbal score percentage" block:^(int index){
            
            CGPoint buttonPosition = [self.verbalPercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.verbalPercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ( _isGRE == YES && ([self.verbalPercentageTextField.text floatValue]>100 || [self.verbalPercentageTextField.text floatValue]<1))
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GRE Verbal percentage" block:^(int index){
            
            CGPoint buttonPosition = [self.verbalPercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.verbalPercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.quantitativeTextField.text.length == 0  && _isGRE == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GRE Quantitative Score" block:^(int index){
            
            CGPoint buttonPosition = [self.quantitativeTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.quantitativeTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!(([self.quantitativeTextField.text floatValue]>=130 && [self.quantitativeTextField.text floatValue]<=170)) && _isGRE == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GRE Quantitative Score" block:^(int index) {
            CGPoint buttonPosition = [self.quantitativeTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.quantitativeTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.quantitativePercentageTextField.text.length == 0  && _isGRE == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GRE Quantitative Score percentage" block:^(int index){
            
            CGPoint buttonPosition = [self.quantitativePercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.quantitativePercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if (_isGRE == YES && ([self.quantitativePercentageTextField.text floatValue]>100 || [self.quantitativePercentageTextField.text floatValue]<1))
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GRE Quantitative Score percentage" block:^(int index){
            
            CGPoint buttonPosition = [self.quantitativePercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.quantitativePercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.analyticalTextField.text.length == 0  && _isGRE == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GRE analytical score" block:^(int index){
            CGPoint buttonPosition = [self.analyticalTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.analyticalTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!(([self.analyticalTextField.text floatValue]>=0 && [self.analyticalTextField.text floatValue]<=6)) && _isGRE == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GRE analytical score" block:^(int index) {
            CGPoint buttonPosition = [self.analyticalTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.analyticalTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.analyticalPercentageTextField.text.length == 0  && _isGRE == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GRE analytical percentage" block:^(int index){
            
            CGPoint buttonPosition = [self.analyticalPercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.analyticalPercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if (_isGRE == YES && ([self.analyticalPercentageTextField.text floatValue]>100 || [self.analyticalPercentageTextField.text floatValue]<1))
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GRE analytical percentage" block:^(int index){
            CGPoint buttonPosition = [self.analyticalPercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.analyticalPercentageTextField becomeFirstResponder];
        }];
        return false;
    }

    else if ([_selectedHeaderString integerValue] == 2 && (self.GMATDateTextField.text.length == 0  && _isGMAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GMAT exam Date" block:^(int index){
            CGPoint buttonPosition = [self.GMATDateTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.GMATVerbalTextField.text.length == 0  && _isGMAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GMAT verbal score" block:^(int index){
            CGPoint buttonPosition = [self.GMATVerbalTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATVerbalTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!(([self.GMATVerbalTextField.text floatValue]>=130 && [self.GMATVerbalTextField.text floatValue]<=170)) && _isGMAT == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GMAT verbal score" block:^(int index) {
            CGPoint buttonPosition = [self.GMATVerbalTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATVerbalTextField becomeFirstResponder];
        }];
        return false;
    }
    
    else if ([_selectedHeaderString integerValue] == 2 && (self.GMATVerbalPercentageTextField.text.length == 0  && _isGMAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GMAT verbal score percentage" block:^(int index){
            CGPoint buttonPosition = [self.GMATVerbalPercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATVerbalPercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if (_isGMAT == YES && ([self.GMATVerbalPercentageTextField.text floatValue]>100 || [self.GMATVerbalPercentageTextField.text floatValue]<1))
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GMAT Verbal percentage" block:^(int index){
            CGPoint buttonPosition = [self.GMATVerbalPercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.GMATQuantitativeTextField.text.length == 0  && _isGMAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GMAT Quantitative Score" block:^(int index){
            CGPoint buttonPosition = [self.GMATQuantitativeTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATQuantitativeTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!(([self.GMATQuantitativeTextField.text floatValue]>=130 && [self.GMATQuantitativeTextField.text floatValue]<=170)) && _isGMAT == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GMAT Quantitative Score" block:^(int index) {
            
            CGPoint buttonPosition = [self.GMATQuantitativeTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATQuantitativeTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.GMATQuantitativePercentageTextField.text.length == 0  && _isGMAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GMAT Quantitative percentage" block:^(int index){
            CGPoint buttonPosition = [self.GMATQuantitativePercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATQuantitativePercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if (_isGMAT == YES && ([self.GMATQuantitativePercentageTextField.text floatValue]>100 || [self.GMATQuantitativePercentageTextField.text floatValue]<1))
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GMAT Quantitative percentage" block:^(int index){
            
            CGPoint buttonPosition = [self.GMATQuantitativePercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATQuantitativePercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.GMATAnalyticalTextField.text.length == 0  && _isGMAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GMAT analytical score" block:^(int index){
            
            CGPoint buttonPosition = [self.GMATAnalyticalTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATAnalyticalTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!(([self.GMATAnalyticalTextField.text floatValue]>=0 && [self.GMATAnalyticalTextField.text floatValue]<=6)) && _isGMAT == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GMAT analytical score" block:^(int index) {
            CGPoint buttonPosition = [self.GMATAnalyticalTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATAnalyticalTextField becomeFirstResponder];
        }];
        return false;
    }
    
    else if ([_selectedHeaderString integerValue] == 2 && (self.GMATAnalyticalPercentageTextField.text.length == 0  && _isGMAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GMAT analytical percentage" block:^(int index){
            CGPoint buttonPosition = [self.GMATAnalyticalPercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATAnalyticalPercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if (_isGMAT == YES && ([self.GMATAnalyticalPercentageTextField.text floatValue]>100 || [self.GMATAnalyticalPercentageTextField.text floatValue]<1))
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GMAT analytical percentage" block:^(int index){
            CGPoint buttonPosition = [self.GMATAnalyticalPercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATAnalyticalPercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.GMATTotalScoreTextField.text.length == 0  && _isGMAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GMAT Total score" block:^(int index){
            
            CGPoint buttonPosition = [self.GMATTotalScoreTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATTotalScoreTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(([self.GMATTotalScoreTextField.text integerValue]<1 ) && _isGMAT == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GMAT Total score" block:^(int index) {
            
            CGPoint buttonPosition = [self.GMATTotalScoreTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATTotalScoreTextField becomeFirstResponder];
        }];
        return false;
    }
    
    else if ([_selectedHeaderString integerValue] == 2 && (self.GMATTotalScorePercentageTextField.text.length == 0  && _isGMAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter GMAT Total percentage" block:^(int index){
            CGPoint buttonPosition = [self.GMATTotalScorePercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATTotalScorePercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if (_isGMAT == YES && ([self.GMATTotalScorePercentageTextField.text floatValue]>100 || [self.GMATTotalScorePercentageTextField.text floatValue]<1))
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid GMAT Total percentage" block:^(int index){
            CGPoint buttonPosition = [self.GMATTotalScorePercentageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.GMATTotalScorePercentageTextField becomeFirstResponder];
        }];
        return false;
    }
    
   
    
    else if ([_selectedHeaderString integerValue] == 2 && (self.SATDateTextField.text.length == 0  && _isSAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter SAT exam Date" block:^(int index){
            CGPoint buttonPosition = [self.SATDateTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.SATRawTextField.text.length == 0  && _isSAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter SAT Raw score" block:^(int index){
            CGPoint buttonPosition = [self.SATRawTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATRawTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!([self.SATRawTextField.text integerValue]>1 ) && _isSAT == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid SAT Raw score" block:^(int index) {
            CGPoint buttonPosition = [self.SATRawTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATRawTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.SATMathTextField.text.length == 0  && _isSAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter SAT Math score" block:^(int index){
            CGPoint buttonPosition = [self.SATMathTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATMathTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!([self.SATMathTextField.text integerValue]>1 ) && _isSAT == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid SAT Math score" block:^(int index) {
            CGPoint buttonPosition = [self.SATMathTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATMathTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.SATReadingTextField.text.length == 0  && _isSAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter SAT Reading score" block:^(int index){
            CGPoint buttonPosition = [self.SATReadingTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATReadingTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!([self.SATReadingTextField.text integerValue]>1 ) && _isSAT == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid SAT Reading score" block:^(int index) {
            CGPoint buttonPosition = [self.SATReadingTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATReadingTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.SATWritingTextField.text.length == 0  && _isSAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter SAT Writing score" block:^(int index){
            CGPoint buttonPosition = [self.SATWritingTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATWritingTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!([self.SATWritingTextField.text floatValue]>=1 ) && _isSAT == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid SAT Writing score" block:^(int index) {
            CGPoint buttonPosition = [self.SATWritingTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATWritingTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_selectedHeaderString integerValue] == 2 && (self.SATLanguageTextField.text.length == 0  && _isSAT == YES)) {
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter SAT Language score" block:^(int index){
            CGPoint buttonPosition = [self.SATLanguageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATLanguageTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(!([self.SATLanguageTextField.text floatValue]>=1 ) && _isSAT == YES && [_selectedHeaderString integerValue] == 2){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid SAT Language score" block:^(int index) {
            CGPoint buttonPosition = [self.SATLanguageTextField convertPoint:CGPointZero toView:_miniProfileTable];
            [Utility scrolloTableView:_miniProfileTable point:buttonPosition indexPath:nil];
            [self.SATLanguageTextField becomeFirstResponder];
        }];
        return false;
    }

    
    return true;
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAndExitButton_clicked:(id)sender {
    if ([self validation]) {
        [self SaveData];
        [self replaceEditMPDictionary];
        [self saveMiniProfileData];
        
    }
    
}
-(void)saveMiniProfileData{
    
    // [self replaceEditMPDictionary]
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.editMPDictionary];
    
    NSArray *array = [[self.editMPDictionary valueForKey:kInterested_country] valueForKey:Kid];
    
    
    // code for conver array into json string
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&err];
    NSString *stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dic setValue:stringData forKey:kInterested_country];
    
//    jsonData = [NSJSONSerialization dataWithJSONObject:[self.editMPDictionary valueForKey:kQualified_exams] options:0 error:&err];
//    NSString *qualifiedExamString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    [dic setValue:qualifiedExamString forKey:kQualified_exams];
    
//    jsonData = [NSJSONSerialization dataWithJSONObject:[self.editMPDictionary valueForKey:kenglish_exam_level] options:0 error:&err];
//    NSString *examLevelString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    [dic setValue:examLevelString forKey:kenglish_exam_level];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-mini-profile.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    [Utility showAlertViewControllerIn:self title:@"" message:@"Profile updated" block:^(int index) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        UNKHomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
                        homeViewController.isQuickShown = YES;

                        [self.navigationController pushViewController:homeViewController animated:true];
                        
                    }];
                    
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
- (IBAction)next2Button_clicked:(id)sender {
    
    
    NSLog(@"%@",_validScoreSelectedSectionArray);
    
    NSLog(@"%@",_selectedScoreArray);
    
    NSLog(@"%@",dictQualifiedExamArray);
    
    
    if ([self  validation]) {
        
        if ([_selectedHeaderString integerValue] == 2) {
            
            if (dictQualifiedExamArray) {
                [dictQualifiedExamArray removeAllObjects];
            }
            
            for (int i=0; i< [_validScoreSelectedSectionArray count]; i++) {
                
                
                /*if ([_selectedScoreArray count] >0 && [[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] ) {
                 
                 for (NSMutableDictionary *dict in _selectedScoreArray) {
                 if ([[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] containsObject:dict]) {
                 
                 NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                 NSLog(@"%@",[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid]);
                 
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                 [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                 [dict setValue:[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid] forKey:@"score_id"];
                 
                 [dictQualifiedExamArray addObject:dict];
                 }
                 
                 }
                 }*/
                if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"gre"])
                {
                    NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    [dict setValue:@"" forKey:@"score_id"];
                    if(![dictQualifiedExamArray containsObject:dict])
                    {
                        [dictQualifiedExamArray addObject:dict];
                    }
                    
                }
                else if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"gmat"])
                {
                    NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    [dict setValue:@"" forKey:@"score_id"];
                    if(![dictQualifiedExamArray containsObject:dict])
                    {
                        [dictQualifiedExamArray addObject:dict];
                    }
                    
                }
                else if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"sat"])
                {
                    NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    [dict setValue:@"" forKey:@"score_id"];
                    if(![dictQualifiedExamArray containsObject:dict])
                    {
                        [dictQualifiedExamArray addObject:dict];
                    }
                    
                }
                else
                {
                    //                    for (NSMutableDictionary *dict in _selectedScoreArray) {
                    //                        if ([[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] containsObject:dict]) {
                    //
                    //                            NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    //                            NSLog(@"%@",[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid]);
                    //
                    //                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    //                            [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    //                            [dict setValue:[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid] forKey:@"score_id"];
                    //
                    //                            [dictQualifiedExamArray addObject:dict];
                    //                        }
                    //
                    //                    }
                   /* NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    
                    if(_selectedScoreArray.count >0)
                    {
                        [dict setValue:[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid] forKey:@"score_id"];
                    }
                    else{
                        [dict setValue:@"" forKey:@"score_id"];
                    }
                    
                    
                    [dictQualifiedExamArray addObject:dict];*/
                    
                    
                    for (NSMutableDictionary *dict in _selectedScoreArray) {
                        if ([[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] containsObject:dict]) {
                            
                            NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                            NSLog(@"%@",[dict valueForKey:Kid]);
                            
                            
                            
                            NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
                            [dict2 setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                            [dict2 setValue:[dict valueForKey:Kid] forKey:@"score_id"];
                            
                            if(![dictQualifiedExamArray containsObject:dict2])
                            {
                                [dictQualifiedExamArray addObject:dict2];
                            }
                            break;
                        }
                        
                    }
                    
                }
                
            }
            if(dictQualifiedExamArray.count>0)
            {
                NSArray * newArray =
                [[NSOrderedSet orderedSetWithArray:dictQualifiedExamArray] array];
                dictQualifiedExamArray =[[NSMutableArray alloc] initWithArray:newArray];
                
            }
            NSError * err;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictQualifiedExamArray options:0 error:&err];
            NSString *qualifiedExamString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [self.miniProfileDictionary setValue:qualifiedExamString forKey:kQualified_exams];
            // GMAT
            
            if (_isGMAT) {
                [self.miniProfileDictionary setValue:self.GMATDateTextField.text forKey:kgmat_exam_date];
                [self.miniProfileDictionary setValue:self.GMATVerbalTextField.text forKey:kgmat_verbal_score];
                [self.miniProfileDictionary setValue:self.GMATVerbalPercentageTextField .text forKey:kgmat_verbal];
                [self.miniProfileDictionary setValue:self.GMATQuantitativeTextField.text forKey:kgmat_quantitative_score];
                [self.miniProfileDictionary setValue:self.GMATQuantitativePercentageTextField.text forKey:kgmat_quantitative];
                [self.miniProfileDictionary setValue:self.GMATAnalyticalTextField.text forKey:kgmat_analytical_writing_score];
                [self.miniProfileDictionary setValue:self.GMATAnalyticalPercentageTextField.text forKey:kgmat_analytical_writing];
                [self.miniProfileDictionary setValue:self.GMATTotalScoreTextField.text forKey:kgmat_Total_score];
                [self.miniProfileDictionary setValue:self.GMATTotalScorePercentageTextField.text forKey:kgmat_Total_Percentage];
            }
            
            // SAT
            
            if (_isSAT) {
                [self.miniProfileDictionary setValue:self.SATDateTextField.text forKey:ksat_Date_score];
                [self.miniProfileDictionary setValue:self.SATRawTextField.text forKey:ksat_raw_score];
                [self.miniProfileDictionary setValue:self.SATMathTextField.text forKey:ksat_math_score];
                [self.miniProfileDictionary setValue:self.SATReadingTextField.text forKey:ksat_reading_score];
                [self.miniProfileDictionary setValue:self.SATWritingTextField.text forKey:ksat_writing_language_score];
                [self.miniProfileDictionary setValue:self.SATLanguageTextField.text forKey:ksat_language];
            }
            
            // gre
            if (_isGRE) {
                
                [self.miniProfileDictionary setValue:self.dateTextField.text forKey:kgre_exam_date];
                [self.miniProfileDictionary setValue:self.verbalTextField.text forKey:kgre_verbal_score];
                [self.miniProfileDictionary setValue:self.verbalPercentageTextField.text forKey:kgre_verbal];
                [self.miniProfileDictionary setValue:self.quantitativeTextField.text forKey:kgre_quantitative_score];
                [self.miniProfileDictionary setValue:self.quantitativePercentageTextField.text forKey:kgre_quantitative];
                [self.miniProfileDictionary setValue:self.analyticalTextField.text forKey:kgre_analytical_writing_score];
                [self.miniProfileDictionary setValue:self.analyticalPercentageTextField.text forKey:kgre_analytical_writing];
            }
            
        }
        
        [self replaceEditMPDictionary];
        [self performSegueWithIdentifier:kMPStep4SegieIdentifier sender:nil];
    }
    
    
}

-(void)SaveData
{
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    [_selectedScoreArray removeObject:dic];
    
    if ([_selectedHeaderString integerValue] == 2) {
        
        if (dictQualifiedExamArray) {
            [dictQualifiedExamArray removeAllObjects];
        }
        
        for (int i=0; i< [_validScoreSelectedSectionArray count]; i++) {
            
            
            if ([_selectedScoreArray count] >0 && [[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] ) {
                
                //for (int i=0; i< [_validScoreSelectedSectionArray count]; i++) {
                    
                    
                    /*if ([_selectedScoreArray count] >0 && [[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] ) {
                     
                     for (NSMutableDictionary *dict in _selectedScoreArray) {
                     if ([[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] containsObject:dict]) {
                     
                     NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                     NSLog(@"%@",[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid]);
                     
                     NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                     [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                     [dict setValue:[[_selectedScoreArray objectAtIndex:i]valueForKey:Kid] forKey:@"score_id"];
                     
                     [dictQualifiedExamArray addObject:dict];
                     }
                     
                     }
                     }*/
                    if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"gre"])
                    {
                        NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                        
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                        [dict setValue:@"" forKey:@"score_id"];
                        if(![dictQualifiedExamArray containsObject:dict])
                        {
                            [dictQualifiedExamArray addObject:dict];
                        }
                        
                    }
                    else if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"gmat"])
                    {
                        NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                        
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                        [dict setValue:@"" forKey:@"score_id"];
                        if(![dictQualifiedExamArray containsObject:dict])
                        {
                            [dictQualifiedExamArray addObject:dict];
                        }
                        
                    }
                    else if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"sat"])
                    {
                        NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                        
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                        [dict setValue:@"" forKey:@"score_id"];
                        if(![dictQualifiedExamArray containsObject:dict])
                        {
                            [dictQualifiedExamArray addObject:dict];
                        }
                        
                    }
                    else
                    {
                        for (NSMutableDictionary *dict in _selectedScoreArray) {
                            if ([[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:kInputparameters] containsObject:dict]) {
                                
                                NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                                NSLog(@"%@",[dict valueForKey:Kid]);
                                
                                
                                
                                NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
                                [dict2 setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                                [dict2 setValue:[dict valueForKey:Kid] forKey:@"score_id"];
                                
                                if(![dictQualifiedExamArray containsObject:dict2])
                                {
                                    [dictQualifiedExamArray addObject:dict2];
                                }
                                break;
                            }
                            
                        }
                    }
                    
               // }
            }
            else
            {
                if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"gre"])
                {
                    NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    [dict setValue:@"" forKey:@"score_id"];
                    if(![dictQualifiedExamArray containsObject:dict])
                    {
                        [dictQualifiedExamArray addObject:dict];
                    }
                    
                }
                else if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"gmat"])
                {
                    NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    [dict setValue:@"" forKey:@"score_id"];
                    if(![dictQualifiedExamArray containsObject:dict])
                    {
                        [dictQualifiedExamArray addObject:dict];
                    }
                    
                }
                else if([[[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:@"title"] lowercaseString] isEqualToString:@"sat"])
                {
                    NSLog(@"%@",[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid]);
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setValue:[[_validScoreSelectedSectionArray objectAtIndex:i]valueForKey:Kid] forKey:@"exam_id"];
                    [dict setValue:@"" forKey:@"score_id"];
                    if(![dictQualifiedExamArray containsObject:dict])
                    {
                        [dictQualifiedExamArray addObject:dict];
                    }
                    
                }
            }
        }
        
        if(dictQualifiedExamArray.count>0)
        {
            NSArray * newArray =
            [[NSOrderedSet orderedSetWithArray:dictQualifiedExamArray] array];
            dictQualifiedExamArray =[[NSMutableArray alloc] initWithArray:newArray];
            
        }
        NSError * err;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictQualifiedExamArray options:0 error:&err];
        NSString *qualifiedExamString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [self.miniProfileDictionary setValue:qualifiedExamString forKey:kQualified_exams];
    }
    
    // GMAT
    
    if (_isGMAT) {
        [self.miniProfileDictionary setValue:self.GMATDateTextField.text forKey:kgmat_exam_date];
        [self.miniProfileDictionary setValue:self.GMATVerbalTextField.text forKey:kgmat_verbal_score];
        [self.miniProfileDictionary setValue:self.GMATVerbalPercentageTextField .text forKey:kgmat_verbal];
        [self.miniProfileDictionary setValue:self.GMATQuantitativeTextField.text forKey:kgmat_quantitative_score];
        [self.miniProfileDictionary setValue:self.GMATQuantitativePercentageTextField.text forKey:kgmat_quantitative];
        [self.miniProfileDictionary setValue:self.GMATAnalyticalTextField.text forKey:kgmat_analytical_writing_score];
        [self.miniProfileDictionary setValue:self.GMATAnalyticalPercentageTextField.text forKey:kgmat_analytical_writing];
        [self.miniProfileDictionary setValue:self.GMATTotalScoreTextField.text forKey:kgmat_Total_score];
        [self.miniProfileDictionary setValue:self.GMATTotalScorePercentageTextField.text forKey:kgmat_Total_Percentage];
    }
    
    // SAT
    
    if (_isSAT) {
        [self.miniProfileDictionary setValue:self.SATDateTextField.text forKey:ksat_Date_score];
        [self.miniProfileDictionary setValue:self.SATRawTextField.text forKey:ksat_raw_score];
        [self.miniProfileDictionary setValue:self.SATMathTextField.text forKey:ksat_math_score];
        [self.miniProfileDictionary setValue:self.SATReadingTextField.text forKey:ksat_reading_score];
        [self.miniProfileDictionary setValue:self.SATWritingTextField.text forKey:ksat_writing_language_score];
        [self.miniProfileDictionary setValue:self.SATLanguageTextField.text forKey:ksat_language];
    }
    
    // gre
    if (_isGRE) {
        
        [self.miniProfileDictionary setValue:self.dateTextField.text forKey:kgre_exam_date];
        [self.miniProfileDictionary setValue:self.verbalTextField.text forKey:kgre_verbal_score];
        [self.miniProfileDictionary setValue:self.verbalPercentageTextField.text forKey:kgre_verbal];
        [self.miniProfileDictionary setValue:self.quantitativeTextField.text forKey:kgre_quantitative_score];
        [self.miniProfileDictionary setValue:self.quantitativePercentageTextField.text forKey:kgre_quantitative];
        [self.miniProfileDictionary setValue:self.analyticalTextField.text forKey:kgre_analytical_writing_score];
        [self.miniProfileDictionary setValue:self.analyticalPercentageTextField.text forKey:kgre_analytical_writing];
    }
    
    
}
-(void)replaceEditMPDictionary
{
    [self.editMPDictionary addEntriesFromDictionary: self.miniProfileDictionary];
//    NSArray *test = [self.editMPDictionary valueForKey:kQualified_exams];
//    NSMutableArray *ExamList =[self.editMPDictionary valueForKey:kQualified_exams];
//    NSArray * newArray =
//    [[NSOrderedSet orderedSetWithArray:ExamList] array];
//    ExamList =[[NSMutableArray alloc] initWithArray:newArray];
//    [self.editMPDictionary setObject:ExamList forKey:kQualified_exams];
    
}
-(void)setFeilds:(NSDictionary*)dic
{
    NSString *title = [dic valueForKey:@"title"];
    
    if([title.lowercaseString isEqualToString:@"gre"])
    {
        self.dateTextField.text =@"";
        self.verbalTextField.text =@"";
        self.verbalPercentageTextField.text =@"";
        self.quantitativeTextField.text =@"";
        self.quantitativePercentageTextField.text =@"";
        self.analyticalTextField.text =@"";
        self.analyticalPercentageTextField.text =@"";
    }
    else if([title.lowercaseString isEqualToString:@"gmat"])
    {
        self.GMATDateTextField.text =@"";
        self.GMATVerbalTextField.text =@"";
        self.GMATVerbalPercentageTextField.text =@"";
        self.GMATQuantitativeTextField.text =@"";
        self.GMATQuantitativePercentageTextField.text =@"";
        self.GMATAnalyticalTextField.text =@"";
        self.GMATAnalyticalPercentageTextField.text =@"";
        self.GMATTotalScoreTextField.text =@"";
        self.GMATTotalScorePercentageTextField.text =@"";
    }
    else if([title.lowercaseString isEqualToString:@"sat"])
    {
        self.SATDateTextField.text =@"";
        self.SATRawTextField.text =@"";
        self.SATMathTextField.text =@"";
        self.SATReadingTextField.text =@"";
        self.SATWritingTextField.text =@"";
        self.SATLanguageTextField.text =@"";
        
    }
}


/****************************
 * Function Name : - addToolBarOnKeyboard
 * Create on : -  15 march 2017
 * Developed By : - Ramniwas
 * Description : - This Function is used for add tool bar on keyboard in case of number keyboard open
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(UIToolbar *)addToolBarOnKeyboard :(NSInteger) tag{
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton;
    if (tag ==308|| tag ==205 || tag ==106) {
     
          doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardDoneButtonPressed:)];
    }
    else{
      doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardDoneButtonPressed:)];
    }
  
    doneButton.tag = tag;
    doneButton.tintColor = [UIColor lightGrayColor];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    
    return keyboardToolbar;
}

-(void)keyboardDoneButtonPressed:(UIBarButtonItem*) sender{
    
    // GRE
    if (sender.tag == 101) {
        [self.verbalPercentageTextField becomeFirstResponder];
    }
    else if (sender.tag == 102) {
        [self.quantitativeTextField becomeFirstResponder];
    }
    else if (sender.tag == 103) {
        [self.quantitativePercentageTextField becomeFirstResponder];
    }
    else if (sender.tag == 104) {
        [self.analyticalTextField becomeFirstResponder];
    }
    else if (sender.tag == 105) {
        [self.analyticalPercentageTextField becomeFirstResponder];
    }
    else if (sender.tag == 106) {
        [self.analyticalPercentageTextField resignFirstResponder];
    }
    
    // SAT
    if (sender.tag == 201) {
        [self.SATMathTextField becomeFirstResponder];
    }
    else if (sender.tag == 202) {
        [self.SATReadingTextField becomeFirstResponder];
    }
    else if (sender.tag == 203) {
        [self.SATWritingTextField becomeFirstResponder];
    }
    else if (sender.tag == 204) {
        [self.SATLanguageTextField becomeFirstResponder];
    }
    else if (sender.tag == 205) {
        [self.SATLanguageTextField resignFirstResponder];
    }
    
    
    // GMAT
    if (sender.tag == 301) {
        [self.GMATVerbalPercentageTextField becomeFirstResponder];
    }
    else if (sender.tag == 302) {
        [self.GMATQuantitativeTextField becomeFirstResponder];
    }
    else if (sender.tag == 303) {
        [self.GMATQuantitativePercentageTextField becomeFirstResponder];
    }
    else if (sender.tag == 304) {
        [self.GMATAnalyticalTextField becomeFirstResponder];
    }
    else if (sender.tag == 305) {
        [self.GMATAnalyticalPercentageTextField becomeFirstResponder];
    }
    else if (sender.tag == 306) {
        [self.GMATTotalScoreTextField becomeFirstResponder];
    }
    else if (sender.tag == 307) {
        [self.GMATTotalScorePercentageTextField becomeFirstResponder];
    }
    else if (sender.tag == 308) {
        [self.GMATTotalScorePercentageTextField resignFirstResponder];
    }
    
}


@end
