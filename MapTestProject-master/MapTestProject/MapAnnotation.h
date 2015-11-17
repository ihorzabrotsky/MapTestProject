//
//  MapAnnotation.h
//  MapTestProject
//
//  Created by Ihor Zabrotsky on 11/9/15.
//  Copyright (c) 2015 Yurii Huber. All rights reserved.
//

#import  <Foundation/Foundation.h>
#import  <MapKit/MapKit.h>

@interface  MapAnnotation  :  NSObject  <MKAnnotation>
    
@property  (nonatomic)  CLLocationCoordinate2D  coordinate;
@property  (nonatomic,  copy)  NSString  *title;
@property  (nonatomic,  copy)  NSString  *subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description;

@end
