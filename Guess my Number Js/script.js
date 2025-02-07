'use strict';



let secretNumber = Math.trunc(Math.random() * 20) + 1;
let score = 20;
let highscore = 0;
const displayMessage = function (message) {
  document.querySelector('.message').textContent = message;
}; // function for displaing the message
const displayNumber = function (number) {
  document.querySelector('.number').textContent = number;
};


//Click button Check
document.querySelector('.check').addEventListener('click', function () {
  const guess = Number(document.querySelector('.guess').value);
  console.log(guess, typeof guess);

  // No input
  if (!guess) {
   
    displayMessage('No Number!');

    //Guess is Correct
  } else if (guess === secretNumber) {
   
    displayMessage('🎉 Correct Number!');
   
    displayNumber(secretNumber);
    //Background color
    document.querySelector('body').style.backgroundColor = '#60b347';
    //Number squer width
    document.querySelector('.number').style.width = '30rem';
    //Set Highscore
    if (score > highscore) {
      highscore = score;
      document.querySelector('.highscore').textContent = highscore;
    }
   
  } else if (guess !== secretNumber) {
    if (score > 1) {
      displayMessage(guess > secretNumber ? 'Too High!' : 'Too Low!');
      score--;
      document.querySelector('.score').textContent = score;
    } else {
      displayMessage('💥You Lost the Game!');
        displayNumber(secretNumber);
      document.querySelector('body').style.backgroundColor = '#8B0000';
      //Number squer width
      document.querySelector('.number').style.width = '30rem';
      document.querySelector('.score').textContent = 0;
    }
  }
});
// Click button Again
document.querySelector('.again').addEventListener('click', function () {
  score = 20;
  secretNumber = Math.trunc(Math.random() * 20) + 1;

  displayMessage('Start guessing...');
  document.querySelector('.score').textContent = score;
 
  displayNumber('?');
  document.querySelector('.guess').value = '';
  document.querySelector('body').style.backgroundColor = '#222';
  document.querySelector('.number').style.width = '15rem';
});
