//
//  GMeterXMLDataHandlerSDay.m
//  GMeter
//
//  Created by Hao Guo on 2013-03-16.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import "GMeterXMLDataHandlerSDay.h"
#import "GMeterAppDelegate.h"

@interface GMeterXMLDataHandlerSDay()
@property (nonatomic,strong)NSString *selectedDay;
@property (nonatomic,strong)NSString *selectedCat;
@end

@implementation GMeterXMLDataHandlerSDay
@synthesize selectedDay = _selectedDay;
@synthesize selectedCat = _selectedCat;

BOOL sdayDay = NO;
BOOL sdayMonth = NO;
BOOL sdayCat = NO;
int sdayFlag = 0;
int sdayData[24];


-(NSString *)selectedDay{
    if (_selectedDay == nil) {
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        _selectedDay = @"day";
        _selectedDay = [_selectedDay stringByAppendingString:delegate.selectedDay];    }
    return  _selectedDay;
}

-(NSString *)selectedCat{
    if (_selectedCat == nil) {
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        _selectedCat = delegate.selectedCat;
        if ([_selectedCat isEqualToString: @"E&O"]) {
            _selectedCat = @"of";
        }
        _selectedCat = [_selectedCat lowercaseString];
    }
    return _selectedCat;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([self.selectedDay isEqualToString:elementName] ) {
        
        sdayDay = YES;
    }
    
    if (sdayDay == YES && [self.selectedCat isEqualToString:elementName]) {
        
        sdayCat = YES;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (sdayCat == YES && ![string isEqualToString:@"\n"]) {
        sdayData[sdayFlag/4] = [string intValue];
        sdayFlag++;
        sdayCat = NO;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName doneFlag:(BOOL*) f{
    
    if ([self.selectedDay isEqualToString:elementName]) {
        [parser abortParsing];
        
        NSMutableArray *tempData = [[NSMutableArray alloc]init];
        for (int i=0; i<24; i++) {
            [tempData insertObject:[NSNumber numberWithInt:sdayData[i]] atIndex:i];
            sdayData[i] = 0;
        }
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.statisticsData = [NSArray arrayWithArray:tempData];
        sdayDay = NO;
        sdayCat = NO;
        sdayFlag = 0;
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
