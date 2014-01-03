//
//  GMeterXMLDataHandlerFactory.h
//  GMeter
//
//  Created by Hao Guo on 2013-03-03.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMeterXMLDataHandler.h"
#import "GMeterXMLDataHandlerMHour.h"
#import "GMeterXMLDataHandlerSHour.h"
#import "GMeterXMLDataHandlerSMonth.h"
#import "GMeterXMLDataHandlerMMonth.h"
#import "GMeterXMLDataHandlerSDay.h"
#import "GMeterXMLDataHandlerMDay.h"
@interface GMeterXMLDataHandlerFactory : NSObject
+(GMeterXMLDataHandler *)getXMLHandlerObject;
@end
