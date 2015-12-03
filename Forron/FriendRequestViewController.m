//
//  FriendRequestViewController.m
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import "FriendRequestViewController.h"
#import "SidebarViewController.h"
#import <Parse/Parse.h>

@implementation FriendRequestViewController
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
    [self.friendTableView setEditing:YES animated:NO];
    
    
    friendIdArray = [[NSMutableArray alloc] init];
    friendNameArray = [[NSMutableArray alloc] init];
    friendEmailArray = [[NSMutableArray alloc] init];
    
    searchfriendIdArray = [[NSMutableArray alloc] init];
    searchfriendNameArray = [[NSMutableArray alloc] init];
    searchfriendEmailArray = [[NSMutableArray alloc] init];
    
    requestFlag = 1;
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *bodyData = [NSString stringWithFormat:@"user_id=%@",userid];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://forron.com/web_service/search_shared_users.php"]];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyboard];
    //call didSelectRow of tableView again, by passing the touch to the super class
    [super touchesBegan:touches withEvent:event];
}


- (void) dismissKeyboard
{
    [bar resignFirstResponder];
}

#pragma mark nsurlconnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [HUD hide:YES];
    [self showAlert:@"failed"];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [HUD hide:YES];
    if (requestFlag == 1) {
        [friendIdArray removeAllObjects];
        [friendNameArray removeAllObjects];
        [friendEmailArray removeAllObjects];
        NSMutableArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if ([dataArray count] != 1) {
            for (int i = 0; i < [dataArray count]; i++) {
                NSMutableDictionary *jsonData = [dataArray objectAtIndex:i];
                [friendIdArray addObject:[jsonData objectForKey:@"user_id"]];
                [friendNameArray addObject:[jsonData objectForKey:@"user_name"]];
                [friendEmailArray addObject:[jsonData objectForKey:@"email"]];
            }
            [searchfriendIdArray addObjectsFromArray:friendIdArray];
            [searchfriendNameArray addObjectsFromArray:friendNameArray];
            [searchfriendEmailArray addObjectsFromArray:friendEmailArray];
            [self.friendTableView reloadData];
        } else if( [dataArray count] == 1){
            NSMutableDictionary *jsonData = [dataArray objectAtIndex:0];
            [friendIdArray addObject:[jsonData objectForKey:@"user_id"]];
            [friendNameArray addObject:[jsonData objectForKey:@"user_name"]];
            [friendEmailArray addObject:[jsonData objectForKey:@"email"]];
            [searchfriendIdArray addObjectsFromArray:friendIdArray];
            [searchfriendNameArray addObjectsFromArray:friendNameArray];
            [searchfriendEmailArray addObjectsFromArray:friendEmailArray];
            [self.friendTableView reloadData];
        }
    } else if (requestFlag == 2) {
        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([result isEqualToString:@"success"]) {
            
                   
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%@ has accepted your friend request", username], @"alert",
                                  username, @"username",@"accept" ,@"type"
                                  ,shardlist, @"shardids",userid,@"userid",
                                  nil];
            
            PFPush *push = [[PFPush alloc] init];
            [push setChannel:@"global"];
            [push setData:data];
            [push sendPushInBackground];
            
            [self showAlert:@"success"];
            
            requestFlag = 1;
            
            NSString *bodyData = [NSString stringWithFormat:@"user_id=%@",userid];
            NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://forron.com/web_service/search_shared_users.php"]];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showMenu:(id)sender
{
    if ([[SidebarViewController share] isShowMenu]) {
        if ([[SidebarViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]){
            [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    } else {
        if ([[SidebarViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]){
            [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
        }
    }
}



#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [searchfriendIdArray count];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [bar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [bar resignFirstResponder];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure a cell to show the corresponding string from the array.
    static NSString *kCellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	cell.textLabel.text = [searchfriendNameArray objectAtIndex:indexPath.row];
	return cell;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    
    [searchfriendIdArray removeAllObjects];
    [searchfriendNameArray removeAllObjects];
    [searchfriendEmailArray removeAllObjects];
    for (int i = 0; i < [friendIdArray count]; i++) {
        NSString * name = [friendNameArray objectAtIndex:i];
        if ([name  rangeOfString:searchText].length != 0 || [searchText isEqualToString:@""]) {
            [searchfriendIdArray addObject:[friendIdArray objectAtIndex:i]];
            [searchfriendNameArray addObject:[friendNameArray objectAtIndex:i]];
            [searchfriendEmailArray addObject:[friendEmailArray objectAtIndex:i]];
        }
    }
    [self.friendTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *searchString = searchBar.text;
    
    [searchfriendIdArray removeAllObjects];
    [searchfriendNameArray removeAllObjects];
    [searchfriendEmailArray removeAllObjects];
    for (int i = 0; i < [friendIdArray count]; i++) {
        NSString * name = [friendNameArray objectAtIndex:i];
        if ([name isEqualToString:searchString]) {
            [searchfriendIdArray addObject:[friendIdArray objectAtIndex:i]];
            [searchfriendNameArray addObject:[friendNameArray objectAtIndex:i]];
            [searchfriendEmailArray addObject:[friendEmailArray objectAtIndex:i]];
        }
    }
    [self.friendTableView reloadData];
    
}

-(IBAction)AcceptRequest:(id)sender
{
    shardlist = @"";
    NSArray *selectedRows = [self.friendTableView indexPathsForSelectedRows];
    if ([selectedRows count] == 0) {
        return;
    }
    for (NSIndexPath *selectionIndex in selectedRows)
    {
        shardlist = [NSMutableString stringWithFormat:@"%@,%@", [searchfriendIdArray objectAtIndex:selectionIndex.row],shardlist];
    }
    shardlist = [shardlist substringToIndex:[shardlist length] - 1];
    requestFlag = 2;
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *bodyData = [NSString stringWithFormat:@"user_id=%@&request_ids=%@",userid ,shardlist];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://forron.com/web_service/send_agree_request.php"]];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) showAlert:(NSString *) strAlert_content{
    
    UIAlertView *alert_string = [[UIAlertView alloc] initWithTitle:@"FORRON"
                                                           message:strAlert_content
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    [alert_string show];
}

@end
