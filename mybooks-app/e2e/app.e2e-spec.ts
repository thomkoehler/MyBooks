import { MybooksAppPage } from './app.po';

describe('mybooks-app App', () => {
  let page: MybooksAppPage;

  beforeEach(() => {
    page = new MybooksAppPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
