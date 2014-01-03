//
//  GMeterXMLDataHandlerMMonth.m
//  GMeter
//
//  Created by Hao Guo on 2013-03-16.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import "GMeterXMLDataHandlerMMonth.h"

@implementation GMeterXMLDataHandlerMMonth

int mmonthData[] = {0,0,0,0,0,0};
int mmonthFlag = 0;


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //NSLog(elementName);
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (![string isEqualToString:@"\n"]) {
        mmonthData[mmonthFlag] += [string intValue];
        mmonthFlag++;
        mmonthFlag = mmonthFlag%6;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName doneFlag:(BOOL*) f{
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if ([elementName rangeOfString:delegate.selectedMonth].location != NSNotFound) {
        
        NSMutableArray *tempData = [[NSMutableArray alloc]init];
        for (int i=0; i<6; i++) {
            [tempData insertObject:[NSNumber numberWithInt:mmonthData[i]] atIndex:i];
            mmonthData[i] = 0;
        }
        
        delegate.statisticsData = [NSArray arrayWithArray:tempData];
        mmonthFlag = 0;
        *f = YES;
    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx{
    
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText = [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    int sum = 0;
    for (NSNumber *number in delegate.statisticsData) {
        sum += [number intValue];
    }
    
    float percent = (float)[[delegate.statisticsData objectAtIndex:idx] intValue]/sum;
    
    NSString *labelValue = [NSString stringWithFormat:@"%i (%f)", [[delegate.statisticsData objectAtIndex:idx] intValue],percent];
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}
@end