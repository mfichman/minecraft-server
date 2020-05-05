import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = [ "toast" ]

  connect() {
    $(this.toastTarget).toast('show').on('hidden.bs.toast', () => {
      this.toastTarget.parent.removeChild(this.toastTarget);
    });
  }
}
