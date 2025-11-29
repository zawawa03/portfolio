document.addEventListener("turbo:load",() =>{
  const comment_field = document.querySelector('#comment_field')
  if (comment_field) {
    const reply_button = document.querySelectorAll('#comment-reply')
    for(const value of reply_button) {
      value.addEventListener("click", function(e) {
        console.log('発火')
        const target_id = e.target.dataset.id
        const reply_form = document.querySelector(`#reply-form-${target_id}`)
        reply_form.style.display = null;
      });
    };

    const reply_close_button = document.querySelectorAll('#reply-form-close')
    for(const value of reply_close_button) {
      value.addEventListener("click", function(e) {
        console.log('発火')
        const target_close_id = e.target.dataset.id
        const close_reply_form = document.querySelector(`#reply-form-${target_close_id}`)
        close_reply_form.style.display = "none";
      });
    };
  };
});
