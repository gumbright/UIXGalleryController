//
//  UIXGalleryAppDelegate.h
//  UIXGallery
//
//  Created by gumbright on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIXGalleryViewController;

@interface UIXGalleryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIXGalleryViewController *viewController;
	UINavigationController* nav;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIXGalleryViewController *viewController;

@end

