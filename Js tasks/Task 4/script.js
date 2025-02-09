const listItem = document.querySelectorAll("#colorList li");
listItem.forEach(item =>{
    item.addEventListener('click', function(){
        listItem.forEach(li => li.classList.remove("highlight"));
        this.classList.add("highlight");
    });
});