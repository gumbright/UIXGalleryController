//
//  DelayedDatasourceItem.h
//  UIXGallery
//
//  Created by gumbright on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DelayedDatasourceItem : NSObject 
{
	UIImage* image;
	UIImage* heldImage;
	NSTimer* timer;
}

- (id) initWithImage:(UIImage*) img;

@property (nonatomic,retain) UIImage* image;

@end
