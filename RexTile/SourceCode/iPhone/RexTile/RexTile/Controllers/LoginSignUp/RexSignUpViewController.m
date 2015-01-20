//
//  SignUpViewController.m
//  RexTile
//
//  Created by Sweety Singh on 12/18/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "RexSignUpViewController.h"
#import "Constants.h"
#import "UserModel.h"
#import "RexTabBarController.h"
#import "CountryListViewController.h"
#import "NSObject+NullChecker.h"
#import "VerificationViewController.h"
#import "UserWebServiceClient.h"


@interface RexSignUpViewController ()<UIAlertViewDelegate, UITextFieldDelegate,CountryListViewDelegate,WebServiceDelegate>{
    
    UITapGestureRecognizer *tapGesture;
    NSString *strCountryCode;
   
}
@property (strong, nonatomic) IBOutlet UIButton *btnCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNo;
@property (strong, nonatomic) UserWebServiceClient *userService;



@end

@implementation RexSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self.btnCountry setTitle:@"Please select your country code" forState:UIControlStateNormal];
    [self setCharacteristicksOfTextField:self.txtPhoneNo withCode:@""];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setHidden:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




-(void)setCharacteristicksOfTextField:(UITextField *)textField withCode:(NSString *)code
{
//    NSRange range = NSMakeRange(title.length-textRange, textRange);
//    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(202, 5, 52, 1), NSForegroundColorAttributeName, nil];
//    
//    NSDictionary *subattr = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(93, 93, 93, 1), NSForegroundColorAttributeName, nil];
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:title attributes:attr];
//    [attributedText setAttributes:subattr range:range];
    
    
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = [UIColor darkGrayColor];
    textField.font =  Helvetica_RegularWithSize(15);
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.backgroundColor=[UIColor whiteColor];
   // textField.attributedText = attributedText;
    if (![NSObject isNull:code]) {
        CGFloat width = ceil([code sizeWithAttributes:@{NSFontAttributeName:[textField font]}].width);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(2, 1, width+5 ,20)];
        UILabel *lblCountryCode=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width+5 ,20)];
        lblCountryCode.text = code;
        lblCountryCode.font = Helvetica_RegularWithSize(15);
        lblCountryCode.textColor = [UIColor darkGrayColor];
        lblCountryCode.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lblCountryCode];
        
        textField.leftView = view;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
   
}




#pragma mark -
#pragma mark Actions

- (IBAction)btnCountryClicked:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:LoginStoryboard bundle:nil];
    
    CountryListViewController *countryListView = (CountryListViewController *)[storyBoard instantiateViewControllerWithIdentifier:CountryList];
    countryListView.delegate = self;
    [self.navigationController pushViewController:countryListView animated:NO];
    
//    
//    CountryListViewController *cv = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" delegate:self];
//    [self.navigationController pushViewController:cv animated:YES];
    
    
}
- (IBAction)btnContinueClicked:(id)sender {
    
    [self.txtPhoneNo resignFirstResponder];
    
    if (strCountryCode != nil && [TrimSting(self.txtPhoneNo.text) length] >0) {
        NSString *number = [NSString stringWithFormat:@"Number Conformation:\n%@ %@",strCountryCode, self.txtPhoneNo.text];
        [[[UIAlertView alloc] initWithTitle:number message:@"Is your phone number correct?" delegate:self cancelButtonTitle:@"Edit" otherButtonTitles:@"Yes", nil] show];
    }else{
        [[[UIAlertView alloc] initWithTitle:AlertTitle message:@"Please select your country or enter your phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
   
    
}

- (void)pushTabBarController
{
    UserModel *user = [UserModel sharedInstance];
    user.user_userId = @"user";
    if(user.user_userId)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
        
        RexTabBarController *tabBarController = (RexTabBarController *)[storyBoard instantiateViewControllerWithIdentifier:TabBarController];
        
        [self.navigationController pushViewController:tabBarController animated:NO];
    }
    
}
- (void)pushVerificationController
{
   
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:LoginStoryboard bundle:nil];
        
    VerificationViewController *verificationView = (VerificationViewController *)[storyBoard instantiateViewControllerWithIdentifier:VerificationView];
        
    [self.navigationController pushViewController:verificationView animated:NO];
    
    
}
-(void)registerLoginUser{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    self.userService = [[UserWebServiceClient alloc] init];
    self.userService.tag =1;
    self.userService.delegate = self;
    NSString *strPhone = [NSString stringWithFormat:@"%@%@",strCountryCode,self.txtPhoneNo.text];
    [self.userService signInUserWithPhone:strPhone email:@""];
}





#pragma mark -
#pragma mark UIAlertView Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Edit");
            [self.txtPhoneNo becomeFirstResponder];
            break;
        case 1:
            NSLog(@"Yes");
            // call web service
           // [self pushTabBarController];
            [self registerLoginUser];
            break;
            
        default:
            break;
    }
}



#pragma Mark - UITextfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self addTapGesture];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
   
}


#pragma mark - Tap Gesture Methods

-(void)tapGestureClicked:(UITapGestureRecognizer *)tap{
    [self.view removeGestureRecognizer:tapGesture];
    tapGesture=nil;
    [self.view endEditing:YES];
    
}
-(void)addTapGesture{
    if(tapGesture){
        [self.view removeGestureRecognizer:tapGesture];
        tapGesture=nil;
    }
    tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClicked:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma Mark CountryListView Delegate
- (void)didSelectCountry:(NSDictionary *)country{
    NSLog(@"Country %@",country);
    NSString *countryCode = [NSString stringWithFormat:@"%@ (%@)",[country valueForKey:@"name"],[country valueForKey:@"dial_code"]];
    [self.btnCountry setTitle:countryCode forState:UIControlStateNormal];
    strCountryCode =[country valueForKey:@"dial_code"];
    [self setCharacteristicksOfTextField:self.txtPhoneNo withCode:[country valueForKey:@"dial_code"]];
   
}


#pragma mark - WEBSERVICE DELEGATES

-(void)request:(id)asynchroniousRequest didFinishWithResult:(NSArray *)result{
    //  NSLog(@"result %@",result);
    [MBProgressHUD dismissGlobalHUD];
    
    switch ([asynchroniousRequest tag])
    {
        case 1://SIGN UP
        {
            
            UserModel *user = [result objectAtIndex:0];
            [user saveSettings];
            
            if(user.user_userId)
            {
               
                [self pushTabBarController];
                
            }
            
        }
            break;
            
                default:
            break;
    }
    
    
}

-(void)request:(id)asynchroniousRequest didFailWithError:(NSError *)error
{
    [MBProgressHUD dismissGlobalHUD];
    
    
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
