//
//  ColorMaskViewController.m
//  MaskExample
//
//  Created by Shakir Ali on 05/06/2011.
//  Copyright 2011 University of Edinburgh. All rights reserved.
//

#import "ColorMaskViewController.h"

@interface ColorMaskViewController ()
-(void)initOriginalImageViewWithImage:(UIImage*)originalImage;
-(void)initColorMaskImageViewWithImage:(UIImage*)originalImage;
@end

@implementation ColorMaskViewController

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
    [self initColorMaskImageViewWithImage:originalImage];

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


UIImage* createColorMaskedImage(UIImage* originalImage){
    
    //range of mask colors in the format min[0], max[0], min[1], max[1]...
    float maskingColors[6] = {0, 100, 150, 255 , 0, 100};
    
    //mask original image with mask colors.
    CGImageRef maskedImageRef = CGImageCreateWithMaskingColors(originalImage.CGImage, maskingColors);
    
    //wrap it with UIImage.
    UIImage* maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    CGImageRelease(maskedImageRef);
    return maskedImage;
}

-(void)initColorMaskImageViewWithImage:(UIImage*)originalImage{
    //create colored mask image.
    UIImage* colorMaskImage = createColorMaskedImage(originalImage);
    
    //create image view and set its poistion.
    UIImageView* maskImageView = [[UIImageView alloc] initWithImage:colorMaskImage];
    CGRect frame = maskImageView.frame;
    frame.origin = CGPointMake((self.view.frame.size.width - frame.size.width) / 2 , (self.view.frame.size.height - frame.size.height) /2 );
    maskImageView.frame = frame;
    //set background color
    maskImageView.backgroundColor = [UIColor clearColor];
    maskImageView.backgroundColor = [UIColor blueColor];
        
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
