import {Component, OnInit} from '@angular/core';

import {BooksService} from './books.service';

@Component({
  selector: 'books',
  styleUrls: ['./books.component.css'],
  templateUrl: './books.component.html'
})

export class BooksComponent implements OnInit {

  static books = [
    {
      id: 1,
      title: 'Solaris'
    },
    {
      id: 2,
      title: 'Metro 2033'
    }
  ];

  constructor(private booksService: BooksService) {

  }

  ngOnInit() {

  }

  books() {
    return BooksComponent.books;
  }
}
