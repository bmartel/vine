import { Controller } from 'stimulus';
import { setCookie } from '../lib/cookie';

const LIGHT = 'light';
const DARK = 'dark';
const SYSTEM = 'system';

export default class extends Controller {
  static values = {
    active: String,
  };
  static classes = [LIGHT, DARK, SYSTEM];

  initialize() {
    this.previousValue = this.activeValue;
  }

  change(e) {
    this.activeValue = e.target.value || e.target.dataset.colorScheme || SYSTEM;
  }

  activeValueChanged() {
    if (this.previousValue === this.activeValue) return;

    const previousValue = this.previousValue;
    this.previousValue = this.activeValue;

    this.updateColorScheme(previousValue, this.activeValue);
  }

  updateColorScheme(previous, next) {
    const previousClass = this[`${previous}Class`];
    const nextClass = this[`${next}Class`];

    this.element.classList.remove(previousClass);
    this.element.classList.add(nextClass);

    setCookie('color_scheme', next);
  }
}
