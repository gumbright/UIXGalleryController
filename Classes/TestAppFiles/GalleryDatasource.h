//
//  GalleryDatasource.h
//  UIXGallery
//
//  Created by gumbright on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIXGalleryController.h"

@interface GalleryDatasource : NSObject 
{
	NSURLConnection* connection;
}

@property (nonatomic, retain) NSURLConnection* connection;

- (NSUInteger) numberOfItemsforGallery:(UIXGalleryController*) gallery;
- (id<UIXGalleryItem>) gallery:(UIXGalleryController*) gallery itemAtIndex:(NSUInteger) index;
- (UIView*) gallery:(UIXGalleryController*) gallery busyViewForItemAtIndex:(NSUInteger) index;

@end
