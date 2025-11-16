const fileform = document.querySelector("#file_field")

if (!fileform) return

fileform.addEventListener("change", function(event) {
  const preview_field = document.querySelector("#preview_field")
  if (!preview_field) return
  const old_image = preview_field.querySelector("img")
  if (old_image) {
    old_image.remove();
  }
  const file = event.target.files[0]
  if (!file) return
  const img = document.createElement("img")
  const url = URL.createObjectURL(file)
  img.setAttribute("src", url)
  img.setAttribute("width", "150")
  img.setAttribute("height", "150")
  img.setAttribute("class", "rounded-circle")
  preview_field.append(img) 
})