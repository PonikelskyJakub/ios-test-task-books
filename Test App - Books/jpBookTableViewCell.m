//
//  jpBookTableViewCell.m
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import "jpBookTableViewCell.h"
#import "BooksDataObject.h"

@interface jpBookTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *readedButton;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end


@implementation jpBookTableViewCell

- (IBAction)readedButtonTouchUp:(id)sender {
    self.book.readed = !self.book.readed;
    [self setReadedButtonTitle];
}

- (void) setReadedButtonTitle{
    if(self.book.readed){
        [self.readedButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.readedButton setTitle:NSLocalizedString(@"BOOK_MARK_READED", @"Readed book button title") forState:UIControlStateNormal];
    }
    else{
        [self.readedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.readedButton setTitle:NSLocalizedString(@"BOOK_MARK_UNREADED", @"Unreaded book button title") forState:UIControlStateNormal];
    }
}

- (void) setLayout{
    self.nameLabel.text = self.book.title;
    [self setReadedButtonTitle];
    [self loadPreviewImage];
}

- (void) loadPreviewImage{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.book.smallImageUrl]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if(self.previewImageView){
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              UIImage* image = [UIImage imageWithData:data];
                                              self.previewImageView.image = image;
                                          });
                                      }
                                  }];
    [task resume];

}


@end
