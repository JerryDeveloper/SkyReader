//
//  JXBookshelfViewController.m
//  SkyReader
//
//  Created by GUYU XUE on 19/3/14.
//  Copyright (c) 2014 JXDev. All rights reserved.
//

#import "JXBookshelfViewController.h"
#import "JXBookViewController.h"
#import "JXBook.h"

@interface JXBookshelfViewController ()

@end

@implementation JXBookshelfViewController

@synthesize books;
@synthesize bookViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    JXBook *book1 = [[JXBook alloc] init];
    book1.title = @"The first trial";
    book1.bookId = @"vhugo";
    JXBook *book2 = [[JXBook alloc] init];
    book2.title = @"honglou meng";
    book2.bookId = @"hlm";
    books = [[NSArray alloc] initWithObjects:book1, book2, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [books count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = ((JXBook *)[books objectAtIndex:indexPath.row]).title;
    return cell;
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"loadBook"])
    {
        bookViewController = (JXBookViewController*)segue.destinationViewController;
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        bookViewController.book = (JXBook *)[books objectAtIndex:ip.row];
        [bookViewController loadBook];
    }
}


@end
