//
//  JXBookViewController.m
//  SkyReader
//
//  Created by GUYU XUE on 30/3/14.
//  Copyright (c) 2014 JXDev. All rights reserved.
//

#import "JXBookViewController.h"
#import "JXBook.h"
#import "JXUtil.h"

@interface JXBookViewController ()

@end

@implementation JXBookViewController

@synthesize book;
@synthesize webView;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark

-(void) loadBook
{
    [book prepareBook];
}

#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
