//
//  GMeterMapOverlay.h
//  GMeter
//
//  Created by Hao Guo on 2013-03-23.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface GMeterMapOverlay : NSObject<MKOverlay>
-(instancetype)initWithMapRect:(MKMapRect)mapRect Coordinate:(CLLocationCoordinate2D)coordinate;
@end
