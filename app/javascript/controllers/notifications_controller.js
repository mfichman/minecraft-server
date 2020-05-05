import { Controller } from 'stimulus';
import consumer from 'channels/consumer';

export default class extends Controller {
  static targets = [ "toast" ]

  connect() {
    consumer.subscriptions.create({channel: 'ToastsChannel'}, {
      received: this.received.bind(this)
    });
  }

  received(html) {
    this.toastTarget.innerHTML = html;
  }
}
