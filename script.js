

let humanScore = 0;
let computerScore = 0;

function playRound(humanChoice, computerChoice) {
    if (humanChoice === computerChoice) {
        return "It's a tie!";
    } else if (
        (humanChoice === 'rock' && computerChoice === 'scissors') ||
        (humanChoice === 'paper' && computerChoice === 'rock') ||
        (humanChoice === 'scissors' && computerChoice === 'paper')
    ) {
        humanScore++;
        return "You win this round!";
    } else {
        computerScore++;
        return "Computer wins this round!";
    }
}

function playGame() {
    for(let i=0; i<5; i++){
        const computerChoice = getComputerChoice();
        const humanChoice = getHumanChoice();
        console.log(playRound(humanChoice, computerChoice));
        console.log(`Human Score: ${humanScore}, Computer Score: ${computerScore}`);

    }
}


function getComputerChoice() {
    const choices = ['rock', 'paper', 'scissors'];
    const randomIndex = Math.floor(Math.random() * choices.length);
    return choices[randomIndex];
    
}

function getHumanChoice() {
    const userInput = prompt("Enter rock, paper, or scissors:");
    const formattedInput = userInput.toLowerCase();
    if (['rock', 'paper', 'scissors'].includes(formattedInput)) {
        return formattedInput;
    } else {
        alert("Invalid choice. Please enter rock, paper, or scissors.");
        return getHumanChoice();
    }
}

playGame();