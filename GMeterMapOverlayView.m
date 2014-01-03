//
//  GMeterMapOverlayView.m
//  GMeter
//
//  Created by Hao Guo on 2013-03-23.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import "GMeterMapOverlayView.h"

@interface GMeterMapOverlayView()

@property (nonatomic, strong) UIImage *overlayImage;

@end

@implementation GMeterMapOverlayView
@synthesize overlayImage = _overlayImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage{
    
    self = [super initWithOverlay:overlay];
    if (self) {
        _overlayImage = overlayImage;
    }

    return self;
}

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context{
    
    CGImageRef imageReference = self.overlayImage.CGImage;
    
    MKMapRect theMapRect = self.overlay.boundingMapRect;
    
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(context, 1.0, 1.0);
    //CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
