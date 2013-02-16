//
//  MediaKeys.h
//  MediaKeys Helper Plus
//
//  Copyright 2012-2013 Bilal Syed Hussain
//  Licensed under the Apache License, Version 2.0
//
//

#import <Foundation/Foundation.h>

@interface MediaKeys : NSObject

+ (void) toogle;
+ (void) next;
+ (void) nextWithShift;
+ (void) previous;
+ (void) previousWithShift;
+ (void) toogleWithCommand;

@end
