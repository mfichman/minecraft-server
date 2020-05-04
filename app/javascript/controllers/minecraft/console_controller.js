import { Controller } from 'stimulus';
import consumer from 'channels/consumer';
import SimpleBar from 'simplebar';

export default class extends Controller {
  static targets = [ 'input', 'output', 'simplebar' ]

  connect() {
    consumer.subscriptions.create({channel: 'Minecraft::LogsChannel', server_id: this.serverId}, {
      received: this.received.bind(this)
    });

    this.simplebar = new SimpleBar(this.simplebarTarget, { autohide: false });
    this.scroll();
  }

  scroll() {
    const el = this.simplebar.getScrollElement();
    el.scrollTop = el.scrollHeight - el.clientHeight;
  }

  send() {
    this.inputTarget.value = '';
  }

  received(msg) {
    const shouldScroll = this.isScrolledToBottom;
    this.outputTarget.innerHTML += msg;

    if (shouldScroll) {
      this.scroll();
      console.log(this.isScrolledToBottom);
    }
  }

  get isScrolledToBottom() {
    const el = this.simplebar.getScrollElement();
    return Math.ceil(el.scrollTop) >= Math.ceil(el.scrollHeight - el.clientHeight);
  }

  get serverId() {
    return this.data.get('serverId');
  }
}
