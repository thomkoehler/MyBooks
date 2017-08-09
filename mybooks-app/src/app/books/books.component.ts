import {Component, OnInit} from '@angular/core';
import {DataSource} from '@angular/cdk/table';
import {Observable} from 'rxjs/Observable';
import 'rxjs/Rx'; 

@Component({
  selector: 'books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css'],
})


export class BooksComponent {
  public dataSource: BooksDataSource = new BooksDataSource();

  public displayedColumns = ['id', 'firstName', 'lastName'];
}


export class BooksDataSource extends DataSource<any> {
  public connect(): Observable<Array<any>> {
    return Observable.of([{'id': 1, 'firstName': 'fname', 'lastName': 'lname'}]);
  }

  public disconnect() {
  }
}