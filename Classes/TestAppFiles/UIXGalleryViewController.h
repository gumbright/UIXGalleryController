//
//  UIXGalleryViewController.h
//  UIXGallery
//
//  Created by gumbright on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryDatasource.h"

@interface UIXGalleryViewController : UIViewController 
{
	GalleryDatasource* datasource;
}

- (IBAction) galleryPressed:(id) sender;
@end

