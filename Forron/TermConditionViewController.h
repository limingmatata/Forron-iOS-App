//
//  TermConditionViewController.h
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TermConditionViewController : UIViewController<MBProgressHUDDelegate>
{
    IBOutlet UIWebView * termsWebView;
    IBOutlet UIButton * btnAccept;
}
@property (nonatomic, retain) MBProgressHUD *HUD;
-(IBAction)acceptTerms:(id)sender;
-(IBAction)back:(id)sender;
@end
