//
//  LeftSideBarViewController.h
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideBarSelectDelegate;

@interface LeftSideBarViewController : UIViewController
{
    
}
@property (assign,nonatomic)id<SideBarSelectDelegate>delegate;
-(IBAction)logout:(id)sender;
-(IBAction)showAddFriendView:(id)sender;
-(IBAction)showFriendRequestView:(id)sender;
-(IBAction)showHomeView:(id)sender;
-(IBAction)showCurrentLocationView:(id)sender;
@end
