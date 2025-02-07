const profile = {
    name: '',
    age: '',
    country: ''
};

function updateProfile () {
    profile.name = document.getElementById("name").value;
    profile.age = document.getElementById("age").value;
    profile.country = document.getElementById("country").value;     
};

document.getElementById('updateBtn').addEventListener('click', updateProfile);