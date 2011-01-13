//
//  DelayedDatasourceItem.m
//  UIXGallery
//
//  Created by gumbright on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DelayedDatasourceItem.h"


@implementation DelayedDatasourceItem

@synthesize image;

- (id) initWithImage:(UIImage*) img
{
	if (self = [super init])
	{
		heldImage = [img retain];
		
		timer = [[NSTimer scheduledTimerWithTimeInterval:5.0 
												 target:self
											   selector:@selector(timerFired:) 
											   userInfo:nil
												repeats:NO] retain];
	}
	
	return self;
}

- (void) timerFired:(NSTimer*) t
{
	self.image = heldImage;
	[t invalidate];
}

- (void) dealloc
{
	[heldImage release];
	[image release];
    [timer release];
	[super dealloc];
}

@end


