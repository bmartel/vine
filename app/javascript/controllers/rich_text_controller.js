import { Controller } from 'stimulus';

export default class extends Controller {
  static classes = ['toggle'];

  async initialize() {
    await import(/* webpackChunkName: "rich_text" */ '../chunks/rich_text');
    this.element.classList.toggle(this.toggleClass);
  }
}
