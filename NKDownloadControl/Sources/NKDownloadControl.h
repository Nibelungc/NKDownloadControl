//
//  NKDownloadControl.h
//  DownloadViewProj
//
//  Created by Nikolay Kagala on 23/06/16.
//  Copyright © 2016 Nikolay Kagala. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface NKDownloadControl : UIControl

@property (strong, nonatomic) UIColor* buttonTintColor;

@property (strong, nonatomic) UIColor* progressTintColor;

@property (strong, nonatomic) UIColor* circleBackgroundColor;

@property (assign, nonatomic) CGFloat lineWidth;

@end
