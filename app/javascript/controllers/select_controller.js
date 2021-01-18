import { ApplicationController } from 'stimulus-use';

export default class extends ApplicationController {
  static targets = ['input', 'visual', 'options'];
  static values = {
    selected: Array,
    multiple: Boolean,
    max: Number,
    placeholder: String,
  };
  static classes = ['selected', 'hasSelected', 'plusBadge', 'disabled'];

  initialize() {
    this.previousSelected = this.selected;
  }

  clear(e) {
    e.preventDefault();
    this.selectedValue = [];
  }

  option(e) {
    const value = e.target.dataset.index;
    if (this.multipleValue) {
      if (this.selectedValue.indexOf(value) > -1) {
        // deselect
        this.selectedValue = this.selectedValue.filter((v) => v !== value);
      } else {
        // select
        this.selectedValue = [...this.selectedValue, value];
      }
      return;
    }

    if (this.selectedValue.indexOf(value) < 0) {
      this.selectedValue = [value];
    }
  }

  close() {
    this.dispatch('close');
  }

  selectTarget() {
    if (this.hasInputTarget) {
      this.inputTarget.value = this.multipleValue ? this.selectedValue.join(',') : this.selectedValue[0];
    }
    let selectedRef;
    const selectedClass = this.selectedClass.split(' ');
    const disabledClass = this.disabledClass.split(' ');
    const hasSelectedClass = this.hasSelectedClass.split(' ');
    const selectedCount = this.selectedValue.length;
    const allCount = this.optionsTarget.childElementCount;
    const shouldDisable = this.multipleValue && this.maxValue > 0 && this.maxValue === selectedCount;

    if (this.hasOptionsTarget) {
      Array.from(this.optionsTarget.children).map((el) => {
        const isSelected = this.selectedValue.indexOf(el.dataset.index) > -1;
        if (isSelected) {
          el.classList.add(...selectedClass);
          if (this.multipleValue) {
            el.classList.remove(...disabledClass);
          }
        } else {
          el.classList.remove(...selectedClass);
          if (this.multipleValue && shouldDisable) {
            el.classList.add(...disabledClass);
          }
        }
        if (isSelected && !selectedRef) {
          selectedRef = el.querySelector('[data-ref]');
        }
      });
    }
    if (selectedRef) {
      this.visualTarget.classList.add(...hasSelectedClass);
    } else {
      this.visualTarget.classList.remove(...hasSelectedClass);
    }
    if (this.hasVisualTarget) {
      const visualRef = this.visualTarget.querySelector('[data-ref]');
      if (!visualRef) return;

      if (selectedRef) {
        if (selectedCount > 1) {
          visualRef.innerHTML = `
            <div style="display:inline-flex; align-items:center;">
              ${selectedRef.innerHTML}
              <span class="${
                this.plusBadgeClass
              }" style="margin-left:8px; font-size: 12px; border-radius:9999px; display:inline-flex; justify-content:center; align-items:center; height:20px; min-width:20px;">+ ${
            selectedCount - 1
          }</span>
            </div>
          `;
        } else {
          visualRef.innerHTML = selectedRef.innerHTML;
        }
      } else {
        visualRef.innerText = this.placeholderValue;
      }
    }

    if (!this.multipleValue || allCount === selectedCount) {
      this.close();
    }
  }

  selectedValueChanged() {
    if (this.previousSelected === this.selectedValue) return;
    this.previousSelected = this.selectedValue;
    this.selectTarget();
  }
}
