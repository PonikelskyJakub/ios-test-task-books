//
//  jpBookTableViewCell.m
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import "jpBookTableViewCell.h"
#import "BooksDataObject.h"

@implementation jpBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)readedButtonTouchUp:(id)sender {
    self.book.readed = !self.book.readed;
    [self setReadedButtonTitle];
}

- (void) setReadedButtonTitle{
    if(self.book.readed){
        [self.readedButton setTitle:NSLocalizedString(@"BOOK_MARK_READED", @"Readed book button title") forState:UIControlStateNormal];
    }
    else{
        [self.readedButton setTitle:NSLocalizedString(@"BOOK_MARK_UNREADED", @"Unreaded book button title") forState:UIControlStateNormal];
    }
}


@end
