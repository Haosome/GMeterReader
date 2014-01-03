//
//  GMeterModel.m
//  GMeter
//
//  Created by Hao Guo on 2012-11-11.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import "GMeterModel.h"
@implementation GMeterModel
+(NSString* )getFileContent: (NSString *)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentDirectory,fileName];
    return [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

+(void)writeToFile:(NSString *)fileName contentToWrite:(NSString *)content{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentDirectory,fileName];
    [content  writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

+(NSString *)documentDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return documentDirectory;
}

+(NSArray *)requireList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirectory error:nil];
}

+(void)deleteFilesUnderDirectory:(NSString *)directory{
    [[NSFileManager defaultManager] removeItemAtPath:directory error:nil];
}

+(void)dataToFile:(NSString *)fileName dataToWrite:(NSData *)data userName:(NSString *)name{
    NSString *filePath = [self documentDirectory];
    filePath = [filePath stringByAppendingPathComponent:name];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    NSError *e;
    BOOL s = [data writeToFile:filePath options:nil error:&e];
    NSLog(e);
    NSLog(@"Write file succeed? %i",s);
}

@end
