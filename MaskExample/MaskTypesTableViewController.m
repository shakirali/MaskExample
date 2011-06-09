//
//  MaskTypeViewController.m
//  MaskExample
//
//  Created by Shakir Ali on 05/06/2011.
//  Copyright 2011 University of Edinburgh. All rights reserved.
//

#import "MaskTypesTableViewController.h"
#import "ColorMaskViewController.h"
#import "ImageMaskViewController.h"
#import "ReflectedImageViewController.h"
#import "MaskWithImageViewController.h"

@interface MaskTypesTableViewController () 
-(void)displayColorMaskViewController;
-(void)displayImageMaskViewController;
-(void)displayReflectedImageViewController;
-(void)displayMaskWithImageViewController;
@end

@implementation MaskTypesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Examples",nil);
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Image Masking",nil);
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"Masking with image", nil);
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"Color Masking",nil);
            break;    
        case 3:
            cell.textLabel.text = NSLocalizedString(@"CGContextClipToMask", nil);
        default:
            break;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            [self displayImageMaskViewController];
            break;
        case 1:
            [self displayMaskWithImageViewController];
            break;
        case 2:
            [self displayColorMaskViewController];
            break;
        case 3:
            [self displayReflectedImageViewController];
            break;
        default:
            break;
    }

}

-(void)displayColorMaskViewController{
    ColorMaskViewController* colorMaskViewController;
    colorMaskViewController = [[ColorMaskViewController alloc] init];
    [self.navigationController pushViewController:colorMaskViewController animated:YES];
    [colorMaskViewController release];
}

-(void)displayImageMaskViewController{
    ImageMaskViewController* imageMaskViewController;
    imageMaskViewController = [[ImageMaskViewController alloc] init];
    [self.navigationController pushViewController:imageMaskViewController animated:YES];
    [imageMaskViewController release];
}

-(void)displayReflectedImageViewController{
    ReflectedImageViewController* reflectedImageViewController;
    reflectedImageViewController = [[ReflectedImageViewController alloc] init];
    [self.navigationController pushViewController:reflectedImageViewController animated:YES];
    [reflectedImageViewController release];
}

-(void)displayMaskWithImageViewController{
    MaskWithImageViewController* maskWithImageViewController;
    maskWithImageViewController = [[MaskWithImageViewController alloc] init];
    [self.navigationController pushViewController:maskWithImageViewController animated:YES];
    [maskWithImageViewController release];
}


@end
