import { Controller } from 'stimulus';
import consumer from 'channels/consumer';

export default class extends Controller {
  static targets = [ 'button' ]

  connect() {
    consumer.subscriptions.create({channel: 'Minecraft::SavesChannel', server_id: this.serverId}, {
      received: this.received.bind(this)
    });
  }

  received(msg) {
    this.buttonTarget.classList.remove('hidden');
  }

  get serverId() {
    return this.data.get('serverId');
  }
}
