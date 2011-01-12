//
//  GalleryDatasource.m
//  UIXGallery
//
//  Created by gumbright on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GalleryDatasource.h"
#import "DatasourceItem.h"
#import "DelayedDatasourceItem.h"

@implementation GalleryDatasource

@synthesize connection;

///////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////
- (NSUInteger) numberOfItemsforGallery:(UIXGalleryController*) gallery
{
	return 4;
}

///////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////
- (id<UIXGalleryItem>) gallery:(UIXGalleryController*) gallery itemAtIndex:(NSUInteger) index
{
	DatasourceItem* dsi = nil;
	
	switch (index) 
	{
		case 0:
		{
			UIImage* img = [UIImage imageNamed:@"image0.jpg"];
			dsi = [[[DatasourceItem alloc] initWithImage:img] autorelease];
		}
			break;
			
		case 1:
		{
			UIImage* img = [UIImage imageNamed:@"image1.jpg"];
			dsi = [[[DelayedDatasourceItem alloc] initWithImage:img] autorelease];
			
//			NSString* uri = @"http://4.bp.blogspot.com/_M53GsEHCIsU/S9pSc4Wgl3I/AAAAAAAACIo/Ew_P0EEPSaQ/s1600/Karen-Gillan-001.jpg";
//			[self requestImage:uri];
			
		}
			break;
			
		case 2:
		{
			UIImage* img = [UIImage imageNamed:@"image2.png"];
			dsi = [[[DatasourceItem alloc] initWithImage:img] autorelease];
		}
			break;

		case 3:
		{
			UIImage* img = [UIImage imageNamed:@"image3.jpg"];
			dsi = [[[DatasourceItem alloc] initWithImage:img] autorelease];
		}
			break;
			
		default:
			break;
	}
	
	return dsi;
}

- (UIView*) gallery:(UIXGalleryController*) gallery busyViewForItemAtIndex:(NSUInteger) index
{
	UIActivityIndicatorView* v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[v startAnimating];
	return [v autorelease];
}

#if 0
- (void) requestImage:(NSString*) uri
{
	NSURL* url = [NSURL URLWithString:uri];
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	
	NSURLConnection* newConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	self.connection = newConnection;
	[newConnection release];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)urlConnection didReceiveResponse:(NSURLResponse *)urlResponse
{
	statusCode = 0;
	if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]])
	{
		self.response = (NSHTTPURLResponse*)urlResponse;
		statusCode = self.response.statusCode;
	}
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)urlConnection didReceiveData:(NSData *)data
{
	[self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)urlConnection
{
	DebugLog(@"  OK: %@ %@ (%d %@)", self.request.HTTPMethod,
			 self.request.URL.absoluteString,
			 self.response.statusCode,
			 [NSHTTPURLResponse localizedStringForStatusCode:self.response.statusCode]);
	[self networkActivityEnded];
	
	// This ensures that we always have some sort of error title and message.
	// This allows consumers to just display an error dialog if the expected result didn't occur
	self.errorTitle = NSLocalizedString(@"UnexpectedErrorAlertTitle", nil);
	self.errorMessage = [NSString stringWithFormat:NSLocalizedString(@"UnexpectedErrorWithCodeAlertMessage", nil), self.statusCode];
}

- (void)connection:(NSURLConnection *)urlConnection didFailWithError:(NSError *)connectionError
{
	self.error = connectionError;
	DebugLog(@"FAIL: %@ %@ (%@)", self.request.HTTPMethod, self.request.URL.absoluteString, [self.error localizedDescription]);
	[self networkActivityEnded];
	
	self.errorTitle = NSLocalizedString(@"UnexpectedErrorAlertTitle", nil);
	
	if (self.error != nil)
	{
		self.errorMessage = [NSString stringWithFormat:NSLocalizedString(@"UnexpectedErrorWithCodeAlertMessage", nil), self.error.code];
		if (self.error.domain == NSURLErrorDomain)
		{
			switch (self.error.code)
			{
				case NSURLErrorNotConnectedToInternet:
				{
					self.errorTitle = NSLocalizedString(@"NoConnectionAlertTitle", nil);
					self.errorMessage = NSLocalizedString(@"NoConnectionAlertMessage", nil);
				}
					break;
					
				case NSURLErrorTimedOut:
				{
					self.errorTitle = NSLocalizedString(@"TimedOutAlertTitle", nil);
					self.errorMessage = NSLocalizedString(@"TimedOutAlertMessage", nil);
				}
					break;
					
				default:
					break;
			}
		}
	}
	else
	{
		self.errorMessage = NSLocalizedString(@"UnexpectedErrorAlertMessage", nil);
	}
}
#endif
@end
