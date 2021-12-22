import { Controller } from 'stimulus';
import { Toast } from 'bootstrap';

export default class extends Controller {
  static targets = [ "toast" ]

  connect() {
    const toast = new Toast(this.toastTarget);

    toast.show();

    this.toastTarget.addEventListener('hidden.bs.toast', () => {
      this.toastTarget.remove();
    });
  }
}
