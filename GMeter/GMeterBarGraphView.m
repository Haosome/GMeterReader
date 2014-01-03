//
//  GMeterBarGraphView.m
//  GMeter
//
//  Created by Hao Guo on 2012-11-14.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import "GMeterBarGraphView.h"

@implementation GMeterBarGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawAxis: (CGContextRef)context{
    
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 50, 5);
    CGContextAddLineToPoint(context, 50, 365);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 50, 5);
    CGContextAddLineToPoint(context, 300, 5);
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

-(void)drawBars:(CGContextRef)context{
    
    
    
    UIGraphicsPushContext(context);
    
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *fileName = [delegate.selectedMonth stringByAppendingFormat:@"_%@",delegate.currentUserName];
    NSString *fileContent = [GMeterModel getFileContent:fileName];
    
    NSArray *dailyData = [fileContent componentsSeparatedByString:@"\n"];
    
    for (int i=0; i<dailyData.count-1; i++) {
        NSString *aData;
        double width;
        if (i<=8) {
            aData = [[dailyData objectAtIndex:i] substringFromIndex:9];
        }else{
            aData = [[dailyData objectAtIndex:i] substringFromIndex:10];
        }
        width = [aData doubleValue];
        
        CGRect rect;
        rect.origin.x = 50;
        rect.origin.y = 5+i*12;
        rect.size.height = 9;
        rect.size.width = width*2.5;
        CGContextBeginPath(context);
        CGContextAddRect(context, rect);
        CGContextStrokePath(context);
        
        CGRect labelRect = CGRectMake(30, 5+i*12, 20, 9);
        UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
        label.text = [[NSString alloc]initWithFormat:@"%i",i+1];
        [self addSubview:label];
        
    }
    
    UIGraphicsPopContext();
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawAxis:context];
    [self drawBars:context];
}


@end
