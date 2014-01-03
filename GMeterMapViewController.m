//
//  GMeterMapViewController.m
//  GMeter
//
//  Created by Hao Guo on 2012-11-07.
//  Copyright (c) 2012 Hao Guo. All rights reserved.
//

#import "GMeterMapViewController.h"
#import "GMeterModel.h"
#import "/Users/haoguo/Desktop/GMeter/kolpanic-zipkit-531cd75fef32/ZKFileArchive.h"
#define REQUIRELIST @"11111101"
#define DOWNLOADFILES @"11111100"

@interface GMeterMapViewController ()<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (atomic) int step;
@property (nonatomic,strong) NSString *fn;
@property (nonatomic,strong) NSArray *targetPeer;
@property (nonatomic,strong) NSString *targetPeerName;
@property (nonatomic,strong) NSArray *requestedListForServer;
@property (nonatomic,strong) NSMutableArray *userList;
@property int ifMapHasBeenLoaded;
@end

@implementation GMeterMapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize step=_step;//0 receive command, 1 receive list
@synthesize fn = _fn;//file name for receiving
@synthesize requestedListForServer = _requestedListForServer;
@synthesize fileName = _fileName;//file name for sending
@synthesize currentSession = _currentSession;
@synthesize targetPeer = _targetPeer;
@synthesize targetPeerName = _targetPeerName;
@synthesize userList = _userList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *)userList{
    if (_userList == nil) {
        NSString *path = [[GMeterModel documentDirectory] stringByAppendingPathComponent:@"Userlist"];
        _userList = [[NSMutableArray alloc]initWithContentsOfFile:path];
        if (_userList == nil) {
            _userList = [[NSMutableArray alloc] init];
        }
    }
    return _userList;
}

-(void) updateMapView{
    if(_mapView.annotations) [self.mapView removeAnnotations:_mapView.annotations];
    if (self.annotations) {
        [_mapView addAnnotations:self.annotations];
    }
}

-(void)setAnnotations:(NSArray *)annotations{
    _annotations = annotations;
    [self updateMapView];
}

-(void)setMapView:(MKMapView *)mapView{
    _mapView = mapView;
    [self updateMapView];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    CLLocationCoordinate2D coordinate = self.mapView.region.center;
    MKMapRect theMapRect;
    
    theMapRect.origin = MKMapPointForCoordinate(coordinate);
    
    theMapRect.size.width = 10000;
    theMapRect.size.height = 10000;
    theMapRect.origin.x -= 5000;
    theMapRect.origin.y -= 5000;
    
    GMeterMapOverlay *overlay = [[GMeterMapOverlay alloc] initWithMapRect:theMapRect  Coordinate: coordinate];
    [self.mapView addOverlay:overlay];
    
    GMeterAnnotation  *annotation = [self.annotations lastObject];
    [annotation setCoordinate:coordinate];
    
    [self updateMapView];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{    

}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
    if (self.ifMapHasBeenLoaded == 0) {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.03;
    span.longitudeDelta=0.03;
    
    CLLocationCoordinate2D location=_mapView.userLocation.coordinate;
    region.span=span;
    region.center=location;
    
    [_mapView setRegion:region animated:FALSE];
    [_mapView regionThatFits:region];
        
        self.ifMapHasBeenLoaded = 1;
    }
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass: GMeterMapOverlay.class]) {
        UIImage *overlayImage = [UIImage imageNamed:@"overlay"];
        GMeterMapOverlayView *overlayView = [[GMeterMapOverlayView alloc] initWithOverlay:overlay overlayImage:overlayImage];
        return overlayView;
    }
    return nil;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(GMeterAnnotation *)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation.title isEqualToString:@"CurrentLocation"]) {
        
        UIImage *image = [UIImage imageNamed:@"car"];
        
        MKAnnotationView *aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"car" ];
        aView.image = image;
        return  aView;
    }
    
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
                 aView.canShowCallout = YES;
    }
    aView.annotation = annotation;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    aView.rightCalloutAccessoryView = btn;
    
    if ([[NSDate date] timeIntervalSinceDate:annotation.lastUpdate] <= 2592000) {
        aView.pinColor = MKPinAnnotationColorGreen;
    }
    
    
    aView.draggable = YES;
    
    return aView;
}

- (IBAction)locateTouched {
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.03;
    span.longitudeDelta=0.03;
    
    CLLocationCoordinate2D location=_mapView.userLocation.coordinate;
    region.span=span;
    region.center=location;
    
    [_mapView setRegion:region animated:YES];
    [_mapView regionThatFits:region];
    
    [self.mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.currentUserName = [view.annotation title];
    [self performSegueWithIdentifier:@"userDetail" sender:nil];
    
    
//    NSData* data;
//    NSString *command = REQUIRELIST;
//    data = [command dataUsingEncoding:NSUTF8StringEncoding];
//    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    delegate.command = command;
//    
//    NSArray *availablePeers = [_currentSession peersWithConnectionState:GKPeerStateConnected];
//    NSString *peerID;
//    for (int i =0; i<availablePeers.count; i++) {
//        peerID = [availablePeers objectAtIndex:i];
//        if ([[_currentSession displayNameForPeer:peerID] isEqualToString:[view.annotation title]]) {
//            
//            _targetPeer = [NSArray arrayWithObject:peerID];
//            _targetPeerName = [view.annotation title];
//            delegate.currentUserName = _targetPeerName;
//            break;
//        }
//    }
//
//    if (self.currentSession) {
//        [_currentSession sendData:data toPeers:_targetPeer withDataMode:GKSendDataReliable error:nil];
//    }
    
    
}

-(void)downLoadRequestedFiles{
    NSData* data;
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.command = DOWNLOADFILES;
    data = [DOWNLOADFILES dataUsingEncoding:NSUTF8StringEncoding];
    if (self.currentSession) {
        [_currentSession sendData:data toPeers:_targetPeer withDataMode:GKSendDataReliable error:nil];
    }
    NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:delegate.requiredList];
    delegate.fileNumberCount = delegate.requiredList.count - 1;
    if (self.currentSession) {
        [_currentSession sendData:listData toPeers:_targetPeer withDataMode:GKSendDataReliable error:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    self.ifMapHasBeenLoaded = 0;
    
    
    NSDictionary *a = [NSDictionary dictionaryWithObjectsAndKeys:@"Xiaoyu_Cheng_02",USER_ID,@"47.57",USER_LATITUDE,@"-52.73",USER_LONGITUDE, nil];
    
    NSDictionary *b = [NSDictionary dictionaryWithObjectsAndKeys:@"test1",USER_ID,@"47.571",USER_LATITUDE,@"-52.731",USER_LONGITUDE, nil];
    NSDictionary *c = [NSDictionary dictionaryWithObjectsAndKeys:@"test2",USER_ID,@"47.52",USER_LATITUDE,@"-52.72",USER_LONGITUDE, nil];
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@"test3",USER_ID,@"47.55",USER_LATITUDE,@"-52.71",USER_LONGITUDE, nil];
    NSDictionary *e = [NSDictionary dictionaryWithObjectsAndKeys:@"test4",USER_ID,@"47.57",USER_LATITUDE,@"-52.70",USER_LONGITUDE, nil];
    NSDictionary *f = [NSDictionary dictionaryWithObjectsAndKeys:@"CurrentLocation",USER_ID,@"47.571",USER_LATITUDE,@"-52.731",USER_LONGITUDE, nil];
    
    
    NSArray *annotation = [NSArray arrayWithObjects:[GMeterAnnotation annotationForUser:a], [GMeterAnnotation annotationForUser:b],[GMeterAnnotation annotationForUser:c],[GMeterAnnotation annotationForUser:d],[GMeterAnnotation annotationForUser:e],[GMeterAnnotation annotationForUser:f],nil];
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.annotations) {
        [self setAnnotations:delegate.annotations];
    }else [self setAnnotations:annotation];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)session:(GKSession *)session
           peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:{
            [session setDataReceiveHandler:self withContext:nil];
            
            NSString *name = [_currentSession displayNameForPeer:peerID];
            if (![_userList containsObject:name]) {
                [self.userList addObject:name];
            }
            
            GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            delegate.requiredList = [[NSArray alloc] initWithObjects:@"data.zip", nil];
            _targetPeer = [NSArray arrayWithObject:peerID];
            [self downLoadRequestedFiles];
            break;
        }
        case GKPeerStateDisconnected:
            break;
        case GKPeerStateAvailable:{
            BOOL connect = NO;
            
            for (GMeterAnnotation *annotation in self.annotations) {
                if ([annotation.title isEqualToString:[self.currentSession displayNameForPeer:peerID]]) {
                    
                    GMeterAnnotation *a = [self.annotations lastObject];
                    
                    CLLocationCoordinate2D coordinate = a.coordinate;
                    if (fabs(coordinate.latitude-annotation.coordinate.latitude) <=0.0052 && fabs(coordinate.longitude-annotation.coordinate.longitude)<=0.0052) {
                        connect = YES;
                    }
                    break;
                }
            }
            NSLog(@"%d",connect);
            if (connect == YES) {
                [self.currentSession  connectToPeer:peerID withTimeout:10000];
                connect = NO;
            }
            break;
        }
    }
}

-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer
         inSession:(GKSession *)session
           context:(void *)context{//client
    
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *name = [_currentSession displayNameForPeer:peer];
    if([delegate.command isEqualToString:REQUIRELIST]){
        
        delegate.serverList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self performSegueWithIdentifier:@"userDetail" sender:nil];
    }else if ([delegate.command isEqualToString:DOWNLOADFILES] && delegate.fileNumberCount >=0){
        //NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *currentFileName = [delegate.requiredList objectAtIndex:delegate.fileNumberCount];
        currentFileName = [[currentFileName componentsSeparatedByString:@"."] objectAtIndex:0];
        currentFileName = [currentFileName stringByAppendingFormat:@"_%@.zip",name];
        //[GMeterModel writeToFile:currentFileName contentToWrite:content];
        NSString *path = [GMeterModel documentDirectory];
        path = [path stringByAppendingPathComponent:name];
        BOOL s = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        path = [path stringByAppendingPathComponent:@"data"];
        //[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        [GMeterModel dataToFile:currentFileName dataToWrite:data userName:name];
        
        delegate.fileNumberCount -- ;
        
        if(delegate.fileNumberCount == -1){
            delegate.requiredList = nil;
            
            NSArray *tempArray = self.annotations;
            
            for (GMeterAnnotation *annotation in tempArray) {
                if ([annotation.title isEqualToString:name]) {
                    annotation.lastUpdate = [[NSDate alloc] init];
                    break;
                }
            }
            self.annotations = tempArray;
            
            NSString *zipFilePath = [GMeterModel documentDirectory ];
            zipFilePath = [zipFilePath stringByAppendingPathComponent:name];
            zipFilePath = [zipFilePath stringByAppendingPathComponent:currentFileName];
            ZKFileArchive *archive =  [ZKFileArchive archiveWithArchivePath:zipFilePath];


           [archive inflateToDiskUsingResourceFork:NO];
        }
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    [self.currentSession    acceptConnectionFromPeer:peerID error:nil];
}




-(void)viewDidAppear:(BOOL)animated{
        GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.requiredList != nil) {
        [self downLoadRequestedFiles];
    }

}

- (void)viewWillAppear:(BOOL)animated{
    
    NSString *path = [[GMeterModel documentDirectory] stringByAppendingFormat:@"/%@",@"Userlist"];
    
    if ([[NSMutableArray alloc] initWithContentsOfFile:path] != nil) {
        _userList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    
    
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _step = delegate.step;
   
    _currentSession = delegate.currentSession;
    if (_currentSession == nil) {
        NSString *sessionIDString = @"Client";
        //create GKSession object
        GKSession *session = [[GKSession alloc] initWithSessionID:sessionIDString displayName:nil sessionMode:GKSessionModePeer];
        self.currentSession = session;
        self.currentSession.delegate = self;
        self.currentSession.available = YES;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSString *path = [[GMeterModel documentDirectory] stringByAppendingPathComponent:@"Userlist"];
    BOOL s = [_userList writeToFile:path atomically:YES];
    
    
    GMeterAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.currentSession = _currentSession;
    delegate.step = _step;
    delegate.annotations = self.annotations;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString: @"userDetail"]){
        
    }

}

@end
