import { Controller } from 'stimulus';

export default class extends Controller {
  static values = {
    active: Boolean,
  };

  static classes = ['active'];

  initialize() {
    this.previousValue = this.activeValue;
  }

  connect() {
    if (this.isLoading) this.show();
  }

  disconnect() {
    this.hide();
  }

  show() {
    this.toggle(true);
  }

  hide() {
    this.toggle(false);
  }

  toggle(force) {
    this.activeValue = force;
  }

  activeValueChanged() {
    if (this.previousValue === this.activeValue) return;
    this.previousValue = this.activeValue;
    this.element.classList.toggle(this.activeClass, this.activeValue);
  }

  get isLoading() {
    return !this.isLoaded;
  }

  get isLoaded() {
    return this.element.complete;
  }
}
