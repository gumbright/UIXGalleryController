//
//  UIXGalleryViewController.m
//  UIXGallery
//
//  Created by gumbright on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIXGalleryViewController.h"
#import "UIXGalleryController.h"

@implementation UIXGalleryViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

	datasource = [[GalleryDatasource alloc] init];
}


- (void) viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBar.translucent = NO;
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction) galleryPressed:(id) sender
{
	UIXGalleryController* vc = [[UIXGalleryController alloc] init];
	vc.datasource = datasource;
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentModalViewController:nc animated:YES];
	[vc release];
    [nc release];
}

@end
