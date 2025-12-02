document.addEventListener("click", (e) => {
  if (e.target.id === "mask") {
    console.log("発火");
    document.querySelector("#mask").remove();
    document.querySelector("#modal").remove();
  }
});