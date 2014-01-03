//
//  GMeterMapViewController.h
//  GMeter
//
//  Created by Hao Guo on 2012-11-07.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GameKit/GameKit.h>
#import "GMeterAppDelegate.h"
#import "GMeterAnnotation.h"
#import "GMeterUserDetailViewController.h"
#import "GMeterMapOverlay.h"
#import "GMeterMapOverlayView.h"

@interface GMeterMapViewController : UIViewController<GKSessionDelegate>

@property (strong,nonatomic) NSArray *annotations;
@property (strong,nonatomic) NSString *fileName;
@property (nonatomic,retain)GKSession *currentSession;
@end
