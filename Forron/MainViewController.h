//
//  MainViewController.h
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    IBOutlet UIButton * btnLogin;
    IBOutlet UIButton * btnRegister;
}

- (IBAction)login:(id)sender;
@end
