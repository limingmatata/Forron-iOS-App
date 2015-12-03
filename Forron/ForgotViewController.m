//
//  ForgotViewController.m
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import "ForgotViewController.h"

@implementation ForgotViewController
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)refreshMemory:(id)sender
{
    if([forgotEmail.text isEqualToString:@""]){
        [self showAlert:@"Please enter email!"];
        [forgotEmail becomeFirstResponder];
    }else{
        NSString *bodyData = [NSString stringWithFormat:@"field1=%@",forgotEmail.text];
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://forron.com/web_service/forgot_pass.php"]];
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

#pragma mark nsurlconnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [HUD hide:YES];
    [self showAlert:@"login failed"];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [HUD hide:YES];
    NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([result isEqualToString:@"Success!"]) {
        [self performSegueWithIdentifier:@"Confirm" sender:nil];
    } else {
        [self showAlert:@"Failed"];
    }
}



-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) showAlert:(NSString *) strAlert_content{
    
    UIAlertView *alert_string = [[UIAlertView alloc] initWithTitle:@"Warning!"
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
    self.view.frame = CGRectMake(0, -120, self.view.frame.size.width, self.view.frame.size.height);
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
