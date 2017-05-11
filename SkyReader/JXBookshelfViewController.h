//
//  JXBookshelfViewController.h
//  SkyReader
//
//  Created by GUYU XUE on 19/3/14.
//  Copyright (c) 2014 JXDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXBook;
@class JXBookViewController;

@interface JXBookshelfViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *books;
    JXBookViewController *bookViewController;
}

@property (nonatomic, strong) NSArray *books;
@property (nonatomic, strong) JXBookViewController *bookViewController;

@end
