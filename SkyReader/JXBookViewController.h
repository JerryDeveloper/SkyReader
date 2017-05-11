//
//  JXBookViewController.h
//  SkyReader
//
//  Created by GUYU XUE on 30/3/14.
//  Copyright (c) 2014 JXDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXBook;

@interface JXBookViewController : UIViewController <UIWebViewDelegate, UISearchBarDelegate>
{
    UIWebView *webView;
    JXBook *book;
}

@property (nonatomic, strong) JXBook *book;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

-(void) loadBook;

@end
