//
//  MapAnnotation.m
//  MapTestProject
//
//  Created by Ihor Zabrotsky on 11/9/15.
//  Copyright (c) 2015 Yurii Huber. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    
    self  =  [super init];
    
    if  (self)  {
        
        self.coordinate  =  coord;
        
    }
    
    return  self;
    
}

@end
