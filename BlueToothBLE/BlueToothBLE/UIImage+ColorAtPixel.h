//
//  UIImage+ColorAtPixel.h
//  fancyColor-BLE
//
//  Created by wzq on 14/8/21.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorAtPixel)
- (UIColor*)colorAtPixel:(CGPoint)point;
@end
