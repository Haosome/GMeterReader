//
//  GMeterUserDetailViewController.h
//  GMeter
//
//  Created by Hao Guo on 2012-11-11.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMeterFileListViewController.h"
#import "GMeterBarGraphViewController.h"
#import "GMeterAppDelegate.h"
@interface GMeterUserDetailViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,NSXMLParserDelegate>
@end