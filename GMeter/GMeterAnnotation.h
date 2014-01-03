//
//  GMeterAnnotation.h
//  GMeter
//
//  Created by Hao Guo on 2012-11-08.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#define USER_ID @"userID"
#define USER_LATITUDE @"userLattitude"
#define USER_LONGITUDE @"userLongitude"

@interface GMeterAnnotation : NSObject <MKAnnotation>
+(GMeterAnnotation *)annotationForUser:(NSDictionary *)userInfo;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic) CLLocationCoordinate2D coordinate;
-(NSString *)title;
-(NSString *)subtitle;
@end
