//
//  ReflectedImageViewController.m
//  MaskExample
//
//  Created by Shakir Ali on 05/06/2011.
//  Copyright 2011 University of Edinburgh. All rights reserved.
//

#import "ReflectedImageViewController.h"

@interface ReflectedImageViewController ()
@property (retain) UIImageView* imageView;
@property (retain) UIImageView* reflectedImageView;

-(void)initImageView;
-(void)initReflectedImageView;
- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height;

@end

@implementation ReflectedImageViewController

#define reflectionFraction 0.5

@synthesize imageView;
@synthesize reflectedImageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView* view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	self.view = view;
	[view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//initialize main image view
	[self initImageView];
	//initialize reflected image view.
	[self initReflectedImageView];
}

//initialize main image view.
-(void)initImageView{
	//load image
    UIImage* image = [UIImage imageNamed:@"bus"];
	CGRect imageViewFrame;
	imageViewFrame.size = image.size;
	imageViewFrame.origin = CGPointMake((self.view.frame.size.width - image.size.width) / 2 , (self.view.frame.size.height - image.size.height) / 2);
	imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
	imageView.image = image;
	[self.view addSubview:imageView];
}

//initialize reflected image view.
-(void)initReflectedImageView{
	// create the reflection view
	CGRect reflectionRect=self.imageView.frame;
	
	// determine the size of the reflection to create. The reflection is a fraction of the size of the view being reflected
	NSUInteger reflectionHeight=self.imageView.bounds.size.height* reflectionFraction;
	
	// the reflection is a fraction of the size of the view being reflected
	reflectionRect.size.height= reflectionHeight;
	
	// and is offset to be at the bottom of the view being reflected
	reflectionRect=CGRectOffset(reflectionRect,0,self.imageView.frame.size.height);
	
	reflectedImageView = [[UIImageView alloc] initWithFrame:reflectionRect];
	
	// create the reflection image, assign it to the UIImageView and add the image view to the containerView
	reflectedImageView.image=[self reflectedImage:imageView withHeight:reflectionHeight];
    
	[self.view addSubview:reflectedImageView];
}

CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
	CGImageRef theCGImage = NULL;
    
	// gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	// create the bitmap context
	CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
															   8, 0, colorSpace, kCGImageAlphaNone);
	
  
    // define the start and end grayscale values (with the alpha, even though
	// our bitmap context doesn't support alpha the gradient requires it)
	CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
	
	// create the CGGradient and then release the gray color space
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGColorSpaceRelease(colorSpace);
	
	// create the start and end points for the gradient vector (straight down)
	CGPoint gradientStartPoint = CGPointZero;
	CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
	
	// draw the gradient into the gray bitmap context
	CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
								gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// convert the context into a CGImageRef and release the context
	theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
	CGContextRelease(gradientBitmapContext);
	
	// return the imageref containing the gradient
    return theCGImage;
}

CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create the bitmap context
	CGContextRef bitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
														0, colorSpace,
														// this will give us an optimal BGRA format for the device:
														(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}


- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height
{
    if(height == 0)
		return nil;
    
	// create a bitmap graphics context the size of the image
	CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the 
	// main view content to create the 'fade' of the reflection.  The CGContextClipToMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = CreateGradientImage(1, height);
	
	// create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
	CGImageRelease(gradientMaskImage);
	
	// In order to grab the part of the image that we want to render, we move the context origin to the
	// height of the image that we want to capture, then we flip the context so that the image draws upside down.
	CGContextTranslateCTM(mainViewContentContext, 0.0, height);
	CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);
	
	// draw the image into the bitmap context
	CGContextDrawImage(mainViewContentContext, fromImage.bounds, fromImage.image.CGImage);
	
	// create CGImageRef of the main view bitmap content, and then release that bitmap context
	CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	// convert the finished reflection image to a UIImage 
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	
	// image is retained by the property setting above, so we can release the original
	CGImageRelease(reflectionImage);
	
	return theImage;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.reflectedImageView = nil;
}

- (void)dealloc
{
    [super dealloc];
    self.imageView = nil;
    self.reflectedImageView = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
