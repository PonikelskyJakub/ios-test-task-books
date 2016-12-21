//
//  jpBooksController.m
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import "jpBooksController.h"
#import "jpBookTableViewCell.h"
#import "JPBook+CoreDataClass.h"
#import "jpBookDetailViewController.h"


@interface jpBooksController ()

@property (nonatomic, strong) NSArray* booksArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property BOOL allBooks;
@property (nonatomic, strong) NSString* findTitle;
@property (weak, nonatomic) IBOutlet UISearchBar *findTitleSearchBar;


@end

@implementation jpBooksController

- (void)viewDidLoad {
    [super viewDidLoad];

    BooksDataObject* object = [BooksDataObject sharedInstance];
    object.delegate = self;
    
    [self.findTitleSearchBar resignFirstResponder];
    
    self.findTitle = nil;
    self.allBooks = YES;
    [self loadBooks];
}

- (IBAction)FilterButtonAction:(id)sender {
    self.allBooks = !self.allBooks;
    [self loadBooks];
}

- (void) loadBooks{
    BooksDataObject* object = [BooksDataObject sharedInstance];
    if (self.allBooks) {
        self.filterButton.title = NSLocalizedString(@"BOOKS_LIST_FILTER_WITH_RATING", @"Show rated books");
        self.booksArray = [object getBooksWithRating:nil ContainsString:self.findTitle];
    } else {
        self.filterButton.title = NSLocalizedString(@"BOOKS_LIST_FILTER_ALL", @"Show all books");
        self.booksArray = [object getBooksWithRating:[NSNumber numberWithFloat:4.0] ContainsString:self.findTitle];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.booksArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    jpBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookReusableIdentifier" forIndexPath:indexPath];
    
    JPBook* book = [self.booksArray objectAtIndex:[indexPath row]];
    
    cell.book = book;
    [cell setLayout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetailOfBook" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetailOfBook"]) {
        jpBookDetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
        JPBook* book = [self.booksArray objectAtIndex:[selectedPath row]];
        detailVC.book = book;
    }
}

#pragma mark - Search bar method

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    if([searchText length]){
        self.findTitle = searchText;
    }
    else{
        self.findTitle = nil;
    }
    [self loadBooks];
}

#pragma mark - Books loading methods

- (void)newBooksLoaded{
    [self loadBooks];
}

@end
