import { MybooksAppPage } from './app.po';

describe('mybooks-app App', () => {
  let page: MybooksAppPage;

  beforeEach(() => {
    page = new MybooksAppPage();
  });

  it('should display welcome message', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('Welcome to app!');
  });
});
