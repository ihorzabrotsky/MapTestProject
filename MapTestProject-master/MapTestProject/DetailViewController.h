//
//  DetailViewController.h
//  MapTestProject
//
//  Created by Yurii Huber on 02.11.15.
//  Copyright (c) 2015 Yurii Huber. All rights reserved.
//

#import  <UIKit/UIKit.h>
#import  "MapAnnotation.h"

@interface DetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property  (strong,  nonatomic)  IBOutlet  MKMapView  *onMapView;

@property  (strong,  nonatomic)  IBOutlet UITapGestureRecognizer  *actionForTap;
@property  (strong,  nonatomic) IBOutlet UILongPressGestureRecognizer *actionForLongPress;
@property  (nonatomic,  strong)  CLGeocoder  *geoCoder;

- (IBAction)actionForTap:(UITapGestureRecognizer  *)sender;

- (IBAction)actionForLongPress:(UILongPressGestureRecognizer  *)sender;
//- (void)getBlockSqrt:(double(^)(void))someBlock;
@end