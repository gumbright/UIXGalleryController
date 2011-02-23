//
//  DatasourceItem.m
//  UIXGallery
//
//  Created by gumbright on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatasourceItem.h"
#import "UIXGalleryController.h"
#import <math.h>

@implementation DatasourceItem 

@synthesize image;

- (void) applyImage:(UIImage*) img
{
//	NSLog(@"applyImage");
	self.image = img; 
	NSLog(@"load done");
}

- (void) loadImage: (NSString*) imgName
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSString* path = [[NSBundle mainBundle] pathForResource:[imgName stringByDeletingPathExtension] ofType:[imgName pathExtension]];
	NSData* data = [NSData dataWithContentsOfFile:path];
	
	CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData ((CFDataRef) data);
	CGImageRef img = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
	CFRelease(imgDataProvider);

	UIImage* uimg = [UIImage imageWithCGImage:img]; 
	CGImageRelease(img);
	
	[self performSelectorOnMainThread:@selector(applyImage:) withObject:uimg waitUntilDone:NO modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];

	[pool release];
}

- (id) initWithImageName:(NSString*) imgName
{
	if (self = [super init])
	{	
#if 0		
		NSLog(@"init img=%@",imgName);
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), 
					   ^{
						   NSString* path = [[NSBundle mainBundle] pathForResource:[imgName stringByDeletingPathExtension] ofType:[imgName pathExtension]];
						   NSData* data = [NSData dataWithContentsOfFile:path];
						   
						   CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData ((CFDataRef) data);
						   CGImageRef img = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
						   CFRelease(imgDataProvider);
						   UIImage* uimg = [UIImage imageWithCGImage:img];
						   CGImageRelease(img);
						   dispatch_async(dispatch_get_main_queue(), 
										  ^{self.image = uimg;}); 
					   });
#else
		NSLog(@"start load");
		[self performSelectorInBackground:@selector(loadImage:) withObject:imgName];
#endif		
	}
	
	return self;
}

- (id) initWithImage:(UIImage*) img
{
	if (self = [super init])
	{
		image = [img retain];
	}
	
	return self;
}

- (void) dealloc
{
	[image release];
	[super dealloc];
}

@end
