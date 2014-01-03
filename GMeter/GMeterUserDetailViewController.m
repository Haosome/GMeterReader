//
//  GMeterUserDetailViewController.m
//  GMeter
//
//  Created by Hao Guo on 2012-11-11.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import "GMeterUserDetailViewController.h"

@interface GMeterUserDetailViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;
@property (nonatomic)  int currentMonth;
@property (nonatomic, strong)  NSArray *monthArray;
@property (nonatomic,strong) NSArray *dayArray;
@property (nonatomic,strong) NSArray *catArray;
@property (nonatomic,strong) NSArray *hourArray;
@property (nonatomic,strong) GMeterXMLDataHandler *handler;
@end

@implementation GMeterUserDetailViewController
@synthesize myPicker = _myPicker;
@synthesize monthArray = _monthArray;
@synthesize dayArray = _dayArray;
@synthesize hourArray = _hourArray;
@synthesize handler = _handler;

BOOL parsingDone;

-(void)UpdateDayArray{
    
    if (self.currentMonth == 4 || self.currentMonth == 6 || self.currentMonth == 9  || self.currentMonth == 11) {
        self.dayArray = [NSArray arrayWithObjects:@"Total",@"1",@"3",@"2",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
    }else if(_currentMonth == 2){
        self.dayArray = [NSArray arrayWithObjects:@"Total",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29", nil];
    }else{
        self.dayArray = [NSArray arrayWithObjects:@"Total", @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
    }
    [self.myPicker reloadComponent:1];
}

-(void)setCurrentMonth:(int)currentMonth{

    _currentMonth = currentMonth;
    [self UpdateDayArray];
}

-(UIPickerView *)myPicker{
    
    if (_myPicker == nil) {
        _myPicker = [[UIPickerView alloc] init];
        _myPicker.delegate = self;
        _myPicker.dataSource = self;
    }
    return _myPicker;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (component == 0) {
        return 80;
    }else if(component == 1)  return 80;
    else if(component == 2) return 80;
    else return 140;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (component == 0) {
        return 12;
    }else if(component == 1){
        return self.dayArray.count;
    }else if(component == 2){
        return 25;
    }else return 7;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    if (component == 0) {
        return [self.monthArray objectAtIndex:row];
    }else if(component == 1){
        return [self.dayArray objectAtIndex:row];
    }else if(component == 2){
        return [self.hourArray objectAtIndex:row];
    }else{
        return [self.catArray objectAtIndex:row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    

    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (component == 0) {
        self.currentMonth = row+1;
        delegate.selectedMonth = [self.monthArray objectAtIndex:row];
    }else if (component == 1){
        delegate.selectedDay = [self.dayArray objectAtIndex:row];
    }else if(component == 2){
        delegate.selectedHour = [self.hourArray objectAtIndex:row];
    }else
        delegate.selectedCat = [self.catArray objectAtIndex:row];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    parsingDone = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentMonth = 1;
    self.monthArray = [NSArray arrayWithObjects: @"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    self.catArray = [NSArray arrayWithObjects:@"Total",@"Lighting",@"Laundary",@"Charging",@"Heating",@"Stove",@"E&O", nil];
    self.hourArray = [NSArray arrayWithObjects:@"Total",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24", nil];
    

    
    self.myPicker.delegate = self;
    self.myPicker.dataSource = self;
    
    
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.selectedMonth = [self.monthArray objectAtIndex:0];
    delegate.selectedDay = [self.dayArray objectAtIndex:0];
    delegate.selectedHour = [self.hourArray objectAtIndex:0];
    delegate.selectedCat = [self.catArray objectAtIndex:0];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - XML parser behavior

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    [self.handler parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.handler parser:parser foundCharacters:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    [self.handler parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName doneFlag:&parsingDone];
    if (parsingDone == YES) {
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate.selectedCat isEqualToString:@"Total"]) {
            [self performSegueWithIdentifier:@"pieChart" sender:nil];
        }else{
            [self performSegueWithIdentifier:@"scatterPlot" sender:nil];
        }
    }
}


- (IBAction)viewData:(id)sender {
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    _handler = [GMeterXMLDataHandlerFactory getXMLHandlerObject];
    
    NSString *filePath = [GMeterModel documentDirectory];
    filePath = [filePath stringByAppendingPathComponent:delegate.currentUserName];
    filePath = [filePath stringByAppendingPathComponent:@"data"];
    filePath = [filePath stringByAppendingPathComponent:delegate.selectedMonth];
    filePath = [filePath stringByAppendingPathExtension:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:filePath];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    parser.delegate = self;
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser parse];
    


}

@end
