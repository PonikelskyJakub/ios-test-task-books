//
//  jpBooksController.m
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import "jpBooksController.h"
#import "BooksDataObject.h"
#import "jpBookTableViewCell.h"
#import "JPBook+CoreDataClass.h"
#import "jpBookDetailViewController.h"


@interface jpBooksController ()

@property (nonatomic, strong) NSArray* booksArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property BOOL allBooks;

@end

@implementation jpBooksController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBooksAll:YES];
}

- (IBAction)FilterButtonAction:(id)sender {
    [self loadBooksAll:!self.allBooks];
}

- (void) loadBooksAll: (BOOL) all{
    BooksDataObject* object = [BooksDataObject sharedInstance];
    if (all) {
        self.filterButton.title = NSLocalizedString(@"BOOKS_LIST_FILTER_WITH_RATING", @"Show rated books");
        self.booksArray = [object getBooksWithRating:nil];
    } else {
        self.filterButton.title = NSLocalizedString(@"BOOKS_LIST_FILTER_ALL", @"Show all books");
        self.booksArray = [object getBooksWithRating:[NSNumber numberWithFloat:4.0]];
    }
    self.allBooks = all;
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
    cell.nameLabel.text = book.title;
    [cell setReadedButtonTitle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetailOfBook" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    jpBookDetailViewController *detailVC = segue.destinationViewController;
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    JPBook* book = [self.booksArray objectAtIndex:[selectedPath row]];
    detailVC.book = book;
}

#pragma mark - Search bar method

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void) filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@"%@ %@", searchText, scope);
    //NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    //searchResults = [recipes filteredArrayUsingPredicate:resultPredicate];
}

@end
