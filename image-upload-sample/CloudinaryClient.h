//
//  CloudinaryClient.h
//  Fitting Roommate
//
//  Created by Lee Irvine on 6/2/17.
//  Copyright © 2017 kezzi.co. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callback)(NSError *error, id obj);

@class UIImage;
@interface CloudinaryClient : NSObject
+ (void) uploadPhoto:(UIImage *) image callback:(callback) cb;
+ (void) uploadIcon:(UIImage *) image callback:(callback) cb;
@end
