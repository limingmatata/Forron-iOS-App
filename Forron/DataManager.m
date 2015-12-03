//
//  DataManager.m
//  QrcodeSms
//
//  Created by ZongDa on 3/6/14.
//  Copyright (c) 2014 ZongDa. All rights reserved.
//

#import "DataManager.h"
static DataManager *sharedInstance = nil;


@implementation DataManager


@synthesize productNameArray ;
@synthesize productCategoryArray ;
@synthesize productLatArray ;
@synthesize productLngArray ;
@synthesize productShardNameArray;
@synthesize productStatusArray;
@synthesize productUrlArray;

+(DataManager*)getInstance{
    if (sharedInstance == nil)
	{
		sharedInstance = [[DataManager alloc] init];
	}
	return sharedInstance;
}
-(id)init
{
    if((self = [super init]))
	{
        self.productNameArray = [[NSMutableArray alloc] init];
        
        self.productCategoryArray = [[NSMutableArray alloc] init];
        self.productLatArray = [[NSMutableArray alloc] init];
        self.productLngArray = [[NSMutableArray alloc] init];
        self.productShardNameArray = [[NSMutableArray alloc] init];
        self.productStatusArray = [[NSMutableArray alloc] init];
        self.productUrlArray = [[NSMutableArray alloc] init];
        
    }
	return self;
}

@end
