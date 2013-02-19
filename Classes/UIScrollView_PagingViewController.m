//
//  UIScrollView_PagingViewController.m
//  UIScrollView-Paging
//
//  Created by Costa Walcott on 3/2/11.
//  Copyright 2011 Draconis Software. All rights reserved.
//

#import "UIScrollView_PagingViewController.h"

@implementation UIScrollView_PagingViewController


@synthesize scrollView, pageControl, imagesArray, currentIndex;


// Before pushing the view controller create view controller with this init method and pass the
// array of image urls as an array to this and the index of the image which u want to show

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil imageArray:(NSArray*)images withIndex:(NSUInteger)index
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imagesArray = [NSArray arrayWithArray:images];
        currentIndex = index;
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
// Here before pushing this view controller 
- (void)viewDidLoad {
    [super viewDidLoad];
	
	pageControlBeingUsed = NO;
	
    NSArray *images = [NSArray arrayWithObjects:@"CuriousFrog.jpg",@"LeggyFrog.jpg",@"PeeringFrog.jpg", nil];
    for (int i = 0; i < images.count; i++) {
		CGRect frame;
		frame.origin.x = self.scrollView.frame.size.width * i;
		frame.origin.y = 0;
		frame.size = self.scrollView.frame.size;
		
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[images objectAtIndex:i]];
        
// Uncomment this line when you want to show the images having urls in the array
        
//        [imageView setImageWithURL:[NSURL URLWithString:[[imagesArray objectAtIndex:i]objectForKey:@"url"]]];
        
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
		[self.scrollView addSubview:imageView];
		[imageView release];
	}
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * images.count, self.scrollView.frame.size.height);

//  Uncomment these lines when you want to show the clicked image as first image
    
//    self.pageControl.currentPage = currentIndex;
//    CGRect frame;
//	frame.origin.x = self.scrollView.frame.size.width * currentIndex;
//	frame.origin.y = 0;
//	frame.size = self.scrollView.frame.size;
//	[self.scrollView scrollRectToVisible:frame animated:NO];
	
	self.pageControl.currentPage = 2;
	self.pageControl.numberOfPages = images.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.scrollView = nil;
	self.pageControl = nil;
}


- (void)dealloc {
	[scrollView release];
	[pageControl release];
    [super dealloc];
}

@end
