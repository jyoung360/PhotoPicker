//
//  MYUtil.m
//  PhotoPicker
//
//  Created by Joshua Young on 2/14/14.
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//

#import "MYUtil.h"
#define DataDownloaderRunMode @"myapp.run_mode"

@implementation MYUtil
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (BOOL)uploadImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    NSURL *url = [NSURL URLWithString: @"http://synap.asymptomaticinsanity.com/image"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];

    [request setHTTPMethod:@"POST"];

    // We need to add a header field named Content-Type with a value that tells that it's a form and also add a boundary.
    // I just picked a boundary by using one from a previous trace, you can just copy/paste from the traces.
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];

    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // end of what we've added to the header

    // the body of the post
    NSMutableData *body = [NSMutableData data];

    // Now we need to append the different data 'segments'. We first start by adding the boundary.
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    // Now append the image
    // Note that the name of the form field is exactly the same as in the trace ('attachment[file]' in my case)!
    // You can choose whatever filename you want.
    [body appendData:[@"Content-Disposition: form-data; name=\"attachment[file]\"; filename=\"picture.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // We now need to tell the receiver what content type we have
    // In my case it's a png image. If you have a jpg, set it to 'image/jpg'
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // Now we append the actual image data
    [body appendData:[NSData dataWithData:imageData]];

    // and again the delimiting boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    // adding the body we've created to the request
    [request setHTTPBody:body];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:NO];

    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:DataDownloaderRunMode];

    [connection start];
    return true;
}
@end
