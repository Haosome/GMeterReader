//
//  GMeterXMLDataHandlerMHour.m
//  GMeter
//
//  Created by Hao Guo on 2013-03-03.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import "GMeterXMLDataHandlerSHour.h"
#import "GMeterAppDelegate.h"

@interface GMeterXMLDataHandlerSHour()
@property (nonatomic,strong)NSString *selectedDay;
@property (nonatomic,strong)NSString *selectedHour;
@property (nonatomic,strong)NSString *selectedCat;
@end

@implementation GMeterXMLDataHandlerSHour
@synthesize selectedHour = _selectedHour;
@synthesize selectedDay = _selectedDay;
@synthesize selectedCat = _selectedCat;

BOOL shourDay = NO;
BOOL shourMonth = NO;
BOOL shourHour = NO;
BOOL shourCat = NO;
int shourFlag = 0;
int shourData[]={0,0,0,0,};


-(NSString *)selectedDay{
    if (_selectedDay == nil) {
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        _selectedDay = @"day";
        _selectedDay = [_selectedDay stringByAppendingString:delegate.selectedDay];    }
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
        
        shourDay = YES;
    }
    if (shourDay == YES && [self.selectedHour isEqualToString:elementName]) {
        shourHour = YES;
    }
    
    if (shourDay == YES && shourHour == YES && [self.selectedCat isEqualToString:elementName]) {
        
        shourCat = YES;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (shourCat == YES && ![string isEqualToString:@"\n"]) {
        shourData[shourFlag] = [string intValue];
        shourFlag++;
        shourFlag=shourFlag%4;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName doneFlag:(BOOL*) f{
    shourCat = NO;
    if ([self.selectedHour isEqualToString:elementName] && shourDay == YES) {
        [parser abortParsing];

        NSMutableArray *tempData = [[NSMutableArray alloc]init];
        for (int i=0; i<4; i++) {
            [tempData insertObject:[NSNumber numberWithInt:shourData[i]] atIndex:i];
            shourData[i] = 0;
        }
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.statisticsData = [NSArray arrayWithArray:tempData];
         shourDay = NO;
         shourHour = NO;
         shourCat = NO;
         shourFlag = 0;
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
