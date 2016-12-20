//
//  jpBookDetailViewController.m
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import "jpBookDetailViewController.h"

@interface jpBookDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textSnippetLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *AverageRatingLabel;

@end

@implementation jpBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.book.title];
    [self showDetailBook];
}

- (void) showDetailBook{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.book.imageUrl]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if(self.imageImageView){
                                          UIImage* image = [UIImage imageWithData:data];
                                          self.imageImageView.image = image;
                                          
                                          if (self.imageImageView.bounds.size.height > image.size.height) {
                                              self.imageImageView.contentMode = UIViewContentModeCenter;
                                          }
                                          else{
                                              self.imageImageView.contentMode = UIViewContentModeScaleAspectFit;
                                          }
                                      }
                                  }];
    [task resume];
    
    self.titleLabel.text = self.book.title;
    self.authorsLabel.text = self.book.authors;

    self.subtitleLabel.text = self.book.subtitle;
    self.textSnippetLabel.text = self.book.textSnippet;
    self.descriptionLabel.text = self.book.bookDescription;
    self.AverageRatingLabel.text = [NSString stringWithFormat:@"%@ %.1f", NSLocalizedString(@"BOOK_DETAIL_RATING", @"Detail of book - rating"), self.book.rating];

}

@end
