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

#define CELL_POOL_SIZE 3
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
		self.maximumZoomScale = 2;
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
		imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
		item = [obj retain];
		[item addObserver:self 
			   forKeyPath:@"image" 
				  options:NSKeyValueObservingOptionNew
				  context:nil];
	}
	else 
	{
		[self displayImage:img];
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
	if (busyView != nil)
	{
//		NSLog(@"remove busy");
		[busyView removeFromSuperview];
		busyView = nil;
	}
	
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
	if (busyView != nil)
	{
		[busyView removeFromSuperview];
	}
	
	//rect to center view
	CGRect frame = v.bounds;
	
	frame.origin.x = (self.bounds.size.width - v.bounds.size.width) / 2; 
	frame.origin.y = (self.bounds.size.height - v.bounds.size.height) / 2;
	
	v.frame = frame;
	
	[self addSubview:v];
	busyView = v;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIXGalleryController

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
	}	
	
	return self;
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) loadView
{
	UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	v.opaque = YES;
	
	scroll = [[UIScrollView alloc] initWithFrame:v.bounds];
	scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scroll.pagingEnabled = YES;
	scroll.delegate = self;
	scroll.opaque = YES;
	[v addSubview:scroll];
	[scroll release];
	
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
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
	
	[toolbar setItems:[NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																						  target:nil 
																						  action:nil] autorelease],
				  backButton,
				  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
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
		
//	CATransition* trans = [CATransition animation];
//	trans.type = kCATransitionFade;
//	trans.duration = 2.0;
//
//	[[self.view layer] addAnimation:trans forKey:nil];
	
	//yes 5 is theoratically more than we need, but if I have a timing issue and it is aleviated by always having
	//something available in the pool, I can prevent the crash which is the worse evil
	galleryCellPool = [[NSMutableSet setWithCapacity:CELL_POOL_SIZE] retain];
	
	CGSize sz = CGSizeMake(scroll.frame.size.width * [datasource numberOfItemsforGallery:self],scroll.frame.size.height);
	scroll.contentSize = sz;
	
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) recycleCell:(UIXGalleryCell*) cell
{
	//just let it autorelease if we are full
	
	if ([galleryCellPool count] < CELL_POOL_SIZE)
	{
		[cell clear];
		[galleryCellPool addObject:cell];
	}
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (UIXGalleryCell*) getCell
{
	UIXGalleryCell* cell;
	
	if ([galleryCellPool count] != 0)
	{
		cell = [[galleryCellPool anyObject] retain];
		[galleryCellPool removeObject:cell];
		[cell autorelease];
	}
	else 
	{
		cell = [[[UIXGalleryCell alloc] init] autorelease];
	}

	return cell;
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

//	toolbar.items = items;
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
//	NSLog(@"currentIndexChange start");
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
//			NSLog(@"removing cell %d",sv.tag);
			[[sv retain] removeFromSuperview];
//			[sv clear];
			sv.tag = 0;
//			[galleryCellPool addObject:sv];
			[self recycleCell:sv];
			[sv release];
		}
	}
	
	if ((currentIndex + (PRELOAD_SIZE+1)) < [datasource numberOfItemsforGallery:self])
	{
		sv = (UIXGalleryCell*) [scroll viewWithTag:(currentIndex + (PRELOAD_SIZE+1)) + 9900];
		if (sv != nil)
		{
//			NSLog(@"removing cell %d",sv.tag);
			[[sv retain] removeFromSuperview];
//			[sv clear];
			sv.tag = 0;
			[self recycleCell:sv];
//			[galleryCellPool addObject:sv];
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
			sv = [self getCell];
//			sv = [[galleryCellPool anyObject] retain];
//			
//			[galleryCellPool removeObject:sv];
			sv.tag = (currentIndex - ndx) + 9900;
			
			CGRect frame = sv.frame;
			frame.origin.y = 0;
			frame.origin.x = scroll.frame.size.width * (currentIndex - ndx);
			frame.size.width = scroll.frame.size.width;
			frame.size.height = scroll.frame.size.height;
			sv.frame = frame;
//			NSLog(@"adding cell %d",sv.tag);
			[scroll addSubview:sv];
			[scroll sendSubviewToBack:sv];
//			[sv release];
		}
	}
	
	for (int ndx=1; ndx <= PRELOAD_SIZE; ndx++)
	{	
		if (currentIndex < [datasource numberOfItemsforGallery:self]-1 &&  [scroll viewWithTag:(currentIndex+ndx)+9900] == nil) //do right
		{
			sv = [self getCell];
//			sv = [[galleryCellPool anyObject] retain];
//			[galleryCellPool removeObject:sv];

			sv.tag = (currentIndex + ndx) + 9900;
			
			CGRect frame = sv.frame;
			frame.origin.y = 0;
			frame.origin.x = scroll.frame.size.width * (currentIndex + ndx);
			frame.size.width = scroll.frame.size.width;
			frame.size.height = scroll.frame.size.height;
			sv.frame = frame;
//			NSLog(@"adding cell %d",sv.tag);
			[scroll addSubview:sv];
			[scroll sendSubviewToBack:sv];
//			[sv release];
		}
	}
	
	//
	// set up the current
	//
	if ([scroll viewWithTag:currentIndex + 9900] == nil)
	{
		sv = [self getCell];
//		sv = [[galleryCellPool anyObject] retain];
//		[galleryCellPool removeObject:sv];
		sv.tag = currentIndex + 9900;
	
		CGRect frame = sv.frame;
		frame.origin.y = 0;
		frame.origin.x = scroll.frame.size.width * currentIndex;
		frame.size.width = scroll.frame.size.width;
		frame.size.height = scroll.frame.size.height;
		sv.frame = frame;
//		NSLog(@"adding cell %d",sv.tag);
		[scroll addSubview:sv];
		[scroll sendSubviewToBack:sv];
//		[sv release];
	}
	
	//
	// make sure image is loaded for each
	//
	for (NSInteger ndx = 0; ndx < (PRELOAD_SIZE*2)+1; ++ndx)
	{
		NSInteger photoNdx = (currentIndex - 1) + ndx;

//		NSLog(@"update %d",photoNdx);
		if (photoNdx < 0 || photoNdx >= [datasource numberOfItemsforGallery:self])
		{
			continue;
		}
		
		sv = (UIXGalleryCell*) [scroll viewWithTag:(currentIndex - 1) + ndx+9900];

		if (sv.item == nil && sv.imageView.image == nil)
		{
//			NSLog(@"%d needs image",photoNdx);
			
			NSObject<UIXGalleryItem>* item = [datasource gallery:self itemAtIndex: photoNdx];

			if (ndx !=1) //its the center
			{
				sv.zoomScale = 1.0;
			}	

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

//	NSLog(@"currentIndexChange end");
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
    return YES;
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	CGRect frame;

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
	
	self.view.frame = frame;
	
	scroll.contentSize = CGSizeMake(scroll.frame.size.width * [datasource numberOfItemsforGallery:self], scroll.frame.size.height);
	scroll.contentOffset = CGPointMake(scroll.frame.size.width * currentIndex, 0);
	for (int ndx = 1; ndx > -2; --ndx)
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
	}
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void) viewWillAppear:(BOOL) animated 
{
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
	[galleryCellPool release]; galleryCellPool = nil;
	[forwardButton release]; forwardButton = nil;
	[backButton release]; backButton = nil;

	[toolbar release]; toolbar = nil;
	
	[super viewDidUnload];
}

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[galleryCellPool release];
	
	self.datasource = nil;
	
	[forwardButton release];
	[backButton release];

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

////////////////////////////////////////////////////
//
////////////////////////////////////////////////////
- (IBAction) forwardButtonPressed:(id) sender
{
	if (currentIndex < [datasource numberOfItemsforGallery:self]-1)
	{
		++currentIndex;
		[scroll setContentOffset:CGPointMake(currentIndex * scroll.frame.size.width,0) animated:YES];
		[self currentIndexChanged];
	}
}


///////////////////////////////////////////
//
///////////////////////////////////////////
- (IBAction) back:(id) sender
{
	[self.navigationController popViewControllerAnimated:YES];
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
	[(NSObject*)datasource release];
	datasource = [(NSObject*)g retain];
}

///////////////////////////////////////
//
///////////////////////////////////////
- (void) scrollViewDidEndDecelerating:(UIScrollView*) scrollView 
{
	currentIndex = floor((scroll.contentOffset.x - scroll.frame.size.width / 2) / scroll.frame.size.width)+1;

	[self currentIndexChanged];
}

///////////////////////////////////////
//
///////////////////////////////////////
- (void) cellTapped:(NSNotification*) notification
{
	[self performSelector:@selector(toggleTools) withObject:nil  afterDelay:.3];
}
@end
