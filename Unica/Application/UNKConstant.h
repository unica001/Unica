//
//  UNKConstant.h
//  Unica
//
//  Created by vineet patidar on 01/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#ifndef UNKConstant_h
#define UNKConstant_h

#define kUserDefault [NSUserDefaults standardUserDefaults]
// code for get screen size
#define kiPhoneWidth [[UIScreen mainScreen] bounds].size.width
#define kiPhoneHeight [[UIScreen mainScreen] bounds].size.height

// code for get current device screen size difference
#define kIs_Iphone4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define kIs_Iphone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define kIs_Iphone6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define kIs_Iphone6PLUS ([[UIScreen mainScreen] bounds].size.height == 736)

#define kIs_IphoneX ([[UIScreen mainScreen] bounds].size.height == 812)


//#define kAPIBaseURL @"https://www.uniagents.com/apk/rest/android/"
//#define kAPIBaseURL @"http://api.uniagents.com/api/"
//#define kAPIBaseURL @"https://unica.sirez.com/api/"
#define kAPIBaseURL @"https://www.uniagents.com/apknew/rest/android/"

#define kAppDelegate  (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define kAPIResponseTimeout 90

//FONTS

#define kFontSFUITextRegular @"SFUIText-Regular"
#define kFontSFUITextRegularBold @"SFUIText-Bold"
#define kFontSFUITextSemibold @"SFUIText-Semibold"
#define kFontSFUITextLight @"SFUIText-Light"
#define kFontSFUITextMedium @"SFUIText-Medium"
#define kDefaultFontForTextField [UIFont fontWithName:@"SFUIText-Light" size:14]
#define kDefaultFontForTextFieldMeium [UIFont fontWithName:@"SFUIText-Medium" size:14]
#define kDefaultFontForApp kDefaultFontForTextField
#define kDefaultFontForNavigationBarTitle [UIFont fontWithName:@"SFUIText-Medium" size:17]

//Dictionary Options
#define kTextFeildOptionPlaceholder @"placeholder"
#define kTextFeildOptionFont @"font"
#define kTextFeildOptionKeyboardType @"keyboardtype"
#define kTextFeildOptionReturnType @"returntype"
#define kTextFeildOptionAutocorrectionType @"autocorrectiontype"
#define kTextFeildOptionAutocapitalizationType @"autocapitalizationtype"
#define kTextFeildOptionIsPassword @"secureField"
#define kUNKError @""
#define kUNKCUSTOMError @"Unica Custom Error"

#define kDefaultBlueLightColor [UIColor colorWithRed:68.0f/255.0f green:129.0f/255.0f blue:239.0f/255.0f alpha:1.0]

#define kDefaultBlueColor [UIColor colorWithRed:43.0f/255.0f green:66.0f/255.0f blue:102.0f/255.0f alpha:1.0]
#define  kDefaultlightBlue [UIColor colorWithRed:242.0f/255.0f green:244.0f/255.0f blue:249.0f/255.0f alpha:1.0]

#define  kDefaultRedColor [UIColor colorWithRed:255.0f/255.0f green:0/255.0f blue:0.0f/255.0f alpha:1.0].CGColor

#define kAPICode @"Code"
#define kAPIPayload @"Payload"
#define kAPIErrorCode @"errorCode"
#define kAPIMessage @"Message"
#define kAPISuccess @"Success"
#define kAPIError @"Error"
#define kTempId @"tempId"

// Login
#define kGender @"gender"
#define kimage_url @"image_url"
#define kSocialId @"socialid"
#define kfirstname  @"firstname"
#define klastname @"lastname"
#define kMobileNumber @"mobileNumber"
#define kEmail @"email"
#define kPassword @"password"
#define kCountry @"country"
#define kCity @"city"
#define kRegister_type @"register_type"
#define kStype  @"stype"
#define kDeviceToken  @"deviceToken"
#define kDeviceType  @"deviceType"
#define kProfileImage @"profileImage"
#define KDOB @"DOB"
#define kdob @"dob"
#define KOTP @"otp"
#define Kuser_name @"user_name"
#define Kusername @"username"
#define Kuserid @"userid"
#define kProfile_image @"profile_image"
#define kSocial @"social"
#define Knotification_id @"notification_id"
#define Kaction_status @"action_status"
#define KwelcomeScreen @"welcomeScreen"

//notification
#define KNeed_action @"need_action"
#define KActionStatus @"actionStatus"
#define kAccept @"accept"
#define KReject @"reject"
#define KMessages @"messages"

#define kLoginStatus @"LoginStatus"
#define kdate_of_birth @"date_of_birth"
#define kresidential_address @"residential_address"
#define kresidential_street_number @"residential_street_number"
#define kresidential_city @"residential_city"
#define kresidential_state @"residential_state"
#define kresidential_zip_code @"residential_zip_code"
#define kcountry_name @"country_name"
#define kcountry_id @"country_id"
#define kmini_profile_status @"mini_profile_status"
#define klogin @"login"
#define kMyProfile @"My Profile"
#define kMyApplication @"myApplication"
#define kanswer @"answer"

// change password
#define kOldPassword @"oldpassword"
#define kNewPassword @"newpassword"
#define kConfirmPassword @"confirmPassword"
#define kcountry_calling_code @"country_calling_code"
#define kminimum_value @"minimum_value"
#define kmaximum_value @"maximum_value"
#define kcurrency @"currency"
//OTP

#define kUser_id  @"user_id"
#define kRegister @"register"
#define kLoginInfo @"loginInfo"
#define KMiniProfileDictionary @"miniProfileDictionary"
#define kisGlobalFormCompleted @"isGlobalFormCompleted"
#define kRateUsPopUp @"RateUsPopUp"

// Mini Profile Step1

#define kName @"name"
#define Kid @"id"
#define kielts @"ielts"
#define ktoeflibt @"toeflibt"
#define kSearch_country @"search_country"
#define kCountries @"countries"
#define kMPStep1 @"MPStep1"
#define kMPStep2 @"MPStep2"
#define kGRE @"gre"
#define kGMAT @"gmat"
#define kSAT @"gsat"
#define kMiniProfileData @"MiniProfileData"
#define kphone @"phone"
#define kPhoneNumber1 @"PhoneNumber1"
#define kPhoneNumber2 @"PhoneNumber1"
#define ksecond_phone @"second_phone"

#define kamount @"amount"
#define kPageNumber @"pageNumber"
#define kQRCode @"QRCode"

// mini step 2

#define kCourses_type @"courses_type"
#define kExams @"exams"
#define Ktitle @"title"
#define kInputparameters @"inputparameters"
#define kValue @"value"
#define kSub_title @"sub_title"
#define ksearch_subcategory @"search_subcategory"

#define klanguage_list @"language_list"
#define kExam_list @"exam_list"
#define kDegree_List @"degree_list"
#define kGrade_List @"grade_list"
#define KBackgroundQuestionList @"backgroundQuestionList"
#define kStep3answer @"answer"
#define KCountryList @"countryList"
#define KActions @"actions"
#define Kcategories @"categories"

// mini step 4

#define ktitle_budget @"title_budget"
#define kconverted_amount @"converted_amount"
#define kbudget_id @"budget_id"

#define kEducation_status @"education_status"
#define kHigher_education_name @"higher_education_name"
#define kHighest_education_level_id @"highest_education_level_id"
#define kLast_education_country_id @"last_education_country_id"
#define kGrading_system_id @"grading_system_id"
#define kSub_grading_system_id @"sub_grading_system_id"
#define kApply_education_level_id @"apply_education_level_id"
#define kApply_course_type_id @"apply_course_type_id"
#define kInterested_year @"interested_year"
#define kInterested_category_id @"interested_category_id"
#define kValid_scores @"valid_scores"
#define kQualified_exams @"qualified_exams"
#define kInterested_country @"interested_country"
#define kgre_exam_date @"gre_exam_date"
#define kgre_verbal_score @"gre_verbal_score"
#define kgre_verbal @"gre_verbal"
#define kgre_quantitative_score @"gre_quantitative_score"
#define kgre_quantitative @"gre_quantitative"
#define kgre_analytical_writing_score @"gre_analytical_writing_score"
#define kgre_analytical_writing @"gre_analytical_writing"
#define kgmat_exam_date @"gmat_exam_date"
#define kgmat_verbal_score @"gmat_verbal_score"
#define kgmat_verbal @"gmat_verbal"
#define kgmat_quantitative_score @"gmat_quantitative_score"
#define kgmat_quantitative @"gmat_quantitative"
#define kgmat_analytical_writing_score @"gmat_analytical_writing_score"
#define kgmat_analytical_writing @"gmat_analytical_writing"
#define kgmat_Total_score @"gmat_total_score"
#define kgmat_Total_Percentage @"gmat_total_percentage"
#define ksat_raw_score @"sat_raw_score"
#define ksat_math_score @"sat_math_score"
#define ksat_reading_score @"sat_reading_score"
#define ksat_writing_language_score @"sat_writing_score"
#define kenglish_exam_level @"english_exam_level"
#define ksat_Date_score @"sat_exam_date"
#define ksat_language @"sat_writing_language_score"


#define KglobalApplicationData @"globalApplicationData"

// Agent
#define kPage_number @"page_number"
#define kFilter_rating @"filter_rating"
#define kFilter_location_id @"filter_location_id"
#define Kagent @"agent"
#define kAgent_consultancy_name @"agent_consultancy_name"
#define kAgent_id @"agent_id"
#define kAgent_name @"agent_name"
#define kAgent_rating @"agent_rating"
#define kAgent_number @"agent_number"
#define KAgent_mobile @"agent_mobile"
#define kAgent_email @"agent_email"
#define kAgent_logo @"agent_logo"
#define kIslike @"islike"
#define kAddress @"address"

// Agent About
#define kAgent_experience @"agent_experience"
#define kAgent_service @"agent_service"

#define kAgentFilterDictionary @"agentFilterDictionary"
#define kfilterRating @"filterRating"
#define kAgentLocationFilter @"agentLocationFilter"
#define kshowTutorialScreen @"showTutorialScreen"

#define kIncomingViewType @"incomingView"
#define kHomeView @"HomeView"
#define KForgotPassword @"forgotPassword"
// review

#define kreview_message @"review_message"
#define kuser_image @"user_image"
#define kreview_time @"review_time"
#define kreview_id @"review_id"
#define kreview @"review"
#define krating @"rating"
#define kmessage @"message"
#define kfeedback @"feedback"

#define kselectedLocation @"selectedLocation"
#define kselecteService @"selecteService"
#define kPaymentResponceDict @"PaymentResponce"

// reveal menu

#define RevealMenu @"Reveal Menu";


//Agent filter

#define ksearchinput @"searchinput"
#define kagentId @"agentId"
#define kservice @"service"
#define kfilter_serive_id @"filter_serive_id"
#define kstatus @"status"

// course
#define kfilterfilter_country_id @"filter[filter_country_id]"
#define kfilterfilter_institute_id @"filter[filter_institute_id]"
#define kfilterscholarship @"filter[scholarship]"
#define kfilterperfect_match @"filter[perfect_match]"
#define kkeyword @"keyword"
#define kcourses @"courses"
#define KCourse @"Course"
#define KEvent @"Event"
#define kPaymentModeType @"paymentModeType"
#define kFavourite @"Favourite"
#define kAGENT @"AGENTS"
#define kCOURSES @"COURSES"
#define kINSTITUDE @"INSTITUTIONS"
#define kMenuFavourite @"Menu Favourite"
#define kparticipant @"participant"
#define kPreviousUserId @"PreviousUserId"


// filter
#define kINSTITUTION @"INSTITUTION"
#define kCOUNTRY @"COUNTRY"
#define kSCHOLARSHIP @"SCHOLARSHIP"
#define kPERFECT @"PERFECT MATCH"

#define kinstitute @"institute"
#define kFromView @"fromView"

// Institude

#define kABOUT @"ABOUT"
#define kINFO @"INFO"
#define kVIDEO @"VIDEO"
#define kCOURSES @"COURSES"
#define kSCHLOARSHIP @"SCHOLARSHIP"
#define kIMPORTANTLINK @"IMPORTANTLINK"
#define kFETUREDDESTINATION @"FETUREDDESTINATION"
#define kNEWS @"NEWS"

// event

#define KCITY @"CITY"
#define KPARTICIPATINGCOUNTRY @"PARTICIPATING COUNTRY"

#define KInstitutionFilterType @"institutionFilterType"

// course filter
#define ksearch_institute @"search_institute"

#define kapplication_fee @"application_fee"
#define kconverted_amount_application_fee @"converted_amount_application_fee"
#define kconverted_amount_tution_fee @"converted_amount_tution_fee"
#define kcountry_image @"country_image"
#define kcourse_country @"course_country"
#define kcourse_fee @"course_fee"
#define kinstitute_id @"institute_id"
#define kinstitute_name @"institute_name"
#define kis_eligible @"is_eligible"
#define kis_like @"is_like"
#define kscholarship @"scholarship"
#define ktitle @"title"
#define kcourse_id @"course_id"
#define kapplied @"applied"
#define kquestion_id @"question_id"

// course Details
#define kcourse_level @"course_level"
#define keligibility_domestic_student @"eligibility_domestic_student"
#define kother_admission_requirement @"other_admission_requirement"
#define kspecial_appl_instructions @"special_appl_instructions"
#define kvideo_default_thumb_image @"video_default_thumb_image"
#define kcourse_category @"course_category"
#define kcourse_sub_category @"course_sub_category"
#define kdescription @"description"
#define kduration @"duration"
#define kprocessing_time @"processing_time"
#define kcharges @"charges"
#define ktution_fee @"tution_fee"
#define kapplication_fee @"application_fee"
#define kliving_cost @"living_cost"
#define kdomestic_std_tution_fee @"domestic_std_tution_fee"
#define kaddtional_fee_and_notes @"addtional_fee_and_notes"
#define ktution_fee_breakup @"tution_fee_breakup"
#define kother_fee @"other_fee"
#define kintake @"intake"
#define kintake_month @"intake_month"
#define kintake_note @"intake_note"
#define kintake_deadline_month @"intake_deadline_month"
#define kintake_deadline_day @"intake_deadline_day"
#define ktimeline @"timeline"
#define kAdmisssion @"Admisssion"
#define kApplication @"Application"
#define kApplicationfee @"Application fee"
#define kvideos_url @"videos_url"
#define kvideos @"videos"
// about

#define kabout @"about"
#define kwhy @"why"
#define kmobile @"mobile"
#define kinstitute_image @"institute_image"

// info

#define kfounded @"founded"
#define kestablish @"establish"
#define kinstitutetype @"institutetype"
#define kestimatecost @"estimatecost"
#define klocation @"location"
#define kcourse_name @"course_name"
#define kevents @"events"
#define kevent_name @"event_name"
#define kevent_location  @"event_location"
#define kevent_image  @"event_image"
#define kevent_id @"event_id"
#define kevent_date @"event_date"
#define kevent_description @"event_description"
#define kevent_participate @"event_participate"
#define kcountry_name @"country_name"
#define kevent_time @"event_time"
#define kcourse_university @"course_university"

// SegueIdentifier

#define kForgotPasswordSegueIdentifier @"forgotPasswordSegueIdentifier"
#define kRegistrationSegueIdentifier @"registrationSegueIdentifier"
#define kVerityOTPSegueIdentifier @"verityOTPSegueIdentifier"
#define kWelcomeSegueIdentifier @"welcomeSegueIdentifier"
#define kMPStep1SegueIdentifier @"MPStep1SegueIdentifier"
#define kMPSetp2SegueIdentifier @"MPSetp2SegueIdentifier"
#define kMPStep3SegueIdentifier @"step3SegueIdentifier"
#define kMPStep4SegieIdentifier @"MPStep4SegieIdentifier"
#define KPresictiveSeachSegueIdentifier @"PresictiveSeachSegueIdentifier"
#define kMPThanksSegueIdentifier @"MPThanksSegueIdentifier"
#define kHomeSegueIdentifier @"homeSegueIdentifier"
#define kAgentSegueIdentifier @"agentSegueIdentifier"
#define kTutorialSegueIdentifier @"tutorialSegueIdentifier"
#define kSignInViewSegueIdentifier @"signInViewSegueIdentifier"
#define kcontactUSegueIdentifier @"contactUSegueIdentifier"

#define kAgentFilterSegueIdentifier @"agentFilterSegueIdentifier"
#define kAgentRatingStoryboardId @"agentRatingStoryboardId"
#define kAgentLocationSegueIdentifier @"agentLocationSegueIdentifier"
#define kAgentServiceSegueIdentifier @"agentServiceSegueIdentifier"
#define kAgentDetailSegueIdentifier @"AgentDetailSegueIdentifier"
#define kaddAgentReviewSegueIdentifeir @"addAgentReviewSegueIdentifeir"
#define kCourseSegueIdentifier @"courseSegueIdentifier"
#define kcourseDetailsViewController @"courseDetailsViewController"
#define kInstitudeSegueIdentifer @"institudeSegueIdentifer"
#define keventSegueIdentifier @"eventSegueIdentifier"
#define keventDetailSegueIdentifier @"eventDetailSegueIdentifier"
#define kapplicationStatusSegueIdentifier @"applicationStatusSegueIdentifier"
#define kmyUnicaCodeSegueIdentifier @"myUnicaCodeSegueIdentifier"
#define ksettingSegueIdentifier @"settingSegueIdentifier"
#define kwebviewSegueIdentifier @"webviewSegueIdentifier"

#define kAgentAboutStoryBoardID @"AgentAboutStoryBoardID"
#define kAgentReviewStoryBoardID @"AgentReviewStoryBoardID"
#define kAgentMessageStoryBoardID @"AgentMessageStoryBoardID"
#define kcourseFilterStoryBoardID @"courseFilterStoryBoardID"
#define kchangePasswordSegueIdentifier @"changePasswordSegueIdentifier"
#define kredordExpressionSegueIdentifier @"redordExpressionSegueIdentifier"
#define kreferFriendSegueIdentifier @"referFriendSegueIdentifier"
// about course

#define kAboutInstitudeStoryboardID @"AboutInstitudeStoryboardID"
#define kInstitudeInfoStoryBoardID @"InstitudeInfoStoryBoardID"
#define kInstitudeVideoStoryBoardID @"InstitudeVideoStoryBoardID"
#define kInstitudeCourseStoryBoardID @"InstitudeCourseStoryboardID"
#define kGAFStepp1StoryboardID @"GAFStepp1StoryboardID"
#define kcommingSoonSegueIdentifier @"commingSoonSegueIdentifier"
#define krateUsSegueIdentifier @"rateUsSegueIdentifier"
#define knotificationSegueIdentifier @"notificationSegueIdentifier"
#define KScanBusinessCardScanner @"scanBusinessCardSegueIdentifier"
#define KScanQrCode @"scanQRCodeIdentifier"
#define kBusinessCardListSegue @"BusinessCardListSegue"
#define KstudentListSegue @"studentListSegue"
#define KstudentDetailSegue @"studentDetailSegue"
#define kviewParticipantsSegueIdentifier @"viewParticipantsSegueIdentifier"
#define kparticipantsSegueIdentifier @"participantsSegueIdentifier"
#define kparticipantsStoryboardID @"participantsStoryboardID"
#define kmyScheduleSegueIdentifier @"myScheduleSegueIdentifier"
#define kavailabelParticipantSegueIdentifier @"availabelParticipantSegueIdentifier"

#define kfilterscleared @"filterscleared"
#define kIsRemoveAll @"removeAll"
//GlobalApplicationFormConstant

//GlobalApplicationFormConstant

//Step 1
#define kStep1FirstName @"firstname"
#define kStep1MiddleName @"middlename"
#define kStep1LastName @"lastname"
#define kStep1CitizenCountry @"citizenship_country_id"
#define kStep1DOB @"dob"
#define kStep1MobileNumber @"mobileNumber"
#define kStep1SkypeID @"skype_id"
#define kStep1NativeLanguage @"native_language"
#define kStep1MartialStatus @"marital_status"

#define ksegueStep1to2 @"GAStep1to2"

//Step 2
#define kStep2ResidentialHouseNo @"ResidentialHouseNo"
#define kStep2ResidentialStreetAddress @"ResidentialStreetAddress"
#define kStep2ResidentialCity @"ResidentialCity"
#define kStep2ResidentialProvinceOrState @"ResidentialProvinceOrState"
#define kStep2ResidentialPostal @"ResidentialPostal"
#define kStep2ResidentialCountry @"residential_country"
#define kStep2MailingHouseNo @"street_number"
#define kStep2MailingStreetAddress @"MailingHouseNo"
#define kStep2MailingCity @"MailingCity"
#define kStep2MailingProvinceOrState @"MailingProvinceOrState"
#define kStep2MailingPostal @"MailingPostal"
#define kStep2MailingCountry @"mailing_country"
#define kStep2EmergencyContactFirstName @"emergency_contact_first_name"
#define kStep2EmergencyContactLastName @"emergency_contact_last_name"
#define kStep2EmergencyRelationship @"emergency_relationship"
#define kStep2EmergencyPhoneNumber @"emergency_phone_number"
#define kStep2EmergencyEmail @"emergency_email"
#define ksegueStep2to3 @"GAStep2to3"
#define kSameAddress @"SameAddress"
#define kAddress @"address"
#define Kemergency_contact @"emergency_contact"

//Step 3
#define kStep3ProfileImage @"profileImage"
#define kStep3ValidPassport @"valid_passport"
#define kStep3PassportNumber @"passport_number"
#define kStep3PassportIssueCountry @"passport_issue_country_id"
#define kStep3PassportIssueCountryName @"passport_issue_country_Name"
#define kStep3answer @"answer"
#define kQuestionaier @"questionnaire"
#define kQuestion_id @"question_id"

#define kStep3RefusedVisa @"RefusedVisa"
#define kStep3Immigration @"Immigration"
#define kStep3RemovedFromCountry @"RemovedFromCountry"
#define kStep3TravelledOutside @"TravelledOutsideCountryResidence"
#define kStep3Overstayed @"Overstayed"
#define kStep3CriminalOffence @"CriminalOffence"
#define kStep3MedicalCondition @"MedicalCondition"
#define kStep3MoreDetails @"MoreDetails"
#define ksegueStep3to4 @"GAStep3to4"

//Step4

#define kStep4FinancialSupport @"financetype"
#define kStep4AmountAccess @"money_access"
#define kStep4HighestEducationLevel @"highest_education_level_id"
#define kStep4CourseStartYears @"start_year"
#define kStep4CourseCompletionYear @"complete_year"
#define kStep4CountryofEducation @"education_country_id"
#define kStep4NameofInstituion @"institute_name"
#define Kstep4program_awarded @"program_awarded"
#define kStep4AddressofInstitution @"institute_address"
#define kStep4NameofQualification @"NameofQualification"
#define kStep4PrimaryLanguage @"primary_language_instruction"
#define kStep4Grades @"grades"
#define kStep4NameofEmployer @"NameofEmployer"
#define kStep4Position @"Position"
#define kStep4Period @"Period"
#define kStep4MainResponsibilites @"MainResponsibilites"
#define kStep4GREDate @"GREDate"
#define kStep4Verbal @"Verbal"
#define kStep4VerbalPercentage @"VerbalPercentage"
#define kStep4Quantitve @"Quantitve"
#define kStep4QuantitvePercentage @"QuantitvePercentage"
#define kStep4AnalyticalWriting @"AnalyticalWriting"
#define kStep4AnalyticalWritingPercentage @"AnalyticalWritingPercentage"
#define kStep4Grades2 @"Grades2"
#define kStep4Grades3 @"Grades3"
#define kStep4Grades4 @"Grades4"
#define kStep4MainResponsibilites2 @"MainResponsibilites2"
#define kStep4MainResponsibilites3 @"MainResponsibilites3"
#define kStep4MainResponsibilites4 @"MainResponsibilites4"
#define kStep4value @"value"
#define kfavouriteStoryBoardID @"favouriteStoryBoardID"
#define KglobalApplicationData @"globalApplicationData"

#define kStep4work_experience_name @"work_experience_name"
#define kStep4work_experience_period @"work_experience_period"
#define kStep4work_experience_designation @"work_experience_designation"
#define kStep4work_experience_responsibilities @"work_experience_responsibilities"
#define work_experiences @"work_experiences"
#define kfinance @"finance"
#define keducation @"education"
#define kValid_scores @"valid_scores"
#define kSelectedValidScore @"selectedValidScore"
#define kfinance @"finance"
#define keducation @"education"
#define kTag @"tag"
#define kStep4Dictionary @"Step4Dictionary"
#define kWorkExperience @"workExperince"
#define kData @"data"
#define kvalidOption @"validOption"

#define klanguage_name @"language_name"

#define kgmat_Total_score @"gmat_total_score"
#define kgmat_Total_Percentage @"gmat_total_percentage"

#define korganisationName @"organisationName"

// event

// global Application form

#define kGAPStep1 @"GAPStep1"
#define kGAPStep2 @"GAPStep2"
#define kGAPStep3 @"GAPStep3"
#define kGAPStep4 @"GAPStep4"

#define kRelationship @"relationship"


#define kUnivercity_name @"Univercity_name"
#define kcourse_image @"course_image"

#define kPredictiveSearchStoryBoardID @"PredictiveSearchStoryBoardID"

#define kViwMode @"viewMode"
#define kEditMode @"editMode"


// refer friend
#define kRFemail @"email[]"
#define kRFname @"name[]"
#define kRFmobile_number @"mobile_number[]"
#define kmobile_number @"mobile_number"


#define kParticipate_country_id @"participate_country_id"
#define ksearch  @"search"
#define kcity @"city"
#define Kresidential_city @"residential_city"
#define kselected_currency @"selected_currency"
// notification

#define kDeviceid @"deviceid"
#define kType @"type"
#define kNotificationText @"notificationText"
#define kReadStatus @"readStatus"
#define kNotificationId @"notificationId"
#define kTotal @"total"
#define kTotalUnread @"totalUnread"
#define kNotifications @"notifications"
#define kPlatform @"platform"

// Event Module
#define kprticipantType @"prticipantType"
#define kcountryId @"countryId"
#define kfilterType @"filterType"
#define ksearchText @"searchText"


// My Schedule

#define kslotNumber @"slotNumber"
#define kslotId @"slotId"
#define kdate_scheduled @"date_scheduled"
#define kfrom_time @"from_time"
#define kto_time @"to_time"
#define kbuttons @"buttons"
#define kpark_free @"park_free"


#define kselectEvent @"selectEvent"
#define KEvent @"Event"
#define kTYPE @"TYPE"
#define kEVENT @"EVENT"
#define kMySchedule @"My Schedule"
#define kViewParticipants @"View Participants"
#define kRecordExpression @"Record Expression"
#define kMeetingreport @"Meeting Report"
#define kLeadType @"lead_type"


#define kpayment_id @"payment_id"
#define kpayment_response @"payment_response"
#define kPaymentInfoDict @"PaymentDict"
#define kQuestionnaire @"questionnaire"

#define KminiProfileData @"miniProfileData"

#define KisGlobalApplicationDataUpdated @"isGlobalApplicationDataUpdated"
#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"

#define kTrakingID @"UA-97530226-1"


#define kselectCountrySchedule @"selectCountrySchedule"
#define kselectCountryParticipant @"selectCountryParticipant"
#define kselectCountryRecord @"selectCountryRecord"
#define kselectCountryAvailable @"selectCountryAvailable"

#define kselectTypeParticipant @"selectTypeParticipant"
#define kselectTypeSchedule @"selectTypeSchedule"
#define kselectTypeRecord @"selectTypeRecord"
#define kselectTypeAvailable @"selectTypeAvailable"

#define kselectEventMeeting @"selectEventMeeting"
#define kselectEventRecord @"selectEventRecord"

#define kScheduleFilter @"scheduleFilter"
#define kMeetingFilter @"meetingFilter"
#define kParticipantFilter @"participantFilter"
#define kRecordParticpantFilter @"RecordParticipantFilter"
#define kSearchAvailableFilter @"SearchAvailableFilter"

typedef enum _UNKWebViewMode {
    UNKScholarShip = 101,
    UNKAboutUs = 102,
    UNKTermAndConditions = 103,
    UNKNews = 104,
    UNKImportantLink = 105,
    UNKFeturedDestination = 106

    
} UNKWebViewMode;

#endif /* UNKConstant_h */
