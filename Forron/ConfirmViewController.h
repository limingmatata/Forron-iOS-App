//
//  ConfirmViewController.h
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmViewController : UIViewController
{
    IBOutlet UIButton * btnGotoLogin;
}


-(IBAction)gotoLogin:(id)sender;
-(IBAction)back:(id)sender;

@end
