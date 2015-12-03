//
//  HomeViewController.m
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import "HomeViewController.h"
#import "SidebarViewController.h"
#import "DataManager.h"
#import "MLTableAlert.h"
#import <Parse/Parse.h>
#import "ASIFormDataRequest.h"

@implementation HomeViewController
@synthesize locationManager;
@synthesize locationFlag;
@synthesize mapView;
@synthesize alert;
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
    aryCategoryImage = [[NSMutableArray alloc] init];
    [aryCategoryImage addObject:@"red_icon.png"];
    [aryCategoryImage addObject:@"yellow_icon.png"];
    [aryCategoryImage addObject:@"blue_icon.png"];
    
    aryCategoryName = [[NSMutableArray alloc] init];
    [aryCategoryName addObject:@"FOOD & DRINKS"];
    [aryCategoryName addObject:@"RETAIL & SHOPPING"];
    [aryCategoryName addObject:@"RECREATIONAL"];
    [self.mapView setShowsUserLocation:YES];
    
    
    friendArray = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSData *productData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://forron.com/web_service/search_product.php?username=%@",username]]];
        NSMutableArray *dataArray = [NSJSONSerialization JSONObjectWithData:productData options:kNilOptions error:nil];
        NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
        
        [[DataManager getInstance].productNameArray removeAllObjects];
        [[DataManager getInstance].productCategoryArray removeAllObjects];
        [[DataManager getInstance].productLatArray removeAllObjects];
        [[DataManager getInstance].productLngArray removeAllObjects];
        [[DataManager getInstance].productShardNameArray removeAllObjects];
        [[DataManager getInstance].productStatusArray removeAllObjects];
        [[DataManager getInstance].productUrlArray removeAllObjects];
         
        for (int i = 0; i < [dataArray count]; i++) {
            
            NSMutableDictionary *jsonData = [dataArray objectAtIndex:i];
            NSString * productName = [jsonData objectForKey:@"product_name"];
            NSString * productCategory = [jsonData objectForKey:@"product_category"];
            NSString * productLat = [jsonData objectForKey:@"product_latitude"];
            NSString * productLng = [jsonData objectForKey:@"product_longitude"];
            NSString * productSharedName = [jsonData objectForKey:@"shared_name"];
            NSString * productUrl = [jsonData objectForKey:@"product_url"];
            NSString * productStatus = [jsonData objectForKey:@"product_status"];
            
            [[DataManager getInstance].productNameArray addObject:productName];
            [[DataManager getInstance].productCategoryArray addObject:productCategory];
            [[DataManager getInstance].productLatArray addObject:productLat];
            [[DataManager getInstance].productLngArray addObject:productLng];
            [[DataManager getInstance].productShardNameArray addObject:productSharedName];
            [[DataManager getInstance].productUrlArray addObject:productUrl];
            [[DataManager getInstance].productStatusArray addObject:productStatus];
            
            MapAnnotation *annotation = [[MapAnnotation alloc] init];
            annotation.type = [NSString stringWithFormat:@"%@",productCategory];
            annotation.productShardName = productSharedName;
            annotation.productName = productName;
            annotation.shardFlag = productStatus;
            annotation.productUrl = productUrl;
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [productLat doubleValue];
            coordinate.longitude = [productLng doubleValue];
            annotation.coordinate = coordinate;
           
            [annotationArray addObject:annotation];
        }
        if ([annotationArray count] != 0) {
            [self.mapView addAnnotations:annotationArray];
            if (locationFlag == NO) {
                lastProductLocation.latitude = [[[DataManager getInstance].productLatArray lastObject] doubleValue];
                lastProductLocation.longitude = [[[DataManager getInstance].productLngArray lastObject] doubleValue];
                float spanX = 0.05;
                float spanY = 0.05;
                MKCoordinateRegion region;
                region.center.latitude = lastProductLocation.latitude;
                region.center.longitude = lastProductLocation.longitude;
                region.span.latitudeDelta = spanX;
                region.span.longitudeDelta = spanY;
                [self.mapView setRegion:region animated:YES];
            }
        }
    });
    
    UIScrollView *settingScrollView = (UIScrollView*)[settingView viewWithTag:10];
    settingScrollView.contentSize = CGSizeMake(220, 350);
    UIButton *button1 = (UIButton*)[settingView viewWithTag:15];
    button1.layer.cornerRadius = 10.0;
    UIButton *button2 = (UIButton*)[settingView viewWithTag:16];
    button2.layer.cornerRadius = 10.0;
    
    UIScrollView *productScrollView = (UIScrollView*)[productView viewWithTag:20];
    productScrollView.contentSize = CGSizeMake(220, 350);
    UIButton *button3 = (UIButton*)[productView viewWithTag:25];
    button3.layer.cornerRadius = 10.0;
    UIButton *button4 = (UIButton*)[productView viewWithTag:26];
    button4.layer.cornerRadius = 10.0;
    selectedCategory = @"food_drinks";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark show menu
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

#pragma mark show food
-(IBAction)showFood:(id)sender
{
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    for (int i = 0; i< [[DataManager getInstance].productCategoryArray count]; i++) {
        NSString *category = [[DataManager getInstance].productCategoryArray objectAtIndex:i];
        if ([category isEqualToString:@"food_drinks"] && [[[DataManager getInstance].productStatusArray objectAtIndex:i] isEqualToString:@"0"]) {
            MapAnnotation *annotation = [[MapAnnotation alloc] init];
            annotation.type = [[DataManager getInstance].productCategoryArray objectAtIndex:i];
            annotation.productShardName = [[DataManager getInstance].productShardNameArray objectAtIndex:i];
            annotation.productName = [[DataManager getInstance].productNameArray objectAtIndex:i];
            annotation.productUrl = [[DataManager getInstance].productUrlArray objectAtIndex:i];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude   = [[[DataManager getInstance].productLatArray objectAtIndex:i] doubleValue];
            coordinate.longitude  = [[[DataManager getInstance].productLngArray objectAtIndex:i] doubleValue];
            annotation.coordinate = coordinate;
            [annotationArray addObject:annotation];
        }
    }
    [self.mapView addAnnotations:annotationArray];
}

#pragma mark show retail
-(IBAction)showRetail:(id)sender
{
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    for (int i = 0; i< [[DataManager getInstance].productCategoryArray count]; i++) {
        NSString *category = [[DataManager getInstance].productCategoryArray objectAtIndex:i];
        if ([category isEqualToString:@"retail_shopping"] && [[[DataManager getInstance].productStatusArray objectAtIndex:i] isEqualToString:@"0"]) {
            MapAnnotation *annotation = [[MapAnnotation alloc] init];
            annotation.type = [[DataManager getInstance].productCategoryArray objectAtIndex:i];
            annotation.productShardName = [[DataManager getInstance].productShardNameArray objectAtIndex:i];
            annotation.productName = [[DataManager getInstance].productNameArray objectAtIndex:i];
            annotation.productUrl = [[DataManager getInstance].productUrlArray objectAtIndex:i];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude   = [[[DataManager getInstance].productLatArray objectAtIndex:i] doubleValue];
            coordinate.longitude  = [[[DataManager getInstance].productLngArray objectAtIndex:i] doubleValue];
            annotation.coordinate = coordinate;
            [annotationArray addObject:annotation];
        }
    }
    [self.mapView addAnnotations:annotationArray];
}
#pragma mark show recreational
-(IBAction)showRecreational:(id)sender
{
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    for (int i = 0; i< [[DataManager getInstance].productCategoryArray count]; i++) {
        NSString *category = [[DataManager getInstance].productCategoryArray objectAtIndex:i];
        if ([category isEqualToString:@"recreational"] && [[[DataManager getInstance].productStatusArray objectAtIndex:i] isEqualToString:@"0"]) {
            MapAnnotation *annotation = [[MapAnnotation alloc] init];
            annotation.type = [[DataManager getInstance].productCategoryArray objectAtIndex:i];
            annotation.productShardName = [[DataManager getInstance].productShardNameArray objectAtIndex:i];
            annotation.productName = [[DataManager getInstance].productNameArray objectAtIndex:i];
            annotation.productUrl = [[DataManager getInstance].productUrlArray objectAtIndex:i];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude   = [[[DataManager getInstance].productLatArray objectAtIndex:i] doubleValue];
            coordinate.longitude  = [[[DataManager getInstance].productLngArray objectAtIndex:i] doubleValue];
            annotation.coordinate = coordinate;
            [annotationArray addObject:annotation];
        }
    }
    [self.mapView addAnnotations:annotationArray];
}

-(IBAction)showShard:(id)sender
{
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    for (int i = 0; i< [[DataManager getInstance].productCategoryArray count]; i++) {
        if ([[[DataManager getInstance].productStatusArray objectAtIndex:i] isEqualToString:@"1"]) {
            MapAnnotation *annotation = [[MapAnnotation alloc] init];
            annotation.type = [[DataManager getInstance].productCategoryArray objectAtIndex:i];
            annotation.productShardName = [[DataManager getInstance].productShardNameArray objectAtIndex:i];
            annotation.productName = [[DataManager getInstance].productNameArray objectAtIndex:i];
            annotation.productUrl = [[DataManager getInstance].productUrlArray objectAtIndex:i];
            annotation.shardFlag = [[DataManager getInstance].productStatusArray objectAtIndex:i];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude   = [[[DataManager getInstance].productLatArray objectAtIndex:i] doubleValue];
            coordinate.longitude  = [[[DataManager getInstance].productLngArray objectAtIndex:i] doubleValue];
            annotation.coordinate = coordinate;
            [annotationArray addObject:annotation];
        }
    }
    [self.mapView addAnnotations:annotationArray];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    MapAnnotation *mapAnnotation = (MapAnnotation*)annotation;
    MKAnnotationView *annotationView  = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[NSString stringWithFormat:@"%@:%@", mapAnnotation.productShardName,mapAnnotation.productName]];
   
    if ([mapAnnotation.shardFlag isEqualToString:@"1"]) {
        annotationView.image = [UIImage imageNamed:@"green_icon.png"];
    } else if ([mapAnnotation.type isEqualToString:@"food_drinks"]) {
        annotationView.image = [UIImage imageNamed:@"red_icon.png"];
    } else if ([mapAnnotation.type isEqualToString:@"retail_shopping"]) {
        annotationView.image = [UIImage imageNamed:@"yellow_icon.png"];
    } else if ([mapAnnotation.type isEqualToString:@"recreational"]) {
        annotationView.image = [UIImage imageNamed:@"blue_icon.png"];
    }
    
    annotationView.annotation = mapAnnotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MapAnnotation *mapAnnotation = (MapAnnotation*)view.annotation;
    if (view.annotation == self.mapView.userLocation) {
        return;
    }
    NSString *productName = mapAnnotation.productName;
    NSString *productShardName = mapAnnotation.productShardName;
    NSString *productUrl = mapAnnotation.productUrl;
    NSString *productCategory = mapAnnotation.type;
    
    UIImageView *headImageView = (UIImageView*)[settingView viewWithTag:11];
    UILabel *headLabel = (UILabel*)[settingView viewWithTag:12];
    if ([mapAnnotation.shardFlag isEqualToString:@"1"]) {
        [headImageView setBackgroundColor:[UIColor greenColor]];
        if ([productCategory isEqualToString:@"food_drinks"]) {
            headLabel.text = @"FOOD & DRINK";
            headLabel.textColor = [UIColor whiteColor];
        } else if([productCategory isEqualToString:@"retail_shopping"]){
            headLabel.text = @"RETAIL & SHOPPING";
            headLabel.textColor = [UIColor blackColor];
        } else if([productCategory isEqualToString:@"recreational"]){
            headLabel.text = @"RECREATIONAL";
            headLabel.textColor = [UIColor whiteColor];
        }
    } else if ([productCategory isEqualToString:@"food_drinks"]) {
        [headImageView setBackgroundColor:[UIColor redColor]];
        headLabel.text = @"FOOD & DRINK";
        headLabel.textColor = [UIColor whiteColor];
    } else if([productCategory isEqualToString:@"retail_shopping"]){
        [headImageView setBackgroundColor:[UIColor yellowColor]];
        headLabel.text = @"RETAIL & SHOPPING";
        headLabel.textColor = [UIColor blackColor];
    } else if([productCategory isEqualToString:@"recreational"]){
        [headImageView setBackgroundColor:[UIColor blueColor]];
        headLabel.text = @"RECREATIONAL";
        headLabel.textColor = [UIColor whiteColor];
    }
    UILabel *descriptionLabel = (UILabel*)[settingView viewWithTag:14];
    descriptionLabel.text = [NSString stringWithFormat:@"%@\n%@", productName,productShardName];
    UIImageView *productImageView = (UIImageView*)[settingView viewWithTag:13];
    [productImageView setImage:nil];
    [self downloadImageWithURL:[NSURL URLWithString:productUrl] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            UIImageView *productImageView = (UIImageView*)[settingView viewWithTag:13];
            // cache the image for use later (when scrolling up)
            [productImageView setImage:image];
        }
    }];
    selectedProductLocation = mapAnnotation.coordinate;
    selectedAnnotation = mapAnnotation;
    [settingView setHidden:NO];
}
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                       queue:[NSOperationQueue mainQueue]
           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
               if ( !error )
               {
                   UIImage *image = [[UIImage alloc] initWithData:data];
                   completionBlock(YES,image);
               } else{
                   completionBlock(NO,nil);
               }
           }];
}

-(IBAction)removeFromMap:(id)sender
{
    NSString *url = selectedAnnotation.productUrl;
    for (int i = 0; i < [[DataManager getInstance].productUrlArray count]; i ++) {
        NSString *proUrl = [[DataManager getInstance].productUrlArray objectAtIndex:i];
        if ([url isEqualToString:proUrl] == YES ) {
            [[DataManager getInstance].productCategoryArray removeObjectAtIndex:i];
            [[DataManager getInstance].productLatArray removeObjectAtIndex:i];
            [[DataManager getInstance].productLngArray removeObjectAtIndex:i];
            [[DataManager getInstance].productNameArray removeObjectAtIndex:i];
            [[DataManager getInstance].productShardNameArray removeObjectAtIndex:i];
            [[DataManager getInstance].productStatusArray removeObjectAtIndex:i];
            [[DataManager getInstance].productUrlArray removeObjectAtIndex:i];
            [self.mapView removeAnnotation:selectedAnnotation];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *bodyData = [NSString stringWithFormat:@"marker_name=%@",selectedAnnotation.productName];
                NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://forron.com/web_service/remove_product.php"]];
                [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [postRequest setHTTPMethod:@"POST"];
                [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
                NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
                if (conn) {
                    NSLog(@"connection successful");
                }else{
                    NSLog(@"connection could not be made");
                }
            });
        }
    }
    [settingView setHidden:YES];
}


-(IBAction)setHidden:(id)sender
{
    [settingView setHidden:YES];
    
}


-(IBAction)setHiddenProductView:(id)sender
{
    [productView setHidden:YES];
    
}

-(IBAction)sendToFriend:(id)sender
{
    requestKind = 1;
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSString *bodyData = [NSString stringWithFormat:@"user_id=%@",userid];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://forron.com/web_service/search_friends.php"]];
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
    [self showAlert:@"connection failed"];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [HUD hide:YES];
    if (requestKind == 1) {
        [friendArray removeAllObjects];
        NSMutableArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        for (int i = 0; i < [dataArray count]; i++) {
            NSMutableDictionary *jsonData = [dataArray objectAtIndex:i];
            NSString *username = [jsonData objectForKey:@"user_name"];
            [friendArray addObject:username];
        }
        if ([friendArray count] > 0) {
            [self showTableAlert:nil];
        }
    } else if (requestKind == 2){
        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([result isEqualToString:@"success"]) {
            [self showAlert:@"Recommendation sent"];
            
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%@ has sent %@ to you", username,selectedAnnotation.productName], @"alert",
                                  username, @"username",@"send_product" ,@"type"
                                  ,friendList, @"requestids",userid,@"userid",
                                  nil];
            
            PFPush *push = [[PFPush alloc] init];
            [push setChannel:@"global"];
            [push setData:data];
            [push sendPushInBackground];
            [settingView setHidden:YES];
        } else {
            [self showAlert:@"Something went wrong! Please try again"];
        }
    }  else if(requestKind == 3) {
        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([result isEqualToString:@"success"]) {
            [self showAlert:@"Hazzah! Star saved successfully!"];
        } else {
            [self showAlert:@"Something went wrong! Please try again."];
        }
    }
}

-(void)showTableAlert:(id)sender
{
	// create the alert
	self.alert = [MLTableAlert tableAlertWithTitle:@"Choose your friends" cancelButtonTitle:@"Done" numberOfRows:^NSInteger (NSInteger section)
          {
             return [friendArray count];
          }
             andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
          {
              static NSString *CellIdentifier = @"CellIdentifier";
              UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
              if (cell == nil)
                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
              cell.textLabel.text = [friendArray objectAtIndex:indexPath.row];
              return cell;
          }];
	
	// Setting custom alert height
	self.alert.height = 350;
	self.alert.selectionModeFlag = YES;
    
	// configure actions to perform
	[self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
		
	} andCompletionBlock:^{
        friendList = @"";
        NSArray *selectedRows = [self.alert.table indexPathsForSelectedRows];
        if ([selectedRows count] != 0) {
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                friendList = [NSString stringWithFormat:@"%@%@,",friendList, [friendArray objectAtIndex:selectionIndex.row]];
            }
//          friendList = [friendList substringFromIndex:1];
            requestKind = 2;
            NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            NSString *bodyData = [NSString stringWithFormat:@"username=%@&place_name=%@&ids=%@", username,selectedAnnotation.productName,friendList];
            NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://forron.com/web_service/share_places.php"]];
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

	}];
	// show the alert
	[self.alert show];
}


-(void) showAlert:(NSString *) strAlert_content{
    
    UIAlertView *alert_string = [[UIAlertView alloc] initWithTitle:@"FORRON"
                                                           message:strAlert_content
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    [alert_string show];
}

-(IBAction)setProduct:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        [self showAlert:@"You can't use this functionality!"];
        return;
    }
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    [picker setSourceType: UIImagePickerControllerSourceTypeCamera];
    [picker setDelegate: self];    
    [self presentViewController:picker animated: YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
   
     UIImage* pSourceImage;
   
     if (image.imageOrientation == UIImageOrientationLeft || image.imageOrientation == UIImageOrientationRight)
     {
         CGSize mySize;
         mySize = image.size;
         int nTemp = mySize.width;
         mySize.width = mySize.height;
         mySize.height = nTemp;
         pSourceImage = [self imageByScalingToSize:image size:mySize];
     }
     else
     {
         pSourceImage = [[UIImage alloc] initWithCGImage:[image CGImage]];
     }
     CGSize imageSize = pSourceImage.size;
     float rScale = 300 / MAX(imageSize.width, imageSize.height);
     imageSize.width *= rScale;
     imageSize.height *= rScale;
   
     UIImage* pDownScaledImage = [self imageByScalingToSize:pSourceImage size:imageSize];
     selectedImage = pDownScaledImage;
    [selectedImageView setImage:selectedImage];
    [selectedNameFieldView setText:@""];
     [productView setHidden:NO];
     
}

#define radians(a) ((a)*3.141592/180.0f)
-(UIImage*)imageByScalingToSize:(UIImage*) sourceImage size:(CGSize)targetSize
{
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGImageRef imageRef = [sourceImage CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	
	if (bitmapInfo == kCGImageAlphaNone) {
		bitmapInfo =(CGBitmapInfo)kCGImageAlphaNoneSkipLast;
	}
	
	CGContextRef bitmap;
	
	if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
	}
	
	if (sourceImage.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (sourceImage.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [[UIImage alloc] initWithCGImage:ref];
	
	CGImageRelease(ref);
	CGContextRelease(bitmap);
	
	return newImage;
}

-(IBAction)selectCategory:(id)sender
{
    self.productAlert = [MLTableAlert tableAlertWithTitle:@"Choose a label" cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
                  {
                      return 3;
                  }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                  {
                      static NSString *CellIdentifier = @"CellIdentifier";
                      UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                      switch (indexPath.row) {
                          case 0:
                              cell.textLabel.text = @"FOOD & DRINK";
                              break;
                          case 1:
                              cell.textLabel.text = @"RETAIL & SHOPPING";
                              break;
                          case 2:
                              cell.textLabel.text = @"RECREATIONAL";
                              break;
                      }
                      return cell;
                  }];
	
	// Setting custom alert height
	self.productAlert.height = 350;
	self.productAlert.selectionModeFlag = NO;
	// configure actions to perform
	[self.productAlert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        UIButton *button3 = (UIButton*)[productView viewWithTag:25];
        button3.layer.cornerRadius = 10.0;
        
		switch (selectedIndex.row) {
            case 0:
                [categoryView setImage:[UIImage imageNamed:@"red_icon"]];
                selectedCategory = @"food_drinks";
                [button3 setTitle:@"FOOD & DRINK" forState:UIControlStateNormal];
                break;
            case 1:
                [categoryView setImage:[UIImage imageNamed:@"yellow_icon"]];
                selectedCategory = @"retail_shopping";
                [button3 setTitle:@"RETAIL & SHOPPING" forState:UIControlStateNormal];
                break;
            case 2:
                [categoryView setImage:[UIImage imageNamed:@"blue_icon"]];
                selectedCategory = @"recreational";
                [button3 setTitle:@"RECREATIONAL" forState:UIControlStateNormal];
                break;
        }
	} andCompletionBlock:^{
        
	}];
	
	// show the alert
	[self.productAlert show];
}

-(IBAction)saveProduct:(id)sender
{
    if ([selectedNameFieldView.text isEqualToString:@""]) {
        [self showAlert:@"Please lable your find"];
    } else {
        
        requestKind = 3;
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *lat = [NSString stringWithFormat:@"%.14f",location.latitude];
        NSString *lng = [NSString stringWithFormat:@"%.14f",location.longitude];
        
        NSString *urlString =[NSString stringWithFormat:@"http://forron.com/web_service/upload_product.php?username=%@&file_name=%@&Lat=%@&Lng=%@&category=%@",username,selectedNameFieldView.text,lat,lng,selectedCategory];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // Init the URLRequest
        NSURL *apiURL = [NSURL URLWithString:urlString];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:apiURL];
        request.requestMethod = @"POST";
        
        NSData *imageData1 = UIImageJPEGRepresentation(selectedImage, .1);
        
        [request setData:imageData1 withFileName:selectedNameFieldView.text andContentType:@"image/jpeg" forKey:@"file"];
        [request setDelegate:self];
        [request startAsynchronous];

        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [HUD setLabelFont:[UIFont systemFontOfSize:12]];
        [HUD setLabelText:@"Loading..."];
    }
}

- (void)requestFinished:(id)sender
{
    ASIFormDataRequest *request = (ASIFormDataRequest *)sender;
    //NSString * responseString = [request responseString];
    
    int statusCode = [request responseStatusCode];
    [HUD hide:YES];
    if (statusCode == 200) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                            message:@"Saved FORRON"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView  show];
        productView.hidden = YES;
        NSData *reponseData = [request responseData];
        NSString * result = [[NSString alloc] initWithData:reponseData encoding:NSUTF8StringEncoding];
        NSString *jsonString = [result substringFromIndex:[result rangeOfString:@"{"].location];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        [[DataManager getInstance].productNameArray addObject:[dict objectForKey:@"product_name"]];
        [[DataManager getInstance].productCategoryArray addObject:[dict objectForKey:@"product_category"]];
        [[DataManager getInstance].productLatArray addObject:[dict objectForKey:@"product_latitude"]];
        [[DataManager getInstance].productLngArray addObject:[dict objectForKey:@"product_longitude"]];
        [[DataManager getInstance].productUrlArray addObject:[dict objectForKey:@"product_url"]];
        [[DataManager getInstance].productStatusArray addObject:[dict objectForKey:@"product_status"]];
        [[DataManager getInstance].productShardNameArray addObject:@""];
        
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        annotation.type = [dict objectForKey:@"product_category"];
        annotation.productShardName = @"";
        annotation.productName = [dict objectForKey:@"product_name"];
        annotation.shardFlag = [dict objectForKey:@"product_status"];
        annotation.productUrl = [dict objectForKey:@"product_url"];
        annotation.coordinate = location;
        [self.mapView addAnnotation:annotation];
       
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                            message:@"Failed!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView  show];
    }
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    if (locationFlag)
    {
        float spanX = 0.0005;
        float spanY = 0.0005;
        MKCoordinateRegion region;
        region.center.latitude = location.latitude;
        region.center.longitude = location.longitude;
        region.span.latitudeDelta = spanX;
        region.span.longitudeDelta = spanY;
        [self.mapView setRegion:region animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

#pragma mark iAd delegate methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
}

- (void) didLongPressImage:(id)sender {
    
}


@end
