//
//  ForgotViewController.h
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ForgotViewController : UIViewController<MBProgressHUDDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField * forgotEmail;
}
@property (nonatomic, retain) UITextField *field;
@property (nonatomic, retain) MBProgressHUD *HUD;
-(IBAction)refreshMemory:(id)sender;
-(IBAction)back:(id)sender;
@end
