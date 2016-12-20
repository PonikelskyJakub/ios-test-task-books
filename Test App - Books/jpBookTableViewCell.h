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
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *readedButton;

- (void) setReadedButtonTitle;

@end
