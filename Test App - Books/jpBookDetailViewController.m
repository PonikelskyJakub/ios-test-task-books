//
//  jpBookDetailViewController.m
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import "jpBookDetailViewController.h"
#import "jpPreviewViewController.h"

@interface jpBookDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textSnippetLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *AverageRatingLabel;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;

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
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              UIImage* image = [UIImage imageWithData:data];
                                              self.imageImageView.image = image;
                                          });
                                      }
                                  }];
    [task resume];
    
    self.titleLabel.text = self.book.title;
    self.authorsLabel.text = self.book.authors;

    self.subtitleLabel.text = self.book.subtitle;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.book.textSnippet dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.textSnippetLabel.attributedText = attrStr;
    self.descriptionLabel.text = self.book.bookDescription;
    self.AverageRatingLabel.text = [NSString stringWithFormat:@"%@ %.1f", NSLocalizedString(@"BOOK_DETAIL_RATING", @"Detail of book - rating"), self.book.rating];
    
    if (self.book.previewUrl == nil) {
        [self.previewButton setHidden:YES];
    }
}

- (IBAction)previewButtonTouchUp:(id)sender {
    [self performSegueWithIdentifier:@"showPreviewOfBook" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPreviewOfBook"]) {
        jpPreviewViewController *previewVC = segue.destinationViewController;
        previewVC.previewUrl = self.book.previewUrl;
    }
}

@end
