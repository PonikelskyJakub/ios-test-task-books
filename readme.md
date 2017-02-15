# Books Application
Test task for iOS Developer at HCL - Books application.

##Installation

Dependencies:
 - Xcode 8 at least

Steps:

```bash
# clone repository
git clone https://github.com/PonikelskyJakub/ios-test-task-books.git

# open project
open Test App - Books.xcodeproj
```

##Task
- Create simple application with list of books and possibility to look at detailed info.
- List of books is provided in JSON file. Content of this file is downloaded from Google Books API. Structure of JSON is described at Google developers (https://developers.google.com/books/) or it is visible on Google API (https://www.googleapis.com/books/v1/volumes?filter=free-ebooks&q=a).
- Time of development depends on programmer’s consideration. 3 hours is recommended. Please log all your time of development and provide it to us with your project.
- There is no needs to spend any time with comments and documentation. Focus on readability, duplicity code and functionality.
- Wisely manage your time, if you are stuck on some problem, just mock it and try to finish other parts.

Detailed description is in "Description" folder (Task.pdf). 
There is mentioned JSON file with books too.

###Finished parts
- Basic part.
- Advanced part - data can be downloaded from Google API (https://www.googleapis.com/books/v1/volumes?filter=free-ebooks&q=a).
- Advanced part - data can be searched.
- Advanced part - each row can show more data and image about book.
- Advanced part - marker indicating book as readed can be stored persistently.
- Advanced part - detail of the book can contain preview view provided with Google API.

###Time log
- 4 hours - learning how to work with CoreData on Objective C (i never used it before).
- 3 hours - basic tasks and layouts for both ViewControllers.
- 1.5 hour - search (try to dock to the top of screen - unresolved because i used UITableViewController - it is too strict - next time i'm going to use UIViewController and UITableView).
- 45 min - remote load of database.
- 30 min - better layout for list of Books.
- 30 min - persistent book readed marker.
- 30 min - detail of book - preview of book (try to get something better than URL content).
- 30 min - preview of book on Google.
- 30 min - HTML markup in Text Snippet of book.

##Posible improvements
- Image download in one function.
- Remove singleton for data loading.
- Check downloads when app goes in background.
- Rename "readed" variables - poor English.
- Comments
- Unit and UI tests
