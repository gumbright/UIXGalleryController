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

#import "UIXGalleryController.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_POOL_SIZE 5
#define PRELOAD_SIZE 1

#pragma mark -
#pragma mark UIXGalleryTouchableScrollView
@implementation UIXGalleryTouchableScrollView

@synthesize touchableScrollViewDelegate;

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	if (touchableScrollViewDelegate && 
		[(NSObject*)touchableScrollViewDelegate respondsToSelector:@selector(touchableScrollView:touchesBegan:withEvent:)])
	{
		[touchableScrollViewDelegate touchableScrollView:self touchesBegan:touches withEvent:event];
	}		
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	if (touchableScrollViewDelegate && 
		[(NSObject*)touchableScrollViewDelegate respondsToSelector:@selector(touchableScrollView:touchesEnded:withEvent:)])
	{
		[touchableScrollViewDelegate touchableScrollView:self touchesEnded:touches withEvent:event];
	}	
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) dealloc
{
	[super dealloc];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIXGalleryCell
@implementation UIXGalleryCell

@synthesize item;
@synthesize imageView;
@dynamic busyView;

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (id)init
{
    
    self = [super initWithFrame:CGRectZero];
    if (self) 
	{
		self.contentMode = (UIViewContentModeScaleAspectFit);
		self.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		self.maximumZoomScale = 4; //!!!:this should be a config point
		self.minimumZoomScale = 1;
		self.clipsToBounds = YES;
		self.touchableScrollViewDelegate = self;
		self.multipleTouchEnabled = YES;
		self.delegate = self;
		self.zoomScale = 1.0;		
		imageView = nil;
		self.opaque = YES;
		
		imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
									UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
									UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		imageView.tag = 9700;
		imageView.opaque = YES;
		[self addSubview:imageView];
		[imageView release];		
    }
    return self;
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) displayImage:(UIImage*) img
{
//	NSLog(@"displayImage begin");
//	if (imageView == nil)
//	{
//		imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//		imageView.contentMode = UIViewContentModeScaleAspectFit;
//		imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//		imageView.tag = 9700;
//		imageView.opaque = YES;
//		[self addSubview:imageView];
//		[imageView release];		
//	}

	imageView.image = img;
//	NSLog(@"displayImage done");
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) displayGalleryItem:(NSObject<UIXGalleryItem>*) obj
{
//	NSLog(@"displayGalleryItem begin");
	UIImage* img = obj.image;
	if (img == nil)
	{
		if (item != obj) {
			[item removeObserver:@"image" forKeyPath:@"keyPath"];
			[item release];
			item = [obj retain];
			[item addObserver:self 
				   forKeyPath:@"image" 
					  options:NSKeyValueObservingOptionNew
					  context:nil];
		}
	}
	else 
	{
		[self displayImage:img];
		self.busyView = nil;
	}
//	NSLog(@"displayGalleryItem end");
	
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//	NSLog(@"image kvo changed");
	UIImage* img = [change objectForKey:NSKeyValueChangeNewKey];
	self.busyView = nil;
	// ???: doesnt it need to be removed from superview?
	
	[self displayImage:img];
//	NSLog(@"image kvo done");
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void)dealloc 
{
	[item removeObserver:self forKeyPath:@"image"];
	[item release];
	[busyView release];
	[super dealloc];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) touchableScrollView:(UIXGalleryTouchableScrollView*) touchableScrollView touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event;
{
//	if ([touches count] == 1)
//	{	 
//		UITouch* touch = [touches anyObject];
//		
//		switch (touch.tapCount)
//		{				
//			case 1:
//			{
////				[self performSelector:@selector(toggleTools) withObject:nil  afterDelay:.3];
//				[[NSNotificationCenter defaultCenter] postNotificationName:UIXGALLERY_SINGLETAP_NOTIFICATION object:self];
//			}
//				break;
//
//			case 2:
//			{
//				[UIView beginAnimations:@"scalechange" context:nil];
//				if (touchableScrollView.zoomScale != 1.0)
//				{
//					touchableScrollView.zoomScale = 1.0;
//				}
//				else 
//				{
//					touchableScrollView.zoomScale = 2.0;
//				}
//				[UIView commitAnimations];
//			}
//				break;
//		}
//	}
}


////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) signalSingleTap:(id) obj
{
	[[NSNotificationCenter defaultCenter] postNotificationName:UIXGALLERY_SINGLETAP_NOTIFICATION object:self];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) touchableScrollView:(UIXGalleryTouchableScrollView*) touchableScrollView touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event
{
	if ([touches count] == 1)
	{	 
		UITouch* touch = [touches anyObject];
		
		switch (touch.tapCount)
		{				
			case 1:
			{
				[self performSelector:@selector(signalSingleTap:) withObject:nil afterDelay:0.30];
				//[[NSNotificationCenter defaultCenter] postNotificationName:UIXGALLERY_SINGLETAP_NOTIFICATION object:self];
			}
				break;

			case 2:
			{				
				[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(signalSingleTap:) object:nil];

				[UIView beginAnimations:@"scalechange" context:nil];
				if (touchableScrollView.zoomScale != 1.0)
				{
					touchableScrollView.zoomScale = 1.0;
				}
				else 
				{
					touchableScrollView.zoomScale = 2.0;
				}
				[UIView commitAnimations];
			}
				break;
		}
	}
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) clear 
{
	imageView.image = nil;
	[item removeObserver:self forKeyPath:@"image"];
	self.item = nil;
	
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return imageView;
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (UIView*) busyView
{
	return busyView;
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) setBusyView:(UIView*) v
{
	if (busyView == v)
	{
		return;
	}
	
	[busyView removeFromSuperview];
	[busyView release];
	
	if (v != nil)
	{
		//rect to center view
		CGRect frame = v.bounds;
		
		frame.origin.x = (self.bounds.size.width - v.bounds.size.width) / 2; 
		frame.origin.y = (self.bounds.size.height - v.bounds.size.height) / 2;
		
		v.frame = frame;
		
		[self addSubview:v];
	}
	
	busyView = [v retain];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIXGalleryController

@interface UIXGalleryController ()

- (void) currentIndexChanged;
- (void)startTimer;
- (void)destroyTimer;
- (void)toggleTools;

@end

@implementation UIXGalleryController

@synthesize currentIndex;
@synthesize datasource;

/////////////////////////////////////////
//
/////////////////////////////////////////
- (id) init
{
	if (self = [super init])
	{
		toolsShowing = YES;
        rotationTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(allowRotation:) userInfo:nil repeats:NO] retain]; 
	}	
	
	return self;
}

- (void)allowRotation:(NSTimer *)timer {
    allowRotate = YES;
    [rotationTimer release];
    rotationTimer = nil;
}

#define PADDING 10

- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGSize size = frame.size;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        CGFloat newWidth = size.height;
        CGFloat newHeight = size.width;
        size = CGSizeMake(newWidth, newHeight);
    } 
    frame.size = size;
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    
    CGRect pageFrame = pagingScrollViewFrame;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (pagingScrollViewFrame.size.width * index) + PADDING;
    return pageFrame;
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) loadView
{
	UIView* v = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
						UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
						UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	v.opaque = YES;
	v.backgroundColor = [UIColor blackColor];
	
	scroll = [[UIScrollView alloc] initWithFrame:[self frameForPagingScrollView]];
	scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
                            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	scroll.pagingEnabled = YES;
	scroll.delegate = self;
	scroll.opaque = YES;
	// There is a bug in 3.x (not yet sure about 3.2.x) where RateFast does not page properly.
	// RateFast is a better experience, so use it if we can.  NRC, 2011/02/18
	if (NSOrderedAscending == [[[UIDevice currentDevice] systemVersion] compare:@"4.0"]) {
		scroll.decelerationRate = UIScrollViewDecelerationRateNormal;
	} else {
		scroll.decelerationRate = UIScrollViewDecelerationRateFast;
	}
	scroll.backgroundColor = [UIColor blackColor];
	[v addSubview:scroll];
	[scroll release];
	
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, v.frame.size.height-44, 320, 44)];
	toolbar.barStyle = UIBarStyleBlack;
	toolbar.translucent = YES;
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	[scroll addSubview:toolbar];
	[v addSubview:toolbar];
	[toolbar release];
	
	backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_left.png"]
												  style: UIBarButtonItemStylePlain
												 target:self
												 action:@selector(backButtonPressed:)];

	forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_right.png"]
													 style: UIBarButtonItemStylePlain
												 target:self
												 action:@selector(forwardButtonPressed:)];
	
	playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playButtonPressed:)];
	
	[toolbar setItems:[NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																						  target:nil 
																						  action:nil] autorelease],
				  backButton,
				  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																 target:nil 
																 action:nil] autorelease],
					   playButton,
					   [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																	  target:nil 
																	  action:nil] autorelease],					   
				  forwardButton,
				  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																 target:nil 
																 action:nil] autorelease],nil ]];
	self.view = v;
	[v release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTapped:) name:UIXGALLERY_SINGLETAP_NOTIFICATION object:nil];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void)viewDidLoad 
{
    [super viewDidLoad];
		
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(back:)] autorelease];
    
	CATransition* trans = [CATransition animation];
	trans.type = kCATransitionFade;
	trans.duration = 2.0;

	[[self.view layer] addAnimation:trans forKey:nil];
	
	//yes 5 is theoratically more than we need, but if I have a timing issue and it is aleviated by always having
	//something available in the pool, I can prevent the crash which is the worse evil
	galleryCellPool = [[NSMutableSet setWithCapacity:CELL_POOL_SIZE] retain];
	
	for (int x = 0; x < CELL_POOL_SIZE; ++x)
	{
		UIXGalleryCell* cell = [[UIXGalleryCell alloc] init];
		cell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
								UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
								UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		cell.decelerationRate = UIScrollViewDecelerationRateFast;
		[galleryCellPool addObject:cell];
		[cell release];
	}
	
	CGSize sz = CGSizeMake(scroll.frame.size.width * [datasource numberOfItemsforGallery:self],scroll.frame.size.height);
	scroll.contentSize = sz;
	//[self currentIndexChanged];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return [[scrollView subviews] objectAtIndex:0];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) adjustControls
{
//	NSArray* items;
//
//		items = [NSArray arrayWithObjects:var1,
//				 backButton,
//				 fixed1,
//				 forwardButton,
//				 var2,
//				 nil];
	
		
	//later will need to adjust which are shown based on gallery/single image
	
	if (currentIndex >= [datasource numberOfItemsforGallery:self]-1)
	{
		forwardButton.enabled = NO;
	}
	else
	{
		forwardButton.enabled = YES;
	}
	
	if (currentIndex == 0)
	{
		backButton.enabled = NO;
	}
	else
	{
		backButton.enabled = YES;
	}
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
//- (void) transitionToImage:(UIImage*) img
//{
//	CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
//	crossFade.duration = 0.5;
//	crossFade.toValue = (id) img.CGImage;
//}
//

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
//- (void) displayImage:(NSInteger) ndx image:(UIImage*) img
//{
//	if (ndx == currentIndex)
//	{
//	}	
//	
//	UIImageView* iv = (UIImageView*) [scroll viewWithTag:ndx+9900];
//
//	iv.image = img;
//	[self adjustControls];
//}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) currentIndexChanged
{
	self.navigationItem.title = [NSString stringWithFormat:@"%d of %d",currentIndex+1,[datasource numberOfItemsforGallery:self]];
	UIXGalleryCell* sv;
	
	//
	//remove any views more than 1 away from current
	//
	if ((currentIndex - (PRELOAD_SIZE+1)) >= 0)
	{
		sv = (UIXGalleryCell*) [scroll viewWithTag:(currentIndex - (PRELOAD_SIZE+1)) + 9900];
		if (sv != nil)
		{
//			PhotoDebugLog(@"removing cell %d",sv.tag);
			[[sv retain] removeFromSuperview];
			[sv clear];
			sv.tag = 0;
			[galleryCellPool addObject:sv];
			[sv release];
		}
	}
	
	if ((currentIndex + (PRELOAD_SIZE+1)) < [datasource numberOfItemsforGallery:self])
	{
		sv = (UIXGalleryCell*) [scroll viewWithTag:(currentIndex + (PRELOAD_SIZE+1)) + 9900];
		if (sv != nil)
		{
//			PhotoDebugLog(@"removing cell %d",sv.tag);
			[[sv retain] removeFromSuperview];
			[sv clear];
			sv.tag = 0;
			[galleryCellPool addObject:sv];
			[sv release];
		}
	}
	
	//
	// add left/right as needed
	//
	for (int ndx=1; ndx <= PRELOAD_SIZE; ndx++)
	{	
		if (currentIndex > 0 && [scroll viewWithTag:(currentIndex-ndx)+9900] == nil) //do left
		{
			sv = [[galleryCellPool anyObject] retain];
			if (sv)
			{
				[galleryCellPool removeObject:sv];
			} else 
			{
				sv = [[self createNewGalleryCell] retain];
			}
			sv.tag = (currentIndex - ndx) + 9900;
			[sv clear];
			sv.zoomScale = 1.0;
			CGRect frame = [self frameForPageAtIndex:currentIndex-ndx];/*sv.frame;           
			frame.origin.y = 0;
			frame.origin.x = scroll.frame.size.width * (currentIndex - ndx) - PADDING;
			frame.size.width = scroll.frame.size.width + (2 * PADDING);
			frame.size.height = scroll.frame.size.height;*/
			sv.frame = frame;
			[scroll addSubview:sv];
			[scroll sendSubviewToBack:sv];
			[sv release];
		}
	}
	
	for (int ndx=1; ndx <= PRELOAD_SIZE; ndx++)
	{	
		if (currentIndex < [datasource numberOfItemsforGallery:self]-1 &&  [scroll viewWithTag:(currentIndex+ndx)+9900] == nil) //do right
		{
			sv = [[galleryCellPool anyObject] retain];
			if (sv)
			{
				[galleryCellPool removeObject:sv];
			} else 
			{
				sv = [[self createNewGalleryCell] retain];
			}
			
			sv.tag = (currentIndex + ndx) + 9900;
			[sv clear];
			sv.zoomScale = 1.0;
			CGRect frame = [self frameForPageAtIndex:currentIndex+ndx];/*sv.frame;
			frame.origin.y = 0;
			frame.origin.x = scroll.frame.size.width * (currentIndex + ndx) - PADDING;
			frame.size.width = scroll.frame.size.width + (2 * PADDING);
			frame.size.height = scroll.frame.size.height;*/
			sv.frame = frame;
			[scroll addSubview:sv];
			[scroll sendSubviewToBack:sv];
			[sv release];
		}
	}
	
	//
	// set up the current
	//
	if ([scroll viewWithTag:currentIndex + 9900] == nil)
	{
		sv = [[galleryCellPool anyObject] retain];
		if (sv)
		{
			[galleryCellPool removeObject:sv];
		} else 
		{
			sv = [[self createNewGalleryCell] retain];
		}
		
		sv.tag = currentIndex + 9900;
	
		CGRect frame = [self frameForPageAtIndex:currentIndex];/*sv.frame;
		frame.origin.y = 0;
		frame.origin.x = scroll.frame.size.width * currentIndex - PADDING;
		frame.size.width = scroll.frame.size.width + (2 * PADDING);
		frame.size.height = scroll.frame.size.height;*/
		sv.frame = frame;
		[scroll addSubview:sv];
		[scroll sendSubviewToBack:sv];
		[sv release];
	}
	
	//
	// make sure image is loaded for each
	//
	for (NSInteger ndx = 0; ndx < (PRELOAD_SIZE*2)+1; ++ndx)
	{
		NSInteger photoNdx = (currentIndex - 1) + ndx;

		if (photoNdx < 0 || photoNdx >= [datasource numberOfItemsforGallery:self])
		{
			continue;
		}
		
		sv = (UIXGalleryCell*) [scroll viewWithTag:(currentIndex - 1) + ndx+9900];
		sv.zoomScale = 1.0;
		if (sv.item == nil && sv.imageView.image == nil)
		{
			NSObject<UIXGalleryItem>* item = [datasource gallery:self itemAtIndex: photoNdx];

			/*if (ndx !=1) //its the center
			{
				sv.zoomScale = 1.0;
			}*/	

			if (item.image == nil)
			{
				if ([datasource respondsToSelector:@selector(gallery:busyViewForItemAtIndex:)])
				{
					UIView* v = [datasource gallery:self busyViewForItemAtIndex:photoNdx];
					sv.busyView = v;
				}	
			}

			[sv displayGalleryItem:item];
		}	
	}
	
	[self adjustControls];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (UIXGalleryCell *)createNewGalleryCell {
	UIXGalleryCell* cell = [[UIXGalleryCell alloc] init];
	cell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
	UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
	UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	cell.decelerationRate = UIScrollViewDecelerationRateFast;
	[cell autorelease];
	return cell;
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) showTools
{
	if (!toolsShowing)
	{
		CGRect frame;

		[UIView beginAnimations:@"captionslide" context:nil];
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		frame = toolbar.frame;
		frame.origin.y -= frame.size.height;
		toolbar.frame = frame;
		[UIView commitAnimations];
		toolsShowing = YES;
	}	
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) hideTools
{
	if (toolsShowing)
	{
		CGRect frame;
		[UIView beginAnimations:@"captionslide" context:nil];
		[self.navigationController setNavigationBarHidden:YES animated:YES];
		
		frame = toolbar.frame;
		frame.origin.y += frame.size.height;
		toolbar.frame = frame;

		[UIView commitAnimations];
		toolsShowing = NO;
	}	
}


////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return ((allowRotate && UIInterfaceOrientationIsLandscape(interfaceOrientation)) || UIInterfaceOrientationIsPortrait(interfaceOrientation));
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    /*CGRect frame;

	switch (interfaceOrientation) 
	{
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
		{
			frame = CGRectMake(0, 0, 320, 460);
		}
			break;
			
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
		{
			frame = CGRectMake(0, 0, 480, 300);
		}
			break;
			
		default:
			break;
	}
	
	self.view.frame = frame;*/
	
	scroll.contentSize = CGSizeMake(scroll.frame.size.width * [datasource numberOfItemsforGallery:self], scroll.frame.size.height);
	scroll.contentOffset = CGPointMake(scroll.frame.size.width * currentIndex, 0);
	[self currentIndexChanged];
    /*for (int ndx = 1; ndx > -2; --ndx)
	{
		NSInteger picNdx = currentIndex + ndx;
		UIImageView* iv = (UIImageView*)[scroll viewWithTag:picNdx+9900];
		
		if (iv != nil)
		{
			frame.origin.x = picNdx * scroll.frame.size.width;
			frame.origin.y = 0;
			frame.size.width = scroll.frame.size.width;
			frame.size.height = scroll.frame.size.height;
			iv.frame = frame;
		}
	}*/
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) viewWillAppear:(BOOL) animated 
{
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	self.navigationController.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleBottomMargin;
	
	self.navigationController.navigationBarHidden = NO;

	[self currentIndexChanged];

	scroll.contentOffset = CGPointMake(currentIndex * scroll.frame.size.width,0);
	[self adjustControls];
	[super viewWillAppear:animated];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) viewWillDisappear:(BOOL) animated 
{
	[self destroyTimer];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void)viewDidUnload 
{
	[self destroyTimer];
	[galleryCellPool release]; galleryCellPool = nil;
	[forwardButton release]; forwardButton = nil;
	[backButton release]; backButton = nil;
	
	[super viewDidUnload];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void)dealloc 
{
	[self destroyTimer];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[galleryCellPool release];
	
	self.datasource = nil;
	
	[forwardButton release];
	[backButton release];
	[playButton release];
	[super dealloc];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (IBAction) backButtonPressed:(id) sender
{
	if (currentIndex > 0)
	{
		--currentIndex;
		[scroll setContentOffset:CGPointMake(currentIndex * scroll.frame.size.width,0) animated:YES];
		[self currentIndexChanged];
	}
}

- (void)goNext:(BOOL)animated {
	if (currentIndex < [datasource numberOfItemsforGallery:self]-1)
	{
		++currentIndex;
		[scroll setContentOffset:CGPointMake(currentIndex * scroll.frame.size.width,0) animated:animated];
		[self currentIndexChanged];
	} else {
		[self destroyTimer];
	}

}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////

- (void)startTimer {
	if (!slideshowTimer) {
		slideshowTimer = [[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(slideshowTimerFired:) userInfo:nil repeats:YES] retain];

		NSDate *now = [NSDate date];
		NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:[now timeIntervalSince1970]+2.0];
		[slideshowTimer setFireDate:newDate];
		[[NSRunLoop currentRunLoop] addTimer:slideshowTimer forMode:NSRunLoopCommonModes];
	}
}

- (void)destroyTimer {
	if ([slideshowTimer isValid]) {
		[slideshowTimer invalidate];
	}

	[slideshowTimer release];
	slideshowTimer = nil;
}

- (IBAction) forwardButtonPressed:(id) sender
{
	[self goNext:YES];
}

- (void)slideshowTimerFired:(NSTimer *)timer {
//	PhotoDebugLog(@"timer Fired");
//	PhotoDebugLog(@"currentIndex: %d",currentIndex);
	CATransition *transition = [CATransition animation];
	transition.type = kCATransitionFade;
	[scroll.layer addAnimation:transition forKey:nil];
	[self goNext:NO];
}

- (IBAction)playButtonPressed:(id)sender {
	[self toggleTools];
	[self startTimer];
}

///////////////////////////////////////////
//
///////////////////////////////////////////
- (IBAction) back:(id) sender
{
	//[self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) toggleTools
{
	if (toolsShowing)
	{
		[self hideTools];
	}
	else 
	{
		[self showTools];
	}				
}

#if 0
////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) touchableScrollView:(UIXGalleryTouchableScrollView*) touchableScrollView touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event;
{
	if ([touches count] == 1)
	{	 
		UITouch* touch = [touches anyObject];
		
		switch (touch.tapCount)
		{
			case 1:
			{
				[self performSelector:@selector(toggleTools) withObject:nil  afterDelay:.3];
			}
				break;

			case 2:
			{
				UIXGalleryCell* sv = (UIXGalleryCell*) [scroll viewWithTag:(currentIndex) + 9900];

				[UIView beginAnimations:@"scalechange" context:nil];
				if (sv.zoomScale != 1.0)
				{
					sv.zoomScale = 1.0;
				}
				else 
				{
					sv.zoomScale = 2.0;
				}
				[UIView commitAnimations];
			}
				break;
		}
		
	}
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) touchableScrollView:(UIXGalleryTouchableScrollView*) touchableScrollView touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event
{
}
#endif 

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (id<UIXGalleryDatasource>) datasource
{
	return datasource;
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) setphotoCollection:(id<UIXGalleryDatasource>) g
{
	datasource = g;
}

///////////////////////////////////////
//
///////////////////////////////////////
- (void) scrollViewDidEndDecelerating:(UIScrollView*) scrollView 
{
	int newIndex = floor((scroll.contentOffset.x - scroll.frame.size.width / 2) / scroll.frame.size.width)+1;
	if (currentIndex != newIndex) {
		currentIndex = newIndex;
		[self currentIndexChanged];
	}
}

///////////////////////////////////////
//
///////////////////////////////////////
- (void) cellTapped:(NSNotification*) notification
{
	[self destroyTimer];
	[self performSelector:@selector(toggleTools) withObject:nil  afterDelay:.3];
}
@end
