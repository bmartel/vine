import { useClickOutside, ApplicationController } from 'stimulus-use';
import { createPopper } from '@popperjs/core';

export default class extends ApplicationController {
  static targets = ['ref', 'content', 'arrow'];
  static values = {
    visible: Boolean,
    strategy: String,
    placement: String,
    modifiers: Array,
    clickAway: String,
  };
  static classes = ['hidden'];

  connect() {
    this.isVisible = this.visibleValue;
    if (this.enableClickAway) {
      useClickOutside(this, {
        element: this.contentTarget,
      });
    }
    this.popover = null;
  }

  disconnect() {
    this.hide();
  }

  composeModifiers(...modifiers) {
    return [...this.modifiersValue, ...modifiers].filter(Boolean);
  }

  show() {
    this.isVisible = true;
    const arrow = this.hasArrowTarget ? { name: 'arrow', options: { element: this.arrowTarget } } : undefined;
    this.popover = createPopper(this.refTarget, this.contentTarget, this.composeUpdate(arrow));
    this.contentTarget.classList.remove(this.hiddenClass);
    this.refTarget.setAttribute('aria-expanded', true);
  }

  hide() {
    this.isVisible = false;
    this.refTarget.setAttribute('aria-expanded', false);
    if (this.popover) {
      this.popover.destroy();
      this.popover = null;
      this.contentTarget.classList.add(this.hiddenClass);
    }
  }

  toggle(e) {
    e.preventDefault();
    if (this.popover) {
      this.hide();
    } else {
      this.show();
    }
  }

  composeUpdate(...modifiers) {
    const options = {};
    if (this.hasStrategyValue) {
      options.strategy = this.strategyValue;
    }
    if (this.hasPlacementValue) {
      options.placement = this.placementValue;
    }
    if (this.hasModifiersValue || modifiers.length) {
      options.modifiers = this.composeModifiers(...modifiers);
    }
    return options;
  }

  updatePopover(options) {
    if (this.popover) {
      this.popover.setOptions(options);
    }
  }

  visibleValueChanged() {
    if (this.visibleValue) {
      this.show();
    } else {
      this.hide();
    }
  }

  clickAwayValueChanged() {
    this.enableClickAway = Boolean(this.clickAwayValue === '' ? 'true' : this.clickAwayValue !== 'false');
  }
  strategyValueChanged() {
    this.updatePopover({ strategy: this.strategyValue });
  }

  placementValueChanged() {
    this.updatePopover({ placement: this.placementValue });
  }

  modifiersValueChanged() {
    this.updatePopover({ modifiers: this.modifiersValue });
  }

  clickOutside(event) {
    if (this.isVisible && event.target !== this.refTarget) {
      event.preventDefault();
      this.hide();
    }
  }
}
