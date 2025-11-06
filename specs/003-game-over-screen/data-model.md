# Data Model

## GameState

Represents the state of the game at any given time.

### Properties

- **board**: A list of lists representing the game board and the tiles on it.
- **score**: An integer representing the player's current score.
- **isGameOver**: A boolean that is `true` when the game is over (i.e., no more valid moves can be made), and `false` otherwise.