function addClickListeners() {
  var coll = document.getElementsByClassName("solution-button");
  var i;

  for (i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function() {
      this.classList.toggle("active");
      var content = this.nextElementSibling;
      if (content.style.maxHeight){
        content.style.maxHeight = null;
      } else {
        content.style.maxHeight = content.scrollHeight + "px";
      }
      if (content.style.padding){
        content.style.padding = null;
      } else {
        content.style.padding = "18px";
      }
    });
  }
}
window.onload = addClickListeners;