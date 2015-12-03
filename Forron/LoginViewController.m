//
//  LoginViewController.m
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize HUD;
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
    btnLogin.layer.cornerRadius = 10.0;
    btnBack.layer.cornerRadius = 5.0;
    btnForgotPass.layer.cornerRadius = 10.0;
    UIScrollView *settingScrollView = (UIScrollView*)[self.view viewWithTag:11];
    settingScrollView.contentSize = CGSizeMake(240, 350);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark login
-(IBAction)login:(id)sender
{
    if([loginUserName.text isEqualToString:@""]){
        [self showAlert:@"Please enter your name!"];
        [loginUserName becomeFirstResponder];
    }else if([loginPassword.text isEqualToString:@""]){
        [self showAlert:@"Please enter password!"];
        [loginPassword becomeFirstResponder];
    }else{
        NSString * postUserName = loginUserName.text;
        NSString * postPassword = loginPassword.text;
        
        NSString *bodyData = [NSString stringWithFormat:@"field1=%@&field2=%@",postUserName,postPassword];
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://forron.com/web_service/login.php"]];
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
        if (conn) {
            NSLog(@"connection successful");
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.delegate = self;
        }else{
            NSLog(@"connection could not be made");
        }
    }
}

#pragma mark forgot password
-(IBAction)forgotPassword:(id)sender
{
    
}

#pragma mark nsurlconnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [HUD hide:YES];
    [self showAlert:@"login failed"];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [HUD hide:YES];
    NSMutableArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSMutableDictionary *jsonData = [dataArray objectAtIndex:0];
    
    NSString *result = [jsonData objectForKey:@"result"];
    if ([result isEqualToString:@"success"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[jsonData objectForKey:@"user_name"] forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:[jsonData objectForKey:@"user_id"] forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setObject:[jsonData objectForKey:@"friends"] forKey:@"friends"];
        [[NSUserDefaults standardUserDefaults] setObject:@"login" forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"ShowHome" sender:nil];
    } else {
        [self showAlert:@" username or password is wrong"];
    }
}

#pragma mark back
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) showAlert:(NSString *) strAlert_content{
    
    UIAlertView *alert_string = [[UIAlertView alloc] initWithTitle:@"FORRON"
                                                           message:strAlert_content
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    [alert_string show];
}

#pragma mark uitextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    field = textField;
    self.view.frame = CGRectMake(0, -70, self.view.frame.size.width, self.view.frame.size.height);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (field == textField) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
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
