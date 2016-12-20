//
//  BooksDataObject.h
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BooksDataObject : NSObject

+ (instancetype)sharedInstance;
- (void) reloadBooksFromSource;
- (NSArray*) getBooksWithRating: (NSNumber*) rating;
- (NSManagedObject*) getBook;
- (void) saveBooksData;

@end
