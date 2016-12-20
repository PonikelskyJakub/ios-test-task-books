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

- (void) reloadBooksFromSource{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Book"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [self.context.persistentStoreCoordinator executeRequest:delete withContext:self.context error:&deleteError];
    if(deleteError){
        NSLog(@"Error removing books: %@\n%@", [deleteError localizedDescription], [deleteError userInfo]);
    }
    
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Books" ofType:@"json"];
    NSDictionary* allBooks = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                     options:kNilOptions
                                                       error:&err];
    if(err){
        NSLog(@"Error parsing JSON: %@\n%@", [err localizedDescription], [err userInfo]);
    }

    for (id obj in [allBooks objectForKey:@"items"]) {
        JPBook *book = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Book"
                        inManagedObjectContext:self.context];
        NSDictionary* volumeInfo = [obj objectForKey:@"volumeInfo"];
        if(!volumeInfo){
            continue;
        }
        book.title = [volumeInfo objectForKey:@"title"];
        book.subtitle = [volumeInfo objectForKey:@"subtitle"];
        book.bookDescription = [volumeInfo objectForKey:@"description"];
        book.authors = [[volumeInfo objectForKey:@"authors"] componentsJoinedByString:@", "];
        book.rating = [[volumeInfo objectForKey:@"averageRating"] floatValue];
        book.id = [obj objectForKey:@"id"];;
        book.readed = NO;
        
        NSDictionary* searchInfo = [obj objectForKey:@"searchInfo"];
        if(searchInfo){
            book.textSnippet = [searchInfo objectForKey:@"textSnippet"];
        }

        NSDictionary* imageLinks = [volumeInfo objectForKey:@"imageLinks"];
        if(imageLinks){
            book.imageUrl = [imageLinks objectForKey:@"thumbnail"];
        }

        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Error saving book:  %@\n%@", [err localizedDescription], [err userInfo]);
        }
    }
    
    [self saveBooksData];
}

- (NSArray*) getBooksWithRating: (NSNumber*) rating{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:self.context];
    [request setEntity:entity];
    
    if(rating != nil){
        [request setPredicate:[NSPredicate predicateWithFormat:@"rating >= %f", [rating floatValue]]];
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

- (NSManagedObject*) getBook{
    return nil;
}

@end
