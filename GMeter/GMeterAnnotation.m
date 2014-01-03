//
//  GMeterAnnotation.m
//  GMeter
//
//  Created by Hao Guo on 2012-11-08.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import "GMeterAnnotation.h"

@implementation GMeterAnnotation
@synthesize userInfo = _userInfo;
@synthesize lastUpdate = _lastUpdate;
@synthesize coordinate = _coordinate;
+(GMeterAnnotation *)annotationForUser:(NSDictionary *)userInfo{
    GMeterAnnotation *annotation = [[GMeterAnnotation alloc] init];
    annotation.userInfo = userInfo;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[userInfo objectForKey:USER_LATITUDE] doubleValue];
    coordinate.longitude = [[userInfo objectForKey:USER_LONGITUDE] doubleValue];
    annotation.coordinate = coordinate;
    return annotation;
}

-(NSString *)title{

    return [_userInfo valueForKey:USER_ID];
}

-(NSString *)subtitle{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *string = [dateFormatter stringFromDate:self.lastUpdate];
    return string;
}

-(NSDate *)lastUpdate{
    
    if (_lastUpdate == nil) {
        _lastUpdate = [[NSDate alloc]initWithTimeIntervalSince1970:10];
    }
    return _lastUpdate;
}



-(CLLocationCoordinate2D)coordinate{

    return _coordinate;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    _coordinate = newCoordinate;
}

@end
