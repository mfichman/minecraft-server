import { Controller } from 'stimulus';
import consumer from 'channels/consumer';
import $ from 'jquery';

export default class extends Controller {
  static targets = [ 'select' ]

  connect() {
    consumer.subscriptions.create({channel: 'Minecraft::SavesChannel', server_id: this.serverId}, {
      received: this.received.bind(this)
    });
  }

  received(msg) {
    $(this.selectTarget).prepend(msg.html);
    this.selectTarget.value = msg['backup_id'];
  }

  get serverId() {
    return this.data.get('serverId');
  }
}
