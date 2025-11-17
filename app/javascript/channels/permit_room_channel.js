import consumer from "./consumer"

document.addEventListener("turbo:load",() =>{
  const user_field = document.querySelector('#permit_user_field')
  if (user_field) {
    window.permitRoom = consumer.subscriptions.create({channel: "PermitRoomChannel", room: document.querySelector('#message-field').dataset}, {
      connected() {
        console.log('permit_roomに接続');
      },

      disconnected() {
      // Called when the subscription has been terminated by the server
      },

      received(data) {
        const user_id = document.querySelector('#permit-user').dataset.id
        if (!user_field) return
        if (Number(data.creator_id) === Number(user_id)) {
          user_field.insertAdjacentHTML('beforeend', data['permit']);
          const permit_field = document.querySelector(`#permit_${data['permit_id']}`)
          if (!permit_field) return
          permit_field.insertAdjacentHTML('beforeend', data['button']);
        } else {
          user_field.insertAdjacentHTML('beforeend', data['permit']);
        }
      }
    });
  };
});
