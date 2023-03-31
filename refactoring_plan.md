# Refactoring Plan for Chess Game

## 1. Roadmap

1. [ ] **Create a new branch:** Create a new branch for refactoring (e.g., `git checkout -b refactoring`).
2. [ ] **Implement new classes:**
   1. [ ] **GameManager:** Create a new GameManager class to manage game state and turn logic.
   2. [ ] **Move:** Create a new Move class or module to handle move-related logic.
3. [ ] **Implement basic methods:** For each new class, create the basic methods needed for their functionality.
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