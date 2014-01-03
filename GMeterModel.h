//
//  GMeterModel.h
//  GMeter
//
//  Created by Hao Guo on 2012-11-11.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//
@class ZKDataArchive;
#import <Foundation/Foundation.h>

@interface GMeterModel : NSObject
+(NSString* )getFileContent: (NSString *)filename;
+(void)writeToFile:(NSString *)fileName contentToWrite:(NSString *)content;
+(NSArray *)requireList;
+(void)deleteFilesUnderDirectory:(NSString *)directory;
+(NSString *)documentDirectory;
+(void)dataToFile:(NSString *)fileName dataToWrite:(NSData *)data userName: (NSString *)name;
@end
