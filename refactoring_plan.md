# Refactoring Plan for Chess Game

## 1. Roadmap

1. [X] **Create a new branch:** Create a new branch for refactoring (e.g., `git checkout -b refactoring`).
2. [X] **Implement new classes:**
   1. [X] **GameManager:** Create a new GameManager class to manage game state and turn logic.
   2. [X] **Move:** Create a new Move class or module to handle move-related logic.
3. [X] **Implement basic methods:** For each new class, create the basic methods needed for their functionality.
4. [ ] **Evaluate Board methods:** Review each method in the Board class and decide whether to move it to a different class or keep it in the Board class.
5. [ ] **Refactor tests:** Update your test suite to account for the changes made during refactoring. Ensure that tests are properly updated to handle the new class and method structure.
6. [ ] **Test and assure all is working:** Run your test suite and ensure that everything is working as expected. If necessary, make any adjustments to the code or tests to fix issues that arise.
7. [ ] **Merge branch:** Once you're satisfied with the refactoring, merge the changes back into your main branch (e.g., `git checkout main && git merge refactoring`).

---

## 2. Refactoring Steps

### 2.1. Create a new branch

- Create a new branch for refactoring (e.g., `git checkout -b refactoring`).
- Add changes to staging area (e.g., `git add .`).
- Commit changes (e.g., `git commit -m "Create new branch for refactoring"`).
- Push changes to remote (e.g., `git push origin refactoring`).

Now you have a stable version of your code saved and committed, and you can confidently proceed with creating a new branch and refactoring your code.

### 2.2. Implement new classes

This step involves planning the new classes you want to create and implement for your chess project. Based on your plan, you want to create:

1. A new GameManager class
2. A new Move class

Here's a brief overview of what each class might handle:

1. **GameManager** class:
The GameManager class will be responsible for managing the game state, handling player turns, and enforcing game rules. It will also interact with the Board and Piece classes to perform actions like moving pieces, checking for check or checkmate, and validating moves.

Some methods to include in the GameManager class might be:

- `initialize`: Set up a new game with an empty board or a starting position.
- `move_piece`: Move a piece from one position to another, checking if the move is valid.
- `is_check?`: Determine if the current player's king is in check.
- `is_checkmate?`: Determine if the current player's king is in checkmate.
- `is_draw?`: Determine if the game is a draw.
- `is_valid_move?`: Check if a given move is valid for the current game state.
- `next_turn`: Advance the game to the next player's turn.

2. **Move class:**
The Move class will represent a single move made by a player during a game. It will store information about the move, such as the piece being moved, the starting and ending positions, and any special move attributes (e.g., castling, en passant, or promotion).

Some methods and attributes to include in the Move class might be:

- `piece`: The Piece object being moved.
- `start_position`: The starting position of the piece on the board.
- `end_position`: The ending position of the piece on the board.
- `is_capture?`: Whether the move involves capturing an opponent's piece.
- `is_castling?`: Whether the move is a castling move.
- `is_en_passant?`: Whether the move is an en passant capture.
- `is_promotion?`: Whether the move involves promoting a pawn.

As you implement these changes, feel free to ask for opinions or guidance. Remember that this is just a starting point, and you can adapt or modify the classes and methods as needed for your specific project requirements.
