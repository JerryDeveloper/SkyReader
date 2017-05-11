//
//  JXBook.h
//  SkyReader
//
//  Created by GUYU XUE on 19/3/14.
//  Copyright (c) 2014 JXDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JXChapter;

@interface JXBook : NSObject {
    NSArray *spineArray;
    NSString *title;
    NSString *bookId;
}

@property (nonatomic, strong) NSArray *spineArray;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *bookId;

- (BOOL) prepareBook;

@end
