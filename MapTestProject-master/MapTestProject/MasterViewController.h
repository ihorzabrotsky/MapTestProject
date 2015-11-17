//
//  MasterViewController.h
//  MapTestProject
//
//  Created by Yurii Huber on 02.11.15.
//  Copyright (c) 2015 Yurii Huber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController  <CLLocationManagerDelegate>

@property  (strong,  nonatomic)  DetailViewController  *detailViewController;
@property  (weak, nonatomic)  IBOutlet  UISegmentedControl  *segmentedController;
@property  (strong, nonatomic)  CLLocationManager  *locationManager;

-(IBAction)indexChanged:(id)sender;


@end