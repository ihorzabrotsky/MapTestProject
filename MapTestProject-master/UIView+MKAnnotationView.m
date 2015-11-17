//
//  UIView.m
//  MapTestProject
//
//  Created by Ihor Zabrotsky on 11/16/15.
//  Copyright (c) 2015 Yurii Huber. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import "MapKit/MKAnnotationView.h"

@implementation UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView  {
    
    if  ([self  isKindOfClass:[MKAnnotationView  class]])  {
        
        return (MKAnnotationView*)self;
        
    }
    
    if  (!self.superview)  {
        
        return  nil;
        
    }
    
    return  [self.superview  superAnnotationView];
    
}


@end
