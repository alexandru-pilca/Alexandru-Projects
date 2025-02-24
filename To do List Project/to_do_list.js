let toDoList = {
  tasks: JSON.parse(localStorage.getItem("tasks")) || [],
  taskInput: document.getElementById("taskInput"),
  taskList: document.getElementById("taskList"),
  addButton: document.querySelector(".btn"),
  taskCount: document.getElementById("taskCount"),
  deleteAllButton: document.getElementById("deleteAllButton"),
};

document.addEventListener("DOMContentLoaded", function () {
  displayTasks(toDoList);

  toDoList.addButton.addEventListener("click", function () {
    addTask(toDoList, taskInput);
  });

  toDoList.taskInput.addEventListener("keydown", function (event) {
    if (event.key === "Enter") {
      event.preventDefault();
      addTask(toDoList, taskInput);
    }
  });

  toDoList.deleteAllButton.addEventListener("click", function () {
    clearTasks(toDoList, deleteAllButton);
  });
});

function addTask(toDoList, taskInput) {
  let taskText = taskInput.value.trim();

  if (taskText === "") {
    alert("Task cannot be empty!");
    return;
  }

  toDoList.tasks.push({ text: taskText, completed: false });
  localStorage.setItem("tasks", JSON.stringify(toDoList.tasks));
  toDoList.taskInput.value = "";
  displayTasks(toDoList);
}

function deleteTask(index, toDoList) {
  if (!toDoList.tasks[index].completed) {
    alert("You can only delete completed tasks.");
    return;
  }
  toDoList.tasks.splice(index, 1);
  localStorage.setItem("tasks", JSON.stringify(toDoList.tasks));
  displayTasks(toDoList);
}

function clearTasks(toDoList) {
  if (confirm("Are you sure you want to delete all tasks?")) {
    toDoList.tasks = [];
    localStorage.setItem("tasks", JSON.stringify(toDoList.tasks));
    displayTasks(toDoList);
  }
}

function toggleTask(index, toDoList) {
  toDoList.tasks[index].completed = !toDoList.tasks[index].completed;
  localStorage.setItem("tasks", JSON.stringify(toDoList.tasks));
  displayTasks(toDoList);
}

function displayTasks(toDoList) {
  toDoList.taskList.innerHTML = "";

  toDoList.tasks.forEach((task, index) => {
    let li = document.createElement("li");
    li.classList.add("task-item");

    if (task.completed) {
      li.classList.add("completed");
    }

    let taskText = document.createElement("span");
    taskText.textContent = task.text;
    taskText.style.textDecoration = task.completed ? "line-through" : "none";
    taskText.style.color = task.completed ? "grey" : "black";
    taskText.style.textDecorationThickness = task.completed ? "2px" : "initial";
    taskText.style.textDecorationColor = task.completed ? "red" : "initial";
    taskText.addEventListener("click", function () {
      toggleTask(index, toDoList);
    });

    let deleteButton = document.createElement("button");
    deleteButton.textContent = "X";
    deleteButton.id = "deleteButton";
    deleteButton.onclick = function () {
      deleteTask(index, toDoList);
    };

    li.appendChild(taskText);
    li.appendChild(deleteButton);
    toDoList.taskList.appendChild(li);
  });

  toDoList.taskCount.textContent = toDoList.tasks.length;
}
