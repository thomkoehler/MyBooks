import {BrowserModule} from '@angular/platform-browser';
import {NgModule} from '@angular/core';
import {FormsModule} from '@angular/forms';
import {HttpModule} from '@angular/http';
import {MaterializeModule} from 'ng2-materialize';
import {RouterModule} from '@angular/router';

import {AppComponent} from './app.component';
import {rootRouterConfig} from './app.routes';

import {BooksComponent} from './books/books.component';
import {AuthorsComponent} from './authors/authors.component';

@NgModule({
  declarations: [
    AppComponent,
    BooksComponent,
    AuthorsComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    MaterializeModule.forRoot(),
    RouterModule.forRoot(rootRouterConfig, {useHash: true})
  ],
  providers: [],
  bootstrap: [AppComponent]
})

export class AppModule {
}
