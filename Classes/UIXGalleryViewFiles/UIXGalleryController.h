/*
 Copyright (c) 2011, Guy Umbright
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * The name of the author nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY Guy Umbright ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL Guy Umbright BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */ 

/////////////////////////////////////////////////////////////////////////////////////////
//
// Notes:
//
// - UIXGalleryController looks for graphics files for the forward & back with the names
//   icon_arrow_left.png & icon_arrow_right.png
//
// - UIXGalleryController changes the navbar to black & translucent so you may need to change them
//   back in the viewWillAppear in the controller that loads the gallery
//
/////////////////////////////////////////////////////////////////////////////////////////
#import <UIKit/UIKit.h>

#define UIXGALLERY_SINGLETAP_NOTIFICATION @"uixgallerycontroller.singletap"
//#define UIXGALLERY_DOUBLETAP_NOTIFICATION @"uixgallerycontroller.doubletap"

@class UIXGalleryTouchableScrollView;
@class UIXGalleryController;

#pragma mark -
#pragma mark UIXGalleryItem protocol

@protocol UIXGalleryItem
@required
@property (nonatomic,retain) UIImage* image;

@optional
@property (readonly) BOOL unavailable;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIXGalleryDatasource protocol
@protocol UIXGalleryDatasource <NSObject>

@required
- (NSUInteger) numberOfItemsforGallery:(UIXGalleryController*) gallery;
- (NSObject<UIXGalleryItem>*) gallery:(UIXGalleryController*) gallery itemAtIndex:(NSUInteger) index;

@optional
- (UIView*) gallery:(UIXGalleryController*) gallery busyViewForItemAtIndex:(NSUInteger) index;
//- (UIView*) gallery:(UIXGalleryController*) gallery unavailableViewForItemAtIndex:(NSUInteger) index;
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIXGalleryTouchableScrollViewDelegate
@protocol UIXGalleryTouchableScrollViewDelegate

- (void) touchableScrollView:(UIXGalleryTouchableScrollView*) touchableScrollView touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event;
- (void) touchableScrollView:(UIXGalleryTouchableScrollView*) touchableScrollView touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event;

@end


@interface UIXGalleryTouchableScrollView : UIScrollView 
{
	id <UIXGalleryTouchableScrollViewDelegate> touchableScrollViewDelegate;
}

@property (assign,assign) id <UIXGalleryTouchableScrollViewDelegate> touchableScrollViewDelegate;
@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIXGalleryCell

@interface UIXGalleryCell : UIXGalleryTouchableScrollView <UIXGalleryTouchableScrollViewDelegate,UIScrollViewDelegate>
{
	UIImageView* imageView;
	UIView* busyView;
	
	NSObject<UIXGalleryItem>* item;
	NSObject<UIXGalleryDatasource>* datasource;
}

@property (nonatomic, retain) NSObject<UIXGalleryItem>* item;
@property (readonly) UIImageView* imageView;
@property (nonatomic, retain) UIView* busyView;

- (id)init;
- (void) displayGalleryItem:(NSObject<UIXGalleryItem>*) obj;
- (void) clear;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIXGalleryController

@class UIXGalleryController;


@class UIXTouchableImageView;

@interface UIXGalleryController : UIViewController <UIScrollViewDelegate>
{
	IBOutlet UIXGalleryTouchableScrollView* scroll;
	UIBarButtonItem* forwardButton;
	UIBarButtonItem* backButton;
	UIBarButtonItem* playButton;
	
	NSTimer *slideshowTimer;
	BOOL timerRunning;
	
	UIToolbar* toolbar;
	
	id<UIXGalleryDatasource> datasource;
	NSInteger currentIndex;
	
	BOOL toolsShowing;
	
	NSMutableSet* galleryCellPool;
    
    NSTimer *rotationTimer;
    BOOL allowRotate;
}

@property (nonatomic, retain) id<UIXGalleryDatasource> datasource;
@property (assign) NSInteger currentIndex;

- (IBAction) backButtonPressed:(id) sender;
- (IBAction) forwardButtonPressed:(id) sender;

//- (void) reloadImageAtIndex:(NSUInteger) index;
@end
