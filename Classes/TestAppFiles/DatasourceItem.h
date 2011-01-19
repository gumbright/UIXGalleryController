//
//  DatasourceItem.h
//  UIXGallery
//
//  Created by gumbright on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIXGalleryController.h"

@interface DatasourceItem : NSObject <UIXGalleryItem>
{
	UIImage* image;
}

- (id) initWithImage:(UIImage*) img;
- (id) initWithImageName:(NSString*) imgName;

@property (nonatomic,retain) UIImage* image;

@end
