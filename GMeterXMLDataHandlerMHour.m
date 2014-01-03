//
//  GMeterXMLDataHandlerMHour.m
//  GMeter
//
//  Created by Hao Guo on 2013-03-03.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import "GMeterXMLDataHandlerMHour.h"
#import "GMeterAppDelegate.h"

@interface GMeterXMLDataHandlerMHour()
@property (nonatomic,strong)NSString *selectedDay;
@property (nonatomic,strong)NSString *selectedHour;
@end

@implementation GMeterXMLDataHandlerMHour
@synthesize selectedHour = _selectedHour;
@synthesize selectedDay = _selectedDay;

BOOL day = NO;
BOOL hour = NO;
int flag = 0;
int data[]={0,0,0,0,0,0};

-(NSString *)selectedDay{
    if (_selectedDay == nil) {
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        _selectedDay = @"day";
        _selectedDay = [_selectedDay stringByAppendingString:delegate.selectedDay];
    }
    return  _selectedDay;
}

-(NSString *)selectedHour{
    if (_selectedHour == nil) {
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
       _selectedHour = @"hour";
        _selectedHour = [_selectedHour stringByAppendingString:delegate.selectedHour];
    }
    return _selectedHour;
}




-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{


    if ([self.selectedDay isEqualToString:elementName] ) {
        
        day = YES;
    }
    if (day == YES && [self.selectedHour isEqualToString:elementName]) {
        hour = YES;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (day == YES && hour == YES && ![string isEqualToString:@"\n"]) {
    data[flag] += [string intValue];
    flag++;
    flag = flag%6;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName doneFlag:(BOOL*) f{
    if ([self.selectedHour isEqualToString:elementName] && day == YES) {
        [parser abortParsing];
        NSMutableArray *tempData = [[NSMutableArray alloc]init];
        for (int i=0; i<6; i++) {
            [tempData insertObject:[NSNumber numberWithInt:data[i]] atIndex:i];
            data[i]= 0;
        }
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.statisticsData = [NSArray arrayWithArray:tempData];
         day = NO;
         hour = NO;
         flag = 0;
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
