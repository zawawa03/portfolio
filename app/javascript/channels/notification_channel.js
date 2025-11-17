import consumer from "./consumer"

document.addEventListener("turbo:load",() =>{
  const notification_field = document.querySelector('#notification_field')
  if (notification_field) {
    consumer.subscriptions.create({channel: "NotificationChannel", user_id: document.querySelector('#notification_user').dataset.id}, {
      connected() {
        console.log('notification_channel接続');
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        if (!notification_field) return
        notification_field.remove();
        const notification_user = document.querySelector('#notification_user')
        if (!notification_user) return
        notification_user.insertAdjacentHTML('afterbegin', data['notification'])
      }
    });
  };  
});  
