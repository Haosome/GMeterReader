//
//  GMeterScatterPlotViewController.h
//  GMeter
//
//  Created by Hao Guo on 2013-03-05.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMeterAppDelegate.h"
#import "GMeterModel.h"
#import "GMeterXMLDataHandlerFactory.h"
#import "CorePlot-CocoaTouch.h"
@interface GMeterScatterPlotViewController : UIViewController<CPTPlotDataSource, CPTPieChartDataSource>

@end
