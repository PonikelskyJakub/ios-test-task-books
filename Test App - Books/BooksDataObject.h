//
//  BooksDataObject.h
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol BooksDataObjectDelegate <NSObject>
@optional
- (void)newBooksLoaded;
@end

@interface BooksDataObject : NSObject

@property (nonatomic, weak) id <BooksDataObjectDelegate> delegate;

+ (instancetype)sharedInstance;
- (void) reloadBooksFromSource;
- (NSArray*) getBooksWithRating: (NSNumber*) rating ContainsString: (NSString*) string;
- (void) saveBooksData;

@end
