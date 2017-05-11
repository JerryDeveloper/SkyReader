//
//  JXBook.m
//  SkyReader
//
//  Created by GUYU XUE on 19/3/14.
//  Copyright (c) 2014 JXDev. All rights reserved.
//

#import "JXUtil.h"
#import "JXBook.h"
#import "TouchXML.h"
#import "JXChapter.h"
#import "ZipArchive.h"
#import "JXConstant.h"

@interface JXBook()
{
    NSString *zippedBookPath;
    NSString *unzippedBookPath;
}

- (BOOL) unzipAndSaveBook;
- (NSString *) parseContainerFile;
- (void) parseOPF:(NSString*)opfPath;
- (NSArray *) parseNCX: (NSString *) ncxPath ReturnById:(BOOL) idFlag returnByUrl:(BOOL) urlFlag;

@end

@implementation JXBook

@synthesize spineArray;
@synthesize title;
@synthesize bookId;

//
//
//-(id) initWithBookId: (NSString *) bookIdParam
//{
//    if(self = [super init])
//    {
//        
//        bookId = bookIdParam;
//        
//        
//        
//        [self parseBook];
//    }
//    
//    return self;
//}

- (BOOL) prepareBook
{
    // initiation
    spineArray = [[NSMutableArray alloc] init];
    zippedBookPath = [NSString stringWithFormat:@"%@/%@.%@", [JXUtil zippedBookFolder], bookId, kEpubFormat];
    unzippedBookPath = [NSString stringWithFormat:@"%@/%@",[JXUtil unzippedBookFolder], bookId];
    
    // unzip and load book meta data
    if(![self unzipAndSaveBook])
    {
        return NO;
    }
    
    NSString *opfPath = [self parseContainerFile];
    if (opfPath == nil) {
        return NO;
    }
    
    [self parseOPF:opfPath];
    
    return YES;
}

#pragma mark - unzip and parse

-(BOOL) unzipAndSaveBook
{
    NSFileManager *filemanager=[[NSFileManager alloc] init];
    
    if ([filemanager fileExistsAtPath:unzippedBookPath])
    {
        return YES;
    }
    
    if (![filemanager fileExistsAtPath:zippedBookPath])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"The book does not exist"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    ZipArchive *za = [[ZipArchive alloc] init];
    
    BOOL flag = NO;
    if([za UnzipOpenFile:zippedBookPath])
    {        
        BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",unzippedBookPath] overWrite:YES];
        if(!ret){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Error while unzipping the epub"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            flag = YES;
        }
        
        [za UnzipCloseFile];
    }
    
    return flag;
}

// return opf file path
- (NSString*) parseContainerFile
{
	NSString* manifestFilePath = [NSString stringWithFormat:@"%@/META-INF/container.xml", unzippedBookPath];

	NSFileManager *fileManager = [[NSFileManager alloc] init];
    
	if ([fileManager fileExistsAtPath:manifestFilePath])
    {
		CXMLDocument* manifestFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath] options:0 error:nil];
		CXMLNode* opfPath = [manifestFile nodeForXPath:@"//@full-path[1]" error:nil];
        
        return [NSString stringWithFormat:@"%@/%@", unzippedBookPath, [opfPath stringValue]];
	}
    else
    {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"The epub book is not valid"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        
		return nil;
	}
}

- (void) parseOPF:(NSString*)opfPath
{
	CXMLDocument* opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
	
    // manifest items
    NSArray* itemsArray = [opfFile nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    
    NSString* ncxFileName = nil;
	
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
	for (CXMLElement* element in itemsArray) {
		[itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
            ncxFileName = [[element attributeForName:@"href"] stringValue];
        }
	}
    
    // parse NCX for contents if there's one
    if (ncxFileName != nil) {
        // NCX path - relative path to OPF recorded in OPF
        int lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
        NSString* ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
        NSString* ncxPath = [NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName];
    }
    else {
        
    }
    
    
    NSArray* itemRefsArray = [opfFile nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    int count = 0;
	
    for (CXMLElement* element in itemRefsArray) {
        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];
        
        JXChapter* tmpChapter = [[JXChapter alloc] init];
		[tmpArray addObject:tmpChapter];
	}
	
	self.spineArray = [NSArray arrayWithArray:tmpArray];
}

// parsing NCX file for ebooks with epub 2 standard
// return format [dic_key_is_ID, dic_key_is_url]
// if corresponding flag == false, dic is nil
- (NSArray *) parseNCX: (NSString *) ncxPath ReturnById:(BOOL) idFlag returnByUrl:(BOOL) urlFlag
{
    CXMLDocument* ncxToc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:ncxPath] options:0 error:nil];
    
    

    return @[@"1", @"2"];
}

#pragma mark - utility function


@end
