import { Controller } from 'stimulus';
import consumer from 'channels/consumer';
import SimpleBar from 'simplebar';

export default class extends Controller {
  static targets = [ 'input', 'output', 'simplebar' ]

  connect() {
    consumer.subscriptions.create({channel: 'Minecraft::LogsChannel', server_id: this.serverId}, {
      received: this.received.bind(this)
    });

    this.simplebar = SimpleBar.instances.get(this.simplebarTarget);
    this.scroll();
  }

  scroll() {
    this.simplebar.getScrollElement().scrollTop = 10000000;
  }

  send() {
    this.inputTarget.value = '';
  }

  received(msg) {
    this.outputTarget.innerHTML += msg;
    this.scroll();
  }

  get serverId() {
    return this.data.get('serverId');
  }
}
