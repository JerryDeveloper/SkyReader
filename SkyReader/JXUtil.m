//
//  JXUtil.m
//  SkyReader
//
//  Created by GUYU XUE on 16/4/14.
//  Copyright (c) 2014 JXDev. All rights reserved.
//

#import "JXUtil.h"
#import "JXConstant.h"

@implementation JXUtil

+ (NSString *)applicationDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *) zippedBookFolder {
    return [NSString stringWithFormat:@"%@/%@", [JXUtil applicationDocumentsDirectory], kZippedBooksFolder];
}

+ (NSString *) unzippedBookFolder {
    return [NSString stringWithFormat:@"%@/%@", [JXUtil applicationDocumentsDirectory], kUnzippedBooksFolder];
}

@end
