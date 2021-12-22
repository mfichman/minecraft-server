import { Controller } from 'stimulus';
import consumer from 'channels/consumer';

export default class extends Controller {
  static targets = [ 'select' ]

  connect() {
    this.selectTarget.firstChild?.classList?.add('fw-bold');

    consumer.subscriptions.create({channel: 'Minecraft::SavesChannel', server_id: this.serverId}, {
      received: this.received.bind(this)
    });
  }

  received(msg) {
    const options = this.selectTarget.querySelectorAll('option');

    options.forEach(option => option.classList.remove('fw-bold'));

    this.selectTarget.insertAdjacentHTML('afterbegin', msg.html);
    this.selectTarget.value = msg['backup_id'];
    this.selectTarget.firstChild.classList.add('fw-bold');
  }

  get serverId() {
    return this.data.get('serverId');
  }
}
