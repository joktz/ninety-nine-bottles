// Set event listener to turbo load so it functions even when switching pages
document.addEventListener('turbo:load', function() {
  console.log("Round Display JS Loaded");
  // Grabbing elements from the DOM to manipulate
  const round_input = document.getElementById('game_round_count');
  const message_wrapper = document.getElementById('round-message-wrapper');
  const round_message = document.getElementById('round-message');
  // Grabbing beer count value from hidden element in DOM
  const beer_count = parseInt(document.getElementById('beer-count').value, 10);
  // Sets value on page load
  calculateBeersPerRound(round_input, beer_count, round_message, message_wrapper);
  // Updates display with changed input
  round_input.addEventListener('change', function() {
    calculateBeersPerRound(round_input, beer_count, round_message, message_wrapper);
  });
});

// method to calculate beers per round for user help message
function calculateBeersPerRound(round_input, beer_count, round_message, message_wrapper) {
  // Converts round value string to integer to do calculation
  console.log(round_input.value);
  if (round_input.value === '' || round_input.value === '0') {
    // hides the message if the input is empty
    message_wrapper.classList.add('d-none');
    round_message.textContent = '';
  } else {
    // calculates beers per round, converts to string for display, and prints in the DOM
    message_wrapper.classList.remove('d-none');
    const calculatedValue = (beer_count / round_input.value).toString();
    round_message.textContent = calculatedValue;
  }
};
