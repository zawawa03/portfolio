import consumer from "./consumer"

const message_field = document.querySelector('#message-field');
if (message_field){
  document.addEventListener("turbo:load",() =>{
    window.appRoom = consumer.subscriptions.create({ channel: "RoomChannel", room: document.querySelector('#message-field').dataset }, {
      connected() {
        setTimeout(() => {
        message_field.scrollTop = message_field.scrollHeight;
        }, 0);
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
  });
};