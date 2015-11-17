//
//  UIView.h
//  MapTestProject
//
//  Created by Ihor Zabrotsky on 11/16/15.
//  Copyright (c) 2015 Yurii Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MKAnnotationView;

@interface UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView;

@end
