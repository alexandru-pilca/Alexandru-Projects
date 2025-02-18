let taskInput = document.getElementById("taskInput");
let taskList = document.getElementById("taskList");

function addTask(){
    
    if (taskInput.value === ""){
         return;
    }

    let li = document.createElement("li");
    li.textContent = taskInput.value;

    let deleteButton = document.createElement("button");
    deleteButton.textContent = "❌"
    deleteButton.addEventListener ("click", function(){
        li.remove();
        
    });

    li.appendChild(deleteButton);
    taskList.appendChild(li);


    taskInput.value ="";
    
};