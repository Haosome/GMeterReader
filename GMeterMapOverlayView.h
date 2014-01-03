//
//  GMeterMapOverlayView.h
//  GMeter
//
//  Created by Hao Guo on 2013-03-23.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface GMeterMapOverlayView : MKOverlayView
-(instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;
@end
