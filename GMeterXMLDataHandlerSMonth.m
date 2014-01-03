//
//  GMeterXMLDataHandlerSMonth.m
//  GMeter
//
//  Created by Hao Guo on 2013-03-12.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import "GMeterXMLDataHandlerSMonth.h"

@interface GMeterXMLDataHandlerSMonth()
@property (nonatomic,strong)NSString *selectedCat;
@end

@implementation GMeterXMLDataHandlerSMonth

BOOL smonthCat = NO;

int smonthData[31];
int smonthCount = 0;
int smonthFlag = 0;//smonthFlag = smonthCount % 96;


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
    //NSLog(elementName);
    if ([self.selectedCat isEqualToString:elementName]) {
        smonthCat = YES;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (smonthCat == YES && ![string isEqualToString:@"\n"]) {
        smonthData[smonthFlag] += [string intValue];
        smonthCount ++;
        smonthFlag = smonthCount/96;
        smonthCat = NO;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName doneFlag:(BOOL*) f{
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if ([elementName rangeOfString:delegate.selectedMonth].location != NSNotFound) {
        
        NSMutableArray *tempData = [[NSMutableArray alloc]init];
        for (int i=0; i<31; i++) {
            [tempData insertObject:[NSNumber numberWithInt:smonthData[i]] atIndex:i];
            smonthData[i] = 0;
        }
        
        delegate.statisticsData = [NSArray arrayWithArray:tempData];
        smonthFlag = 0;
        smonthCount = 0;
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
