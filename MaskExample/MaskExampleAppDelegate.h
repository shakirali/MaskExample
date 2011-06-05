//
//  MaskExampleAppDelegate.h
//  MaskExample
//
//  Created by Shakir Ali on 05/06/2011.
//  Copyright 2011 University of Edinburgh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MaskExampleViewController;

@interface MaskExampleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MaskExampleViewController *viewController;

@end
