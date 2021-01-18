import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['tab', 'panel'];
  static values = {
    active: String,
  };
  static classes = ['disabled', 'hidden', 'inactive', 'active'];

  initialize() {
    this.previousValue = this.activeValue;
  }

  change(e) {
    this.activeValue = this.tabTargets[this.tabTargets.indexOf(e.target.parentNode)].dataset.id;
  }

  activeValueChanged() {
    if (this.previousValue === this.activeValue) return;
    this.previousValue = this.activeValue;
    this.reveal();
  }

  reveal() {
    this.panelTargets.forEach((el) => {
      if (el.dataset.id === this.activeValue) {
        el.classList.remove(this.hiddenClass);
      } else {
        el.classList.add(this.hiddenClass);
      }
    });

    const active = this.activeClass.split(' ');
    const inactive = this.inactiveClass.split(' ');

    this.tabTargets.forEach((el) => {
      if (!el.classList.contains(this.disabledClass)) {
        if (el.dataset.id === this.activeValue) {
          el.classList.add(...active);
          el.classList.remove(...inactive);
        } else {
          el.classList.add(...inactive);
          el.classList.remove(...active);
        }
      }
    });
  }
}
