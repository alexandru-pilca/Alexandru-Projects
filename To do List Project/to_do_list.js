let tasks = JSON.parse(localStorage.getItem("tasks")) || [];// Local storage
let taskInput = document.getElementById("taskInput");
let taskList = document.getElementById("taskList");
let addButton = document.querySelector(".btn");
let taskCount = document.getElementById("taskCount");

document.addEventListener("DOMContentLoaded", function () {
    addButton.addEventListener("click", addTask);
    taskInput.addEventListener("keydown", function (event) {
        if (event.key === "Enter") {
            event.preventDefault();// It will not put empty input
            addTask();
        }
    });

    displayTasks(); // Load tasks on page load
});

// Function to add a task
function addTask() {
    let taskText = taskInput.value.trim();

    if (taskText === "") {
        return; // Prevent adding empty tasks
    }

    tasks.push({ text: taskText });// Add an task to the local storage array
    saveToLocalStorage();
    taskInput.value = ""; // Clear input field
    displayTasks();
}
    

// Function to save tasks to localStorage
function saveToLocalStorage() {
    localStorage.setItem("tasks", JSON.stringify(tasks));
}

// Function to display tasks and add a delete button for each task
function displayTasks() {
    taskList.innerHTML = ""; // Clear the list before reloading

    tasks.forEach((task, index) => {
        let li = document.createElement("li");// For each task in the array create a li (list item)
        li.textContent = task.text;
        let deleteButton = document.createElement("button");
        deleteButton.textContent = "X";
        deleteButton.id = "deleteButton";
        deleteButton.addEventListener("click", function () {
            tasks.splice(index, 1); // Remove the task from the array
            saveToLocalStorage();
            displayTasks();
        });

        li.appendChild(deleteButton);// Attach the button to the taskList li
        taskList.appendChild(li);
    });
    taskCount.textContent = tasks.length;
};