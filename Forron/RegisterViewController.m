//
//  RegisterViewController.m
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize field;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    btnRegister.layer.cornerRadius = 10.0;
    UIScrollView *settingScrollView = (UIScrollView*)[self.view viewWithTag:11];
    settingScrollView.contentSize = CGSizeMake(280, 700);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark back
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark register
-(IBAction)registerUser:(id)sender
{
    if([firstName.text isEqualToString:@""]){
        [self showAlert:@"Please enter first name!"];
        [firstName becomeFirstResponder];
    }else if([lastName.text isEqualToString:@""]){
        [self showAlert:@"Please enter last name!"];
        [lastName becomeFirstResponder];
    }else if([screenName.text isEqualToString:@""]){
        [self showAlert:@"Please enter screen name!"];
        [screenName becomeFirstResponder];
    }else if([email.text isEqualToString:@""]){
        [self showAlert:@"Please enter email!"];
        [email becomeFirstResponder];
    }else if([password.text isEqualToString:@""]){
        [self showAlert:@"Please enter password!"];
        [password becomeFirstResponder];
    }else{
        NSUserDefaults * myDefaults = [NSUserDefaults standardUserDefaults];
        [myDefaults setObject:firstName.text forKey:@"user_firstname"];
        [myDefaults setObject:lastName.text forKey:@"user_lastname"];
        [myDefaults setObject:screenName.text forKey:@"user_screenname"];
        [myDefaults setObject:email.text forKey:@"user_email"];
        [myDefaults setObject:password.text forKey:@"user_password"];
        [myDefaults synchronize];
        [self performSegueWithIdentifier:@"Terms" sender:nil];
    }
}

#pragma mark uitextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

-(void) showAlert:(NSString *) strAlert_content{
    
    UIAlertView *alert_string = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                           message:strAlert_content
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    [alert_string show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
