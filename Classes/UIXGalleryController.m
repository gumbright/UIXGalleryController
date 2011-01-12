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
    }
    return self;
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) displayImage:(UIImage*) img
{
	if (imageView == nil)
	{
		imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		imageView.tag = 9700;
		[self addSubview:imageView];
		[imageView release];		
	}

	imageView.image = img;
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) displayGalleryItem:(NSObject<UIXGalleryItem>*) obj
{
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
	
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	UIImage* img = [change objectForKey:NSKeyValueChangeNewKey];
	if (busyView != nil)
	{
		[busyView removeFromSuperview];
		busyView = nil;
	}
	
	[self displayImage:img];
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
	//http://www.cimgf.com/2010/06/14/differentiating-tap-counts-on-ios/
	
	if ([touches count] == 1)
	{	 
		UITouch* touch = [touches anyObject];
		
		switch (touch.tapCount)
		{				
			case 1:
			{
				NSLog(@"single");
				[self performSelector:@selector(signalSingleTap:) withObject:nil afterDelay:0.30];
				//[[NSNotificationCenter defaultCenter] postNotificationName:UIXGALLERY_SINGLETAP_NOTIFICATION object:self];
			}
				break;

			case 2:
			{
				NSLog(@"double");
				
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
	[imageView removeFromSuperview];
	imageView = nil;
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
	
	UIScrollView* tsv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	tsv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tsv.pagingEnabled = YES;
	tsv.delegate = self;
	[v addSubview:tsv];
	scroll = tsv;
	[tsv release];
	
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
	toolbar.barStyle = UIBarStyleBlack;
	toolbar.translucent = YES;
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
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
		
	CATransition* trans = [CATransition animation];
	trans.type = kCATransitionFade;
	trans.duration = 2.0;

	[[self.view layer] addAnimation:trans forKey:nil];
	
	//yes 5 is theoratically more than we need, but if I have a timing issue and it is aleviated by always having
	//something available in the pool, I can prevent the crash which is the worse evil
	galleryCellPool = [[NSMutableSet setWithCapacity:5] retain];
	
	for (int x = 0; x < 5; ++x)
	{
		UIXGalleryCell* cell = [[UIXGalleryCell alloc] init];
		[galleryCellPool addObject:cell];
		[cell release];
	}
	
	CGSize sz = CGSizeMake(scroll.frame.size.width * [datasource numberOfItemsforGallery:self],scroll.frame.size.height);
	scroll.contentSize = sz;
	
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
	self.navigationItem.title = [NSString stringWithFormat:@"%d of %d",currentIndex+1,[datasource numberOfItemsforGallery:self]];

	//
	//remove any views more than 1 away from current
	//
	if ((currentIndex - 2) >= 0)
	{
		UIXGalleryCell* sv = (UIXGalleryCell*) [scroll viewWithTag:(currentIndex - 2) + 9900];
		if (sv != nil)
		{
			[[sv retain] removeFromSuperview];
			[sv clear];
			sv.tag = 0;
			[galleryCellPool addObject:sv];
			[sv release];
		}
	}
	
	if ((currentIndex + 2) < [datasource numberOfItemsforGallery:self])
	{
		UIXGalleryCell* sv = (UIXGalleryCell*) [scroll viewWithTag:(currentIndex + 2) + 9900];
		if (sv != nil)
		{
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
	if (currentIndex > 0 && [scroll viewWithTag:(currentIndex-1)+9900] == nil) //do left
	{
		UIXGalleryCell* sv = [[galleryCellPool anyObject] retain];
		
		[galleryCellPool removeObject:sv];
		sv.tag = (currentIndex - 1) + 9900;
		
		CGRect frame = sv.frame;
		frame.origin.y = 0;
		frame.origin.x = scroll.frame.size.width * (currentIndex - 1);
		frame.size.width = scroll.frame.size.width;
		frame.size.height = scroll.frame.size.height;
		sv.frame = frame;
		[scroll addSubview:sv];
		[scroll sendSubviewToBack:sv];
		[sv release];
	}
	
	if (currentIndex < [datasource numberOfItemsforGallery:self]-1 &&  [scroll viewWithTag:(currentIndex+1)+9900] == nil) //do right
	{
		UIXGalleryCell* sv = [[galleryCellPool anyObject] retain];
		[galleryCellPool removeObject:sv];

		sv.tag = (currentIndex + 1) + 9900;
//		NSLog(@"added view tagged %d",iv.tag);
		
		CGRect frame = sv.frame;
		frame.origin.y = 0;
		frame.origin.x = scroll.frame.size.width * (currentIndex + 1);
		frame.size.width = scroll.frame.size.width;
		frame.size.height = scroll.frame.size.height;
		sv.frame = frame;
		[scroll addSubview:sv];
		[scroll sendSubviewToBack:sv];
		[sv release];
	}
	
	//
	// set up the current
	//
	if ([scroll viewWithTag:currentIndex + 9900] == nil)
	{
		UIXGalleryCell* sv = [[galleryCellPool anyObject] retain];
		[galleryCellPool removeObject:sv];
		sv.tag = currentIndex + 9900;
	
		CGRect frame = sv.frame;
		frame.origin.y = 0;
		frame.origin.x = scroll.frame.size.width * currentIndex;
		frame.size.width = scroll.frame.size.width;
		frame.size.height = scroll.frame.size.height;
		sv.frame = frame;
		[scroll addSubview:sv];
		[scroll sendSubviewToBack:sv];
		[sv release];
	}
	
	//
	// make sure image is loaded for each
	//
	for (NSInteger ndx = 0; ndx < 3; ++ndx)
	{

		NSInteger photoNdx = (currentIndex - 1) + ndx;
		
		if (photoNdx < 0 || photoNdx >= [datasource numberOfItemsforGallery:self])
		{
			continue;
		}
		
		UIXGalleryCell* sv = (UIXGalleryCell*) [scroll viewWithTag:(currentIndex - 1) + ndx+9900];
//		NSLog(@"iv #%d size: %@",(currentIndex - 1) + ndx,NSStringFromCGSize(iv.frame.size));

		if (sv.item == nil && sv.imageView == nil)
		{
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
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//resize and reposition the images

	CGRect frame;	
	
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

//	[toolbar release];
	
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
