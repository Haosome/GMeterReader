//
//  GMeterBarGraphViewController.m
//  GMeter
//
//  Created by Hao Guo on 2012-11-12.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import "GMeterBarGraphViewController.h"

@interface GMeterBarGraphViewController ()
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic,strong) GMeterXMLDataHandler *handler;
@property (nonatomic,strong) NSArray *legendArray;
@end

@implementation GMeterBarGraphViewController
@synthesize hostView = hostView_;
@synthesize legendArray = _legendArray;

#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // The plot is initialized here, since the view bounds have not transformed for landscape until now
    
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    [self initPlot];
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
    // 1 - Set up view frame
    CGRect parentRect = self.view.bounds;
    parentRect = CGRectMake(parentRect.origin.x,
                            (parentRect.origin.y ),
                            parentRect.size.width,
                            (parentRect.size.height));
    // 2 - Create host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    // 1 - Create and initialize graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    // 3 - Configure title
    NSString *title = @"Power Usages:";
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    title = [title stringByAppendingFormat:@"%@:00,%@ %@",delegate.selectedHour,delegate.selectedMonth,delegate.selectedDay];
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    // 4 - Set theme
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
}

-(void)configureChart {
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostView.bounds.size.height * 0.7) / 2;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    pieChart.centerAnchor = CGPointMake(0.6, 0.45);
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    // 4 - Add chart to graph    
    [graph addPlot:pieChart];
}

-(void)configureLegend {
    CPTGraph * graph = self.hostView.hostedGraph;
    CPTLegend *legend = [CPTLegend legendWithGraph:graph];
    
    legend.numberOfColumns = 1;
    legend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    legend.borderLineStyle = [CPTLineStyle lineStyle];
    legend.cornerRadius = 5.0;
    
    graph.legend = legend;
    graph.legendAnchor = CPTRectAnchorLeft;
    CGFloat legendPdding = (self.view.bounds.size.width / 64);
    graph.legendDisplacement = CGPointMake(legendPdding, 0.0);
}

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
	// Do any additional setup after loading the view.
    
    self.legendArray = [NSArray arrayWithObjects:@"Lighting",@"Laundary",@"Charging",@"Heating",@"Stove",@"E&O", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return delegate.statisticsData.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return [delegate.statisticsData objectAtIndex:index];
}


-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx{
    return [self.handler dataLabelForPlot:plot recordIndex:idx];
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx{
    return [self.legendArray objectAtIndex:idx];
}

@end
