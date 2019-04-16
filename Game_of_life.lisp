;Zoe Lambert,Christopher Brown, Nick True
;4/11/2019
;COSC 251 project 4
;resources:
;https://www.tutorialspoint.com/lisp/lisp_input_output.htm
;http://sandbox.mc.edu/~bennet/cs231/examples/loops.html
;https://www.gnu.org/software/emacs/manual/html_node/eintr/Sample-let-Expression.html#Sample-let-Expression
;https://www.gnu.org/software/emacs/manual/html_node/elisp/nil-and-t.html
;https://batsov.com/articles/2011/04/30/parsing-numbers-from-string-in-lisp/
;https://www.reddit.com/r/lisp/comments/a2qnz8/list_without_parentheses/


;define variables for game rules
(defvar input 0)
(defvar size 0)
(defvar stay_alive 0)
(defvar come_alive 0)
(defvar dis_neigh 0)
(defvar start_alive 0)


;variables for other things
(defvar board 0)

;list for handling the board
(setf board (list 
(list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))

;used for validating that the variables are valid for the program
(defun getValidSize()
  (if (> size 20) 
      (progn
	  (princ "Error: Input size too large, re-enter: " )
	  (setq size (parse-integer(read-line)))
	  (getValidSize))))
      
(defun getValidNeigh()
  (if (> dis_neigh size) 
	  (progn
	  (princ "Error: greater than the dimensions of the board, re-enter: " )
	  (setq dis_neigh (parse-integer(read-line)))
	  (getValidNeigh))))
      
(defun getValidTiles()
  (if (> start_alive (* size size))
	  (progn
	  (princ "Error: too many live tiles,re-enter: " )
	  (setq start_alive (parse-integer(read-line)))
	  (getValidTiles))))

;functions for accessing the board list
(defun getEleFrom2dList (lst index1 index2)
  (nth index2 (nth index1 lst)))

(defun setEleFrom2dList (lst index1 index2 value)
  (setf (nth index2 (nth index1 lst)) value))

;Check if a tile is alive. Returns true or false
(defun is_alive (index1 index2)
  (let (( g (getEleFrom2dList board index1 index2)))
  (if (= g 0) nil 1)))


; set up the initial board that starts with the correct number of alive tiles randomly placed
(defun init_board()
  (loop for i from 1 to start_alive  do
       (let ((x (+ 0 (random size))))
	 (let ((y (+ 0 (random size))))
	  (loop while (= (getEleFrom2dList board x y) 1) do
	       (setq x (+ 0 (random size)))
	       (setq y (+ 0 (random size))))
	  (setEleFrom2dList board x y 1)))))



;function to print out the board based on size
(defun printBoard()
(do ((x 0 (+ x 1))) ((> x (- size 1)) 'done) (format t "~{~a~^ ~}" (subseq (nth x board) 0 size)) (Fresh-line)))

;determine number of live neighbors and if it should flip when the cell is alive, return nil if it shouldn't fliped
(defun alive_flip (index1 index2) 
  (let ((num_alive (alive_around index1 index2)))
    (loop for n in stay_alive 
      do(if (= n num_alive)
	     (return-from alive_flip num_alive)
	     nil))))

;This function checks around the cell in question in the rage specified and counts the
;number of neighbors which are alive.
(defun alive_around (index1 index2) 
 (let ((num_alive 0)) 
 (loop for i from 0 to (- dis_neigh 1)
    do (if (>= (- index1 i) 0)
	(if (is_alive (- index1 i) index2)
	    (incf num_alive)))
      (if (<= (+ index1 i) (- size 1))
	  (if (is_alive (+ index1 i) index2)
	      (incf num_alive)))
      (if (>= (- index2 i) 0)
	  (if (is_alive index1 (- index2 i))
	      (incf num_alive)))
      (if (<= (+ index2 i) (- size 1))
	  (if (is_alive index1 (+ index2 i))
	      (incf num_alive))))
 (print num_alive)
 num_alive))

;determine number of live neighbors and if it should flip when the cell is dead, return nil if it wasn't fliped
(defun dead_flip (index1 index2)
  (let ((num_alive (alive_around index1 index2)))
    (loop for n in come_alive
       do(if (= n num_alive)
	     (return-from dead_flip num_alive)
	     nil))))

         
;flip what needs to flip
(defun flip_things (listy)
 (loop for n in listy do
      (if n
	  (if (< 1 (getEleFrom2dList board (nth 0 n) (nth 1 n))) 
	      (setEleFrom2dList board (nth 0 n) (nth 1 n) 0) 
	      (setEleFrom2dList board (nth 0 n) (nth 1 n) 1)))))
 
;function for testing if the board has stabilized, returns nil if the board changed at all. if the board hasn't changed it returns the value of count
(defun is_stable()
 (let ((count 0))
   (let ((listy (list (list ))))
     (loop for i from 0 to (- size 1) do
	(loop for j from 0 to (- size 1) do 
	     (if (is_alive i j)
		 (if (alive_flip i j)
		     (progn
		       (incf count)
		       (print count)
		       (append listy (list (list i j))))
		     nil)
		 (progn
		   (if (dead_flip i j)
		       (progn
			 (incf count)
			 (print count)
			 (append listy (list (list i j))))
		       nil)))))
     (flip_things listy))
  (if (> count 0) nil count)))





;setup function for getting variables that the game will use
(defun getVars()
    (princ "Enter the size of the board: " )
    (setq size (parse-integer(read-line)))
    
    ;gets new board size if the user entered something greater than 20
    (if (> size 20) (getValidSize))

    (princ "Enter the number of live neighbors for a live cell to stay alive: ")
    (setq stay_alive (read-line))
    (setq stay_alive (with-input-from-string (in stay_alive)
    (loop for x = (read in nil nil) while x collect x)))

    (princ "Enter the number of live neighbors for a dead cell to become alive: ")
    (setq come_alive (read-line))
    (setq come_alive (with-input-from-string (in come_alive)
    (loop for x = (read in nil nil) while x collect x)))

    (princ "Distance for the neighbor rule: ")
    (setq dis_neigh (parse-integer(read-line)))
    
    ;gets new neighbor distance if it is greater than the board size
    (if (> dis_neigh size) (getValidNeigh))
    
    (princ "Enter number of live tiles to begin with: ")
    (setq start_alive (parse-integer(read-line)))
    
    ;get new number of live tile to start with is it is greater than the amount of tiles on the board
    (if (> start_alive (* size size)) (getValidTiles)))
    
    
;setup function for setting up the game board.
(defun setup()
    ;get variables for the game
    (getVars)
    
    ;setup the initial game board
    (init_board)

    ; print the starting board
    (princ "Starting board: ")
    (FRESH-LINE)
    (printBoard)
    (FRESH-LINE)
    (princ "Press enter to continue:")
    (read-line))

;run the overall game
(defun run_game()
  (setup)
  (let ((flag 0))
    (loop while (= flag 0) do 
	 (if (is_stable)
	     (progn
	       (princ "Board has stabilized, final state: ")
	       (FRESH-LINE)
	       (printBoard)
	       (incf flag))
	     (progn
	       (princ "Next step: ")
	       (FRESH-LINE)
	       (printBoard)
	       (FRESH-LINE)
	       (princ "Press enter to continue: ")
	       (read-line))))))