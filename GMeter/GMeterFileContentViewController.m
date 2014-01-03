//
//  GMeterFileContentViewController.m
//  GMeter
//
//  Created by Hao Guo on 2012-11-14.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import "GMeterFileContentViewController.h"

@interface GMeterFileContentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *fileContent;

@end

@implementation GMeterFileContentViewController
@synthesize fileContent = _fileContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _fileContent.editable = NO;
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *fileName = [delegate.selectedMonth stringByAppendingFormat:@"_%@",delegate.currentUserName];
    NSString *fileContent = [GMeterModel getFileContent:fileName];
    _fileContent.text = fileContent;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
