//
//  MyCustomizedCell.h
//  MapTestProject
//
//  Created by Ihor Zabrotsky on 11/11/15.
//  Copyright (c) 2015 Yurii Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MyCustomizedCell : UITableViewCell

@property  (nonatomic,  weak)  IBOutlet  UILabel  *name;
@property  (nonatomic,  weak)  IBOutlet  UILabel  *latitude;
@property  (nonatomic,  weak)  IBOutlet  UILabel  *longitude;

@end
