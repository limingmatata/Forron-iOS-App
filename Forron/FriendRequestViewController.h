//
//  FriendRequestViewController.h
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FriendRequestViewController : UIViewController<MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate>
{
    
    int  requestFlag;
    NSMutableArray *friendIdArray;
    NSMutableArray *friendNameArray;
    NSMutableArray *friendEmailArray;
    
    NSMutableArray *searchfriendIdArray;
    NSMutableArray *searchfriendNameArray;
    NSMutableArray *searchfriendEmailArray;
    
    NSString *shardlist;
    IBOutlet UISearchBar       *bar;
}
@property(nonatomic, retain) IBOutlet UITableView *friendTableView;
@property(nonatomic, retain) MBProgressHUD *HUD;

-(IBAction)AcceptRequest:(id)sender;
-(IBAction)showMenu:(id)sender;
@end