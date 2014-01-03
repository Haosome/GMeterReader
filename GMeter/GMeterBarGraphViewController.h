//
//  GMeterBarGraphViewController.h
//  GMeter
//
//  Created by Hao Guo on 2012-11-12.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMeterAppDelegate.h"
#import "GMeterModel.h"
#import "GMeterXMLDataHandlerFactory.h"
#import "GMeterPlotInit.h"
#import "CorePlot-CocoaTouch.h"
@interface GMeterBarGraphViewController : UIViewController<CPTPlotDataSource, CPTPieChartDataSource>
@end
