import { Controller } from 'stimulus';

export default class extends Controller {
  static classes = ['ready'];

  async initialize() {
    await Promse.all([
      import(/* webpackChunkName: "rich_text_styles" */ '../stylesheets/rich_text.scss'),
      import(/* webpackChunkName: "rich_text" */ '../chunks/rich_text'),
    ]);
    this.element.classList.add(this.readyClass);
  }
}
