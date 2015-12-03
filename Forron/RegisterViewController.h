//
//  RegisterViewController.h
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField * firstName;
    IBOutlet UITextField * lastName;
    IBOutlet UITextField * screenName;
    IBOutlet UITextField * email;
    IBOutlet UITextField * password;
    IBOutlet UIButton * btnRegister;
}
@property (nonatomic, retain) UITextField *field;
-(IBAction)back:(id)sender;
-(IBAction)registerUser:(id)sender;
@end
