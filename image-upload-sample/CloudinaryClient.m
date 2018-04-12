//
//  CloudinaryClient.m
//  Kezzi.co LLC
//
//  Created by Lee Irvine on 4/11/18.
//  Copyright © 2018 kezzi.co. All rights reserved.
//

@import Cloudinary;

#import "CloudinaryClient.h"
#import "UIImage+Editting.h"

@interface CloudinaryClient()
@property (nonatomic, strong) CloudinaryClient *retainSelf;
@end

@implementation CloudinaryClient

+ (void) uploadPhoto:(UIImage *) image callback:(callback) cb {
  CloudinaryClient *client = [[CloudinaryClient alloc] init];
  [client storeImage:image withPreset:@"upload-photo" callback:^(NSError *error, NSURL *imageUrl) {
    cb(error, imageUrl);
  }];
}

- (void) storeImage:(UIImage *) image withPreset:(NSString *) preset callback:(callback) cb {
  if(image == nil) return;

  NSString *apiKey = @"< YOUR API KEY HERE >";
  NSString *apiSecret = @"< YOUR API SECRET HERE >";
  NSString *cloudName = @"< YOUR CLOUD NAME HERE >";

  NSString *url = [NSString stringWithFormat:@"cloudinary://%@:%@@%@", apiKey, apiSecret, cloudName];
  CLDConfiguration *config = [[CLDConfiguration alloc] initWithCloudinaryUrl:url];
  CLDCloudinary *cld = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];

  // Photo is uploaded as JPEG with some minor compression
  NSData *jpg = UIImageJPEGRepresentation(image, .75f);

  self.retainSelf = self;

  UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
  [cld.createUploader uploadWithData:jpg uploadPreset:preset params:nil
    progress:^(NSProgress * progress) {
      NSLog(@"uploading photo...");
    } completionHandler:^(CLDUploadResult *result, NSError *error) {
      UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;

      if( error ) {
        NSLog(@"error uploading image: %@", error);
      }

      NSLog(@"uploaded image to URL: %@", result.secureUrl);
      dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *httpsUrl = [NSURL URLWithString:result.secureUrl];
        cb(error, httpsUrl);
        self.retainSelf = nil;
      });
    }];
}

@end
