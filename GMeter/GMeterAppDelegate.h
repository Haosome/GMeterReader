//
//  GMeterAppDelegate.h
//  GMeter
//
//  Created by Hao Guo on 2012-11-07.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
@interface GMeterAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GKSession *currentSession;
@property (nonatomic) int step;
@property (nonatomic,strong) NSString *command;
@property (nonatomic)int fileNumberCount;
@property (nonatomic,strong)NSArray *requiredList;
@property (nonatomic,strong)NSString *currentUserName;
@property (nonatomic,strong)NSString *selectedMonth;
@property (nonatomic,strong)NSString *selectedDay;
@property (nonatomic,strong)NSString *selectedHour;
@property (nonatomic,strong)NSString *selectedCat;
@property (nonatomic,strong)NSArray *serverList;
@property (nonatomic,strong)NSArray *annotations;
@property (nonatomic,strong)NSArray *statisticsData;
@property (nonatomic,strong)NSString *fileContent;
@end
