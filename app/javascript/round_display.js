// Set event listener to turbo load so it functions even when switching pages
document.addEventListener('turbo:load', function() {
  console.log("Round Display JS Loaded");
  // Grabbing elements from the DOM to manipulate
  const round_input = document.getElementById('game_round_count');
  const round_message = document.getElementById('round-message');
  // Grabbing beer count value from hidden element in DOM
  const beer_count = parseInt(document.getElementById('beer-count').value, 10);
  // Sets value on page load
  calculateBeersPerRound(round_input, beer_count, round_message);
  // Updates display with changed input
  round_input.addEventListener('change', function() {
    calculateBeersPerRound(round_input, beer_count, round_message);
  });
});

// method to calculate beers per round for user help message
function calculateBeersPerRound(round_input, beer_count, round_message) {
  // Converts round value string to integer to do calculation
  console.log(round_input.value);
  if (round_input.value === '' || round_input.value === '0') {
    // hides the message if the input is empty
    round_message.classList.add('d-none');
    round_message.textContent = '';
  } else {
    // calculates beers per round, converts to string for display, and prints in the DOM
    round_message.classList.remove('d-none');
    const calculatedValue = (beer_count / round_input.value);

    if (isFloat(calculatedValue)) {
      const round_beer_count = Math.floor(calculatedValue);
      const last_round_beer_count = beer_count - (round_beer_count * (round_input.value - 1));
      round_message.textContent = `Each round will have ${round_beer_count} beers, except the last round, which will have ${last_round_beer_count} beers`;
    } else {
      round_message.textContent = "Each round will have " + calculatedValue + " beers";
    }
  }
};

function isFloat(value) {
  return Number(value) === value && value % 1 !== 0;
}
