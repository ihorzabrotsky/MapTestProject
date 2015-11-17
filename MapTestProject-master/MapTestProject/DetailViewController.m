//
//  DetailViewController.m
//  MapTestProject
//
//  Created by Yurii Huber on 02.11.15.
//  Copyright (c) 2015 Yurii Huber. All rights reserved.
//

#import "DetailViewController.h"
#import "math.h"
#import "UIView+MKAnnotationView.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.onMapView.delegate  =  self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    
    
    [self configureView];
    
    UIBarButtonItem*  zoomButton  =  [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                   target:self
                                                                                   action:@selector(zoomAnnotations:)];

    self.navigationItem.rightBarButtonItems  =  @[zoomButton];
    
    self.geoCoder  =  [[CLGeocoder  alloc]  init];
    
}

-(void)zoomAnnotations:(UIBarButtonItem*)  sender  {
    
    MKMapRect  zoomRect  =  MKMapRectNull;
    
    for  (id  <MKAnnotation>  annotation  in  self.onMapView.annotations)  {
        
        CLLocationCoordinate2D  location  =  annotation.coordinate;
        
        MKMapPoint  center  =  MKMapPointForCoordinate(location);
        
        double  delta  =  20000;
        
        MKMapRect rect  =  MKMapRectMake(center.x  -  delta,
                                         center.y  -  delta,
                                         delta*2,
                                         delta*2);
        
        zoomRect  =  MKMapRectUnion(zoomRect, rect);
        
    }
    
    zoomRect  =  [self.onMapView  mapRectThatFits:zoomRect];
    
    [self.onMapView  setVisibleMapRect:zoomRect
                           edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                              animated:YES];
    
}


- (double)getBlockSqrt:(double (^)(double))someBlock withArg:(double) arg {
    
    
    return someBlock(arg);
    
    
}



- (IBAction)actionForTap:(UITapGestureRecognizer  *)sender
{
    
    CGPoint point = [sender locationInView:sender.view];
    
    CLLocationCoordinate2D coordinates = [self.onMapView convertPoint:point toCoordinateFromView:self.onMapView];

    [self  creatingAnnotationWithPoint:coordinates];
}

- (IBAction)actionForLongPress:(UILongPressGestureRecognizer  *)sender  {
    
    if (sender.state  ==  UIGestureRecognizerStateBegan)  {
    
        CGPoint point = [sender locationInView:sender.view];
        
        CLLocationCoordinate2D coordinates = [self.onMapView convertPoint:point toCoordinateFromView:self.onMapView];
        
        [self  creatingAnnotationWithPoint:coordinates];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map annotation



- (void)creatingAnnotationWithPoint:(CLLocationCoordinate2D)point  {
    MapAnnotation  *annotation  =  [[MapAnnotation  alloc]  init];
    
    annotation.title  =  [NSString  stringWithFormat:@"longitude:%g",  point.longitude];
    annotation.subtitle  =  [NSString  stringWithFormat:@"latitude:%g",  point.latitude];
//    
    annotation.coordinate  =  point;
    
    
    [self.onMapView  addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString* identifier = @"Annotation";
    
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.pinColor = MKPinAnnotationColorRed;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.draggable = YES;
        
        UIButton* descriptionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [descriptionButton addTarget:self
                              action:@selector(actionDescription:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        pin.rightCalloutAccessoryView = descriptionButton;
        
        UIButton* recordButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        
        [recordButton addTarget:self
                         action:@selector(actionAddRecord:)
               forControlEvents:UIControlEventTouchUpInside];
        
        pin.rightCalloutAccessoryView = recordButton;
        
    } else {
        
        pin.annotation = annotation;
        
    }
    
    return pin;
}

- (void) dealloc  {
    
    [self.geoCoder  cancelGeocode];
    
}

- (void)actionAddRecord:(UIButton*)sender  {
    
    MKAnnotationView*  annotationView  =  [sender  superAnnotationView];
    
    if  (!annotationView)  {
        
        return;
        
    }
    
    CLLocationCoordinate2D  coordinate  =  annotationView.annotation.coordinate;
    
    NSDictionary  *dictionary  =  @{@"name" : @"abc",
                                     @"lat" : @(coordinate.latitude),
                                    @"long" : @(coordinate.longitude)};
    
    [[NSNotificationCenter  defaultCenter]
     postNotificationName:@"AddRecordNotification"
     object:nil
     userInfo:dictionary];
    
}

- (void)actionDescription:(UIButton*)sender  {
    
    MKAnnotationView*  annotationView  =  [sender  superAnnotationView];
    
    if  (!annotationView)  {
        
        return;
        
    }
    
    CLLocationCoordinate2D  coordinate  =  annotationView.annotation.coordinate;
    
    CLLocation*  location  =  [[CLLocation  alloc]  initWithLatitude:coordinate.latitude
                                                           longitude:coordinate.longitude];
    
    if  ([self.geoCoder  isGeocoding])  {
        
        [self.geoCoder  cancelGeocode];
    
    }
    
    
    
    
    [self.geoCoder  reverseGeocodeLocation:location
                         completionHandler:^(NSArray  *placemarks, NSError  *error) {
    
        NSString*  message  =  nil;
        
        if  (error)  {
            
            message  =  [error  localizedDescription];
            
        }  else  {
            
            if  ([placemarks  count]  >  0)  {
                
                MKPlacemark  *placeMark  =  [placemarks  firstObject];
                
                message  =  [placeMark.addressDictionary  description];
                
            }  else  {
                
                message  =  @"No Placemarks found";
                
            }
            
        }
       
        [[[UIAlertView  alloc]
              initWithTitle:@"location"
                    message:message
                   delegate:nil
          cancelButtonTitle:@"OK"
          otherButtonTitles:nil]  show];
        
    }];
    
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState  {
    
    if  (newState  ==  MKAnnotationViewDragStateEnding)  {
        
        
        
    }
    
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000);
    [self.onMapView setRegion:[self.onMapView regionThatFits:region] animated:YES];
    
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = userLocation.coordinate;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
//    
//    [self.onMapView addAnnotation:point];
}

//- (void) dealloc
//{
//    // If you don't remove yourself as an observer, the Notification Center
//    // will continue to try and send notification objects to the deallocated
//    // object.
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
////    [super dealloc];
//}

//- (id) init
//{
//    self = [super init];
//    if (!self) return nil;
//    
//    // Add this instance of TestClass as an observer of the TestNotification.
//    // We tell the notification center to inform us of "TestNotification"
//    // notifications using the receiveTestNotification: selector. By
//    // specifying object:nil, we tell the notification center that we are not
//    // interested in who posted the notification. If you provided an actual
//    // object rather than nil, the notification center will only notify you
//    // when the notification was posted by that particular object.
//    
////    [[NSNotificationCenter defaultCenter] addObserver:self
////                                             selector:@selector(receiveTestNotification:)
////                                                 name:@"TestNotification"
////                                               object:nil];
//    
//    return self;
//}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"TestNotification"])  {
        
        NSLog(@"Successfully received the test notification!");
        NSLog(@"%@",  [notification  userInfo]);
        
        MapAnnotation  *annotation  =  [[MapAnnotation  alloc]  init];
        
        annotation.title  =  [NSString  stringWithFormat:@"City:%@",  [[notification  userInfo]  objectForKey:@"name"]  ];
//        annotation.subtitle  =  [NSString  stringWithFormat:@"latitude:%@",  ];
        
        
        
        CLLocationCoordinate2D  point;

//        NSNumber  *n  =  [NSNumber  numberWithDouble:[[[notification  userInfo]  valueForKey:@"lat"]  doubleValue]];
        
        point.latitude  =  [[[notification  userInfo]  valueForKey:@"lat"]  doubleValue];
        point.longitude  =  [[[notification  userInfo]  valueForKey:@"long"]  doubleValue];
        
        annotation.coordinate  =  point;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point, 800, 800);
        [self.onMapView setRegion:[self.onMapView regionThatFits:region] animated:YES];
        
        [self.onMapView  addAnnotation:annotation];
        
    }
}



@end
