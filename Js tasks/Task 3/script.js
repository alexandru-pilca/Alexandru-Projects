document.getElementById('addTask').addEventListener('click', function() {
    const taskInput = document.getElementById('taskInput');
    const taskValue = taskInput.value;

    if (taskValue !== "") {
        const li = document.createElement('li');
        li.textContent = taskValue;
     
          
      const removeButton = document.createElement('button');
      removeButton.textContent = 'Remove';
      removeButton.addEventListener('click', function() {
        li.removeChild(newTask);
      });
     
      li.appendChild(removeButton);
    
      todoList.appendChild(li);

      taskInput.value = '';
    }
  });