//
//  GMeterMapOverlay.m
//  GMeter
//
//  Created by Hao Guo on 2013-03-23.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import "GMeterMapOverlay.h"


@implementation GMeterMapOverlay

@synthesize coordinate = _coordinate;
@synthesize boundingMapRect = _boundingMapRect;
-(instancetype)initWithMapRect:(MKMapRect)mapRect Coordinate:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    if (self) {
        _boundingMapRect = mapRect;
        _coordinate = coordinate;
    }
    return self;
}

@end
