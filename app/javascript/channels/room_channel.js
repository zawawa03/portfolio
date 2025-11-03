import consumer from "./consumer"

document.addEventListener("turbo:load",() =>{
  const message_field = document.querySelector('#message-field');
  if (message_field){
    window.appRoom = consumer.subscriptions.create({ channel: "RoomChannel", room: document.querySelector('#message-field').dataset }, {
      connected() {
        console.log('接続');
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        message_field.insertAdjacentHTML('beforeend', data['message']);
        setTimeout(() => {
        message_field.scrollTop = message_field.scrollHeight;
        }, 0);
      },
      speak: function(message) {
        return this.perform('speak', {message: message});
      }
    });

    setTimeout(() => {
      message_field.scrollTop = message_field.scrollHeight;
    }, 0);

    const input = document.querySelector('#message-form')
    if (input){
      input.addEventListener("keydown", function(e) {
        if (e.key === "Enter") {
          window.appRoom.speak(e.target.value);
          e.target.value = '';
          e.preventDefault();
        }
      });
    };
  };
});