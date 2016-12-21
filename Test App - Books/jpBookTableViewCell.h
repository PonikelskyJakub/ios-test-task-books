//
//  jpBookTableViewCell.h
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPBook+CoreDataClass.h"


@interface jpBookTableViewCell : UITableViewCell

@property (strong, nonatomic) JPBook *book;

- (void) setReadedButtonTitle;
- (void) setLayout;

@end
