//
//  BooksDataObject.m
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import "BooksDataObject.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "JPBook+CoreDataClass.h"

@interface BooksDataObject()

@property (nonatomic, strong) NSManagedObjectContext* context;

@end

@implementation BooksDataObject

+ (instancetype)sharedInstance {
    static BooksDataObject *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BooksDataObject alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if ( self = [super init] ) {
        AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.context = ad.persistentContainer.viewContext;
    }
    return self;
}

- (void) saveBooksData{
    NSError *error = nil;
    if ([self.context save:&error] == NO) {
        NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void) removeDataFromDatabase{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Book"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *error = nil;
    [self.context.persistentStoreCoordinator executeRequest:delete withContext:self.context error:&error];
    if(error){
        NSLog(@"Error removing books: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void) actualizeDatabaseData: (NSData*) data{
    NSError *error = nil;
    NSDictionary *allBooks = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    if(error){
        NSLog(@"Error parsing remote JSON: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
    NSArray *allBooksArray = [allBooks objectForKey:@"items"];
    if ([allBooksArray count]) {
        for (id obj in allBooksArray) {
            NSDictionary* volumeInfo = [obj objectForKey:@"volumeInfo"];
            if(!volumeInfo){
                continue;
            }

            NSString* idOfBook = [obj objectForKey:@"id"];
            
            NSFetchRequest* request = [[NSFetchRequest alloc] init];
            NSEntityDescription* entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:self.context];
            [request setEntity:entity];
            [request setPredicate:[NSPredicate predicateWithFormat:@"id == %@", idOfBook]];
            
            NSError *error = nil;
            NSArray* fetchedBooks = [self.context executeFetchRequest:request error:&error];
            if (error == nil) {
                JPBook *book;
                if ([fetchedBooks count]) {
                    book = [fetchedBooks lastObject];
                } else {
                    book = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Book"
                                    inManagedObjectContext:self.context];
                    book.readed = NO;
                }
                book.title = [volumeInfo objectForKey:@"title"];
                book.subtitle = [volumeInfo objectForKey:@"subtitle"];
                book.bookDescription = [volumeInfo objectForKey:@"description"];
                book.authors = [[volumeInfo objectForKey:@"authors"] componentsJoinedByString:@", "];
                book.rating = [[volumeInfo objectForKey:@"averageRating"] floatValue];
                book.id = idOfBook;
                book.previewUrl = [volumeInfo objectForKey:@"previewLink"];
                
                NSDictionary* searchInfo = [obj objectForKey:@"searchInfo"];
                if(searchInfo){
                    book.textSnippet = [searchInfo objectForKey:@"textSnippet"];
                }
                
                NSDictionary* imageLinks = [volumeInfo objectForKey:@"imageLinks"];
                if(imageLinks){
                    book.imageUrl = [imageLinks objectForKey:@"thumbnail"];
                    book.smallImageUrl = [imageLinks objectForKey:@"smallThumbnail"];
                }

            }
            else{
                NSLog(@"Error loading book:  %@\n%@", [error localizedDescription], [error userInfo]);
                return;
            }
        }
        
        [self saveBooksData];
        
        if(self.delegate){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate newBooksLoaded];
            });
        }
    }
}

- (void) reloadBooksFromSource{
    //[self removeDataFromDatabase];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.googleapis.com/books/v1/volumes?filter=free-ebooks&q=a"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      [self actualizeDatabaseData:data];
                                  }];
    [task resume];
    //NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Books" ofType:@"json"];
    //[self actualizeDatabaseData:[NSData dataWithContentsOfFile:dataPath]];
}

- (NSArray*) getBooksWithRating: (NSNumber*) rating ContainsString: (NSString*) string{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:self.context];
    [request setEntity:entity];
    
    if(rating != nil && string != nil){
        [request setPredicate:[NSPredicate predicateWithFormat:@"rating >= %f && title CONTAINS[cd] %@", [rating floatValue], string]];
    }
    else if(rating != nil){
        [request setPredicate:[NSPredicate predicateWithFormat:@"rating >= %f", [rating floatValue]]];
    }
    else if(string != nil){
        [request setPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", string]];
    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];

    NSError *error = nil;
    NSArray* fetchedBooks = [self.context executeFetchRequest:request error:&error];
    if (error == nil) {
        return fetchedBooks;
    }
    else{
        NSLog(@"Error loading books:  %@\n%@", [error localizedDescription], [error userInfo]);
        return [[NSArray alloc] init];
    }
}

@end
