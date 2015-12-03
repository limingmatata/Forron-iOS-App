//
//  LoginViewController.h
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController<MBProgressHUDDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate>
{
    BOOL focusFlag;
    IBOutlet UITextField * loginUserName;
    IBOutlet UITextField * loginPassword;
    
    IBOutlet UIButton * btnLogin;
    IBOutlet UIButton * btnForgotPass;
    IBOutlet UIButton * btnBack;

}
@property (nonatomic, retain) UITextField *field;
@property (nonatomic, retain) MBProgressHUD *HUD;
-(IBAction)login:(id)sender;
-(IBAction)forgotPassword:(id)sender;
-(IBAction)back:(id)sender;
@end
