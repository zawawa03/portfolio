import consumer from "./consumer"

document.addEventListener("turbo:load",() =>{
  const notification_user = document.querySelector('#notification_user')
  if (notification_user) {
    consumer.subscriptions.create({channel: "NotificationChannel", user_id: document.querySelector('#notification_user').dataset.id}, {
      connected() {
        console.log('notification_channel接続');
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        const old_notification_field = document.querySelector('#notification_field')
        old_notification_field.remove();
        notification_user.insertAdjacentHTML('beforeend', data['notification'])
      }
    });
  };
});
