//
//  MasterViewController.m
//  MapTestProject
//
//  Created by Yurii Huber on 02.11.15.
//  Copyright (c) 2015 Yurii Huber. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MyCustomizedCell.h"

@interface MasterViewController () //<CLLocationManagerDelegate>

@property NSMutableArray *objects;
@end

@implementation MasterViewController


- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.objects  =  [NSMutableArray  array];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self  startSignificantChangeUpdates];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAddRecordNotification:)
                                                 name:@"AddRecordNotification"
                                               object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    
    
//    [self.objects insertObject:[NSDate date] atIndex:0];
    
    NSDictionary  *dict  =  @{@"name": @"0",
                              @"lat": @"1",
                              @"long": @"2"};
    
    [self.objects  insertObject:dict atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(IBAction)indexChanged:(id)sender  {
    
    if  (self.objects)  {
        
        [self.objects  removeAllObjects];
        
    }
    
    NSMutableArray * array;
    
    if  (![self.segmentedController  selectedSegmentIndex])  {
        
        NSURL  *path  =  [[NSBundle  mainBundle]  URLForResource:@"Directions"  withExtension:@"geojson"];
        NSData  *data  =  [NSData dataWithContentsOfURL:path];
        NSError  *error  =  nil;
        array  =  [[NSJSONSerialization  JSONObjectWithData:data  options:0  error:&error] mutableCopy];
        
        
        
        if (error  ==  nil) {
            NSLog(@"Json:\n%@",  array);
        }  else  {
            NSLog(@"error %@",  [error  localizedDescription]);
        }
        
    }
    else  {
        
        NSURL  *path  =  [[NSBundle  mainBundle]  URLForResource:@"PropertyList"  withExtension:@"plist"];
        array  =  [[NSMutableArray arrayWithContentsOfURL:path] mutableCopy];
        NSLog(@"Plist:\n%@", array);
        
    }
    
    [self.objects  addObjectsFromArray:array];
    
//    NSUInteger count = CFGetRetainCount((__bridge CFTypeRef)(self.objects));
    
    [self.tableView  reloadData];

}

#pragma mark - Segues
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = self.objects[indexPath.row];
//        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
//        [controller setDetailItem:object];
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
//    }
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//
//    NSDate *object = self.objects[indexPath.row];
//    cell.textLabel.text = [object description];
//    return cell;
//}

- (MyCustomizedCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCustomizedCell  *cell  =  [tableView  dequeueReusableCellWithIdentifier:@"MyCustomizedCell"];

    if (self.objects)  {
    
    NSDictionary*  object  =  [[NSDictionary  alloc]  initWithDictionary:[self.objects  objectAtIndex:indexPath.row]];
    
    
        cell.name.text  =  [NSString  stringWithString:[object  objectForKey:@"name"]];
        cell.latitude.text  =  [NSString  stringWithFormat:@"%@",  [object  objectForKey:@"lat"]];
        cell.longitude.text  =  [NSString  stringWithFormat:@"%@",  [object  objectForKey:@"long"]];

    }  else  {
        
        cell.name.text  =  @"aaaa";
        cell.latitude.text  =  @"bbbbb";
        cell.longitude.text  =  @"ccc";
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
//    MyCustomizedCell  *cell  =  [tableView  cellForRowAtIndexPath:indexPath];

//    NSDictionary  *dictionary  =  [NSDictionary  dictionaryWithObjectsAndKeys:
//                                   cell.name.text,  @"name",
//                                   cell.latitude.text,  @"lat",
//                                   cell.longitude.text,  @"long",
//                                   nil];
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary  *dictionary  =  [NSDictionary  dictionaryWithDictionary:[self.objects  objectAtIndex:indexPath.row]];
    
    [[NSNotificationCenter  defaultCenter]
    postNotificationName:@"TestNotification"
                  object:nil
                userInfo:dictionary];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - Core Location

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    
//    CLLocationManager  *locationManager;
    
    if (self.locationManager  ==  nil)
        self.locationManager  =  [[CLLocationManager  alloc]  init];
    
    self.locationManager.delegate  =  self;
    
    if ([self.locationManager  respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager  requestAlwaysAuthorization];
    }
    
    [self.locationManager  startMonitoringSignificantLocationChanges];
    
    
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (fabs(howRecent) < 500.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
//    }
}

- (void) receiveAddRecordNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"AddRecordNotification"])  {
        
        NSLog(@"Successfully received the test notification!");
        NSLog(@"%@",  [notification  userInfo]);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        
        
    }

}


@end