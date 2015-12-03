//
//  TermConditionViewController.m
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import "TermConditionViewController.h"

@implementation TermConditionViewController
@synthesize HUD;
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
    NSString *httpSource = @"http://forron.com/terms.html";
    NSURL *fullUrl = [NSURL URLWithString:httpSource];
    NSURLRequest *httpRequest = [NSURLRequest requestWithURL:fullUrl];
    [termsWebView loadRequest:httpRequest];
    btnAccept.layer.cornerRadius = 10.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)acceptTerms:(id)sender
{
    
    
    NSUserDefaults * myDefaults = [NSUserDefaults standardUserDefaults];
    [myDefaults synchronize];
    
    NSString * postFirstName = [myDefaults objectForKey:@"user_firstname"];
    NSString * postLastName = [myDefaults objectForKey:@"user_lastname"];
    NSString * postScreenName = [myDefaults objectForKey:@"user_screenname"];
    NSString * postEmail = [myDefaults objectForKey:@"user_email"];
    NSString * postPassword = [myDefaults objectForKey:@"user_password"];
    
    NSString *bodyData = [NSString stringWithFormat:@"field1=%@&field2=%@&field3=%@&field4=%@&field5=%@", postFirstName, postLastName, postScreenName, postEmail, postPassword];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://forron.com/web_service/register.php"]];
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [HUD hide:YES];
    [self showAlert:@"login failed"];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [HUD hide:YES];
    NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([result isEqualToString:@"success"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if([result isEqualToString:@"exist"]) {
        [self showAlert:@"The user have already exist!"];
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
