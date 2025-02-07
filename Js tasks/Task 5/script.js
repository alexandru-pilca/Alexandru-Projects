function startTimer() {
    let countdown = 10;

    function updateTimer() {
        const timerElement = document.getElementById('timer');
        if (countdown >= 0) {
            timerElement.innerText = countdown;
            countdown--;
        } else {
            timerElement.innerText = "Time's up!";
            clearInterval(timerInterval); 
        }
    }

}

document.getElementById('startTimer').addEventListener('click', startTimer);
