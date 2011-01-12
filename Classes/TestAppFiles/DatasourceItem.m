//
//  DatasourceItem.m
//  UIXGallery
//
//  Created by gumbright on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatasourceItem.h"
#import "UIXGalleryController.h"

@implementation DatasourceItem 

@synthesize image;

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
