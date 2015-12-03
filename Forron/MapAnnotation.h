//
//  JFMapAnnotation.h
//  JFMapViewExample
//
//  Created by Jonathan Field on 15/09/2013.
//  Copyright (c) 2013 Jonathan Field. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * productShardName;
@property (nonatomic, retain) NSString * productUrl;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * shardFlag;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end
