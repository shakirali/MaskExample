//
//  ImageMaskViewController.m
//  MaskExample
//
//  Created by Shakir Ali on 05/06/2011.
//  Copyright 2011 University of Edinburgh. All rights reserved.
//

#import "ImageMaskViewController.h"

@interface ImageMaskViewController ()
-(void)initOriginalImageViewWithImage:(UIImage*)originalImage;
-(void)initMaskImageViewWithImage:(UIImage*)originalImage;
@end

@implementation ImageMaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage* originalImage = [UIImage imageNamed:@"bus"];
    [self initOriginalImageViewWithImage:originalImage];
    [self initMaskImageViewWithImage:originalImage];
}

UIImage* getGrayScaleImage(UIImage* originalImage){
     
    //image bounds
    CGRect imageBounds = CGRectMake(0.0, 0.0, originalImage.size.width, originalImage.size.height);
	//create gray device colorspace.
	CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
	//create 8-bit bimap context without alpha channel.
	CGContextRef bitmapContext = CGBitmapContextCreate(NULL, originalImage.size.width, originalImage.size.height, 8, 0, space, kCGImageAlphaNone);
    CGColorSpaceRelease(space);
    
    //Draw a rectangle with white background.
    CGContextSetFillColorWithColor(bitmapContext, [UIColor whiteColor].CGColor);
    CGContextBeginPath(bitmapContext);
    CGContextAddRect(bitmapContext, imageBounds);
    CGContextDrawPath(bitmapContext, kCGPathFill);
    
    //Draw an ellipse in a with black background.
    CGContextSetFillColorWithColor(bitmapContext, [UIColor blackColor].CGColor);
    CGContextBeginPath(bitmapContext);
    //take a smaller rectangle then the whole image.
    CGContextAddEllipseInRect(bitmapContext, CGRectInset(imageBounds, 10, 10));
    CGContextDrawPath(bitmapContext, kCGPathFill);
    
    //Get image from bimap context.
	CGImageRef grayScaleImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	//image is inverted. UIImage inverts orientation while converting CGImage to UIImage. 
	UIImage* image = [UIImage imageWithCGImage:grayScaleImage];
	CGImageRelease(grayScaleImage);
	return image;
}

-(void)initOriginalImageViewWithImage:(UIImage*)originalImage{
    //init original image view.
	UIImageView* originalImageView = [[UIImageView alloc] initWithImage:originalImage];
	CGRect frame = originalImageView.frame;
	frame.origin = CGPointMake((self.view.frame.size.width - frame.size.width) / 2, 10.0);
	originalImageView.frame = frame;
	[self.view addSubview:originalImageView];
	[originalImageView release];
}

-(void)initMaskImageViewWithImage:(UIImage*)originalImage{
    //create colored mask image.
    UIImage* grayScaleImage = getGrayScaleImage(originalImage);
    
    CGFloat width = CGImageGetWidth(grayScaleImage.CGImage);
    CGFloat height = CGImageGetHeight(grayScaleImage.CGImage);
    CGFloat bitsPerPixel = CGImageGetBitsPerPixel(grayScaleImage.CGImage);
    CGFloat bytesPerRow = CGImageGetBytesPerRow(grayScaleImage.CGImage);
    CGDataProviderRef providerRef = CGImageGetDataProvider(grayScaleImage.CGImage);
    
    CGImageRef imageMask = CGImageMaskCreate(width, height, 8, bitsPerPixel, bytesPerRow, providerRef, NULL, false);
    
    CGImageRef maskedImage = CGImageCreateWithMask(originalImage.CGImage, imageMask);
    CGImageRelease(imageMask);
    UIImage* image = [UIImage imageWithCGImage:maskedImage];
    CGImageRelease(maskedImage);
        
    //create image view and set its poistion.
    UIImageView* maskImageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = maskImageView.frame;
    frame.origin = CGPointMake((self.view.frame.size.width - frame.size.width) / 2 , (self.view.frame.size.height - frame.size.height) /2 );
    maskImageView.frame = frame;
    
    [self.view addSubview:maskImageView];
    [maskImageView release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
