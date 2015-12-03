//
//  HomeViewController.h
//  Forron
//
//  Created by ZongDa Liang on 8/8/14.
//  Copyright (c) 2014 www.liang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>
#import "MBProgressHUD.h"
#import "MapAnnotation.h"

@class MLTableAlert;
@interface HomeViewController : UIViewController<MBProgressHUDDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, ADBannerViewDelegate>
{
    
    NSMutableArray * aryCategoryImage;
    NSMutableArray * aryCategoryName;
    NSMutableArray * friendArray;
    
    CLLocationCoordinate2D location;
    CLLocationCoordinate2D lastProductLocation;
    CLLocationCoordinate2D selectedProductLocation;
    
    MapAnnotation *selectedAnnotation;

    UIImage *selectedImage;
    NSString *selectedCategory;
    IBOutlet UIImageView *selectedImageView;
    IBOutlet UITextField *selectedNameFieldView;
    
    int requestKind;
    IBOutlet UIView *settingView;
    IBOutlet UIView *productView;
    IBOutlet UIImageView *categoryView;
    
    NSString *friendList;
    
}

@property (nonatomic, retain) MLTableAlert *alert;
@property (nonatomic, retain) MLTableAlert *productAlert;
@property (nonatomic, retain) MBProgressHUD *HUD;

@property (nonatomic, assign) BOOL locationFlag;
@property (nonatomic, retain) IBOutlet MKMapView * mapView;
@property (nonatomic, retain) CLLocationManager * locationManager;

-(IBAction)showMenu:(id)sender;
-(IBAction)showFood:(id)sender;
-(IBAction)showRetail:(id)sender;
-(IBAction)showRecreational:(id)sender;
-(IBAction)showShard:(id)sender;

-(IBAction)setHidden:(id)sender;
-(IBAction)removeFromMap:(id)sender;
-(IBAction)sendToFriend:(id)sender;

-(IBAction)setProduct:(id)sender;
-(IBAction)setHiddenProductView:(id)sender;
-(IBAction)selectCategory:(id)sender;
-(IBAction)saveProduct:(id)sender;

@end
