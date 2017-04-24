import {Routes} from '@angular/router';

import {BooksComponent} from './books/books.component';
import {AuthorsComponent} from './authors/authors.component';


export const rootRouterConfig: Routes = [
  {path: 'books', component: BooksComponent},
  {path: 'authors', component: AuthorsComponent}
];


