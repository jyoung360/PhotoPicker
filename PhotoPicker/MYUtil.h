//
//  MYUtil.h
//  PhotoPicker
//
//  Created by Joshua Young on 2/14/14.
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MYUtil : NSObject
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (BOOL)uploadImage:(UIImage *)image;;
@end

