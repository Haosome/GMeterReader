//
//  GMeterXMLDataHandler.h
//  GMeter
//
//  Created by Hao Guo on 2013-03-03.
//  Copyright (c) 2013 Hao Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "GMeterAppDelegate.h"
#import "GMeterPlotInit.h"
@interface GMeterXMLDataHandler : NSObject

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName doneFlag:(BOOL *) f;

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx;
@end
