//
//  GMeterXMLDataHandlerMDay.m
//  GMeter
//
//  Created by Hao Guo on 2013-03-17.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import "GMeterXMLDataHandlerMDay.h"
#import "GMeterAppDelegate.h"

@interface GMeterXMLDataHandlerMDay()
@property (nonatomic,strong)NSString *selectedDay;
@end

@implementation GMeterXMLDataHandlerMDay
@synthesize selectedDay = _selectedDay;

BOOL mdayDay = NO;
int mdayFlag = 0;
int mdayData[]={0,0,0,0,0,0};

-(NSString *)selectedDay{
    if (_selectedDay == nil) {
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        _selectedDay = @"day";
        _selectedDay = [_selectedDay stringByAppendingString:delegate.selectedDay];
    }
    return  _selectedDay;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    
    if ([self.selectedDay isEqualToString:elementName] ) {
        
        mdayDay = YES;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (mdayDay == YES && ![string isEqualToString:@"\n"]) {
        mdayData[mdayFlag] += [string intValue];
        mdayFlag++;
        mdayFlag = mdayFlag%6;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName doneFlag:(BOOL*) f{
    if ([self.selectedDay isEqualToString:elementName]) {
        [parser abortParsing];
        NSMutableArray *tempData = [[NSMutableArray alloc]init];
        for (int i=0; i<6; i++) {
            [tempData insertObject:[NSNumber numberWithInt:mdayData[i]] atIndex:i];
            mdayData[i]= 0;
        }
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.statisticsData = [NSArray arrayWithArray:tempData];
        mdayDay = NO;
        mdayFlag = 0;
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
