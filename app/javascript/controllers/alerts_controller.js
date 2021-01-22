import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['alert'];

  dismiss(e) {
    const alert = this.alertTargets.find((alert) => alert === e.target.closest('[data-alerts-target]'));
    if (alert) {
      this.element.removeChild(alert);
    }
  }
}
