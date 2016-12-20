//
//  jpBookDetailViewController.h
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPBook+CoreDataClass.h"

@interface jpBookDetailViewController : UIViewController

@property (strong, nonatomic) JPBook *book;

@end
