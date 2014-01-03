//
//  GMeterXMLDataHandlerFactory.m
//  GMeter
//
//  Created by Hao Guo on 2013-03-03.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import "GMeterXMLDataHandlerFactory.h"
#import "GMeterAppDelegate.h"

@implementation GMeterXMLDataHandlerFactory
+(GMeterXMLDataHandler *)getXMLHandlerObject{
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate.selectedMonth isEqualToString:@"Total"]) {
        
    }else{
        if ([delegate.selectedDay isEqualToString:@"Total"]) {
            
            if ([delegate.selectedCat isEqualToString:@"Total"]) {
                return [GMeterXMLDataHandlerMMonth alloc];
            }else{
                return [GMeterXMLDataHandlerSMonth alloc];
            }
            
        }else{
            if ([delegate.selectedHour isEqualToString:@"Total"]) {
                if ([delegate.selectedCat isEqualToString:@"Total"]) {
                    return [GMeterXMLDataHandlerMDay alloc];
                }else{
                    return [GMeterXMLDataHandlerSDay alloc];
                }
                
            }else{
                if ([delegate.selectedCat isEqualToString:@"Total"]) {
                    return [GMeterXMLDataHandlerMHour alloc];
                }else{
                    return [GMeterXMLDataHandlerSHour alloc];
                }
            }
        }
    }
    return nil;
}
@end
