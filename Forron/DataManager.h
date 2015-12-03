//
//  DataManager.h
//  QrcodeSms
//
//  Created by ZongDa on 3/6/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property(nonatomic,retain) NSMutableArray *productNameArray;
@property(nonatomic,retain) NSMutableArray *productCategoryArray;
@property(nonatomic,retain) NSMutableArray *productLatArray;
@property(nonatomic,retain) NSMutableArray *productLngArray;
@property(nonatomic,retain) NSMutableArray *productShardNameArray;
@property(nonatomic,retain) NSMutableArray *productUrlArray;
@property(nonatomic,retain) NSMutableArray *productStatusArray;

+ (DataManager*)getInstance;
//-(void)getEventsAndImageData;

@end
