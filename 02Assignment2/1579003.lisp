; todo: document
; assume F is an atom
#| Helper function count-elements

The funtion count-elements returns a number which represents the number of elements
in the list L.

This is a helper function for find-fun.

Test cases:
> (count-elements nil) => 0
> (count-elements '((a))) => 1
> (count-elements '(() a)) => 2

|#
(defun count-elements (L)
  (if (null L)
    0
    (+ 1 (count-elements (cdr L)))
  )
)

; assumes a valid program
(defun find-fun (F P)
  (cond
    ((null P) nil)
    (
      (and
        (eq (car F) (caar P)) ; get the first item in the first pair
        (eq (count-elements (cdr F)) (count-elements (second (car P)))) ; check for equal arity
      )
      (car P)
    )
    (t (find-fun F (cdr P)))
  )
)

; todo: document
; todo: list interpreter
#| Helper function interp-list

The funtion count-elements returns a number which represents the number of elements
in the list L.

This is a helper function for find-fun.

Test cases:
> (count-elements nil) => 0
> (count-elements '((a))) => 1
> (count-elements '(() a)) => 2

|#




#| Helper function fl-lambda

The funtion count-elements returns a number which represents the number of elements
in the list L.

This is a helper function for find-fun.

Test cases:
> (replace0 '(X Y) '(1 2) 'Z) > Z
> (replace0 '(X Y) '(1 2) 'Y) > 2

|#

(defun datafy (X)
  (cons 'quote (cons X nil))
)

;; (defun replace (A V E)
;;   A
;; )

; assume len(A) == len(V)
(defun replace0 (A V X)
  (cond
    ((null A) X)
    (
      (eq (car A) X) 
      (car V)
      ;; (cons 'quote (cons (car V) nil))
    )
    (t (replace0 (cdr A) (cdr V) X))
  )
)

#| Helper function fl-lambda

The funtion count-elements returns a number which represents the number of elements
in the list L.

This is a helper function for find-fun.

Test cases:
> (fl-sub (X Y) (3 5) (if (> x y) x (if (< x y) y nil))) > (if (> 3 5) 3 (if (< 3 5) 5 nil))
> (fl-sub )
|#

(defun fl-sub (A V E)
  (cond 
    ((null E) nil)
    (
      (atom E)
      (replace0 A V E)
    )
    (
      t
      (cons
        (if (atom (car E))
          (replace0 A V (car E))
          (fl-sub A V (car E))
        )
        (fl-sub A V (cdr E)) ; move to next element but also replace deep
      )
    )
  )
)

;; (defun fl-sub (A V E)
;;   E
;; )

; todo: document
(defun fl-interp (E P)
  (cond
    (
      (eq E 'false)
      nil
    )
    (
      (eq E 'true)
      t
    )
    (
      (atom E) E
    ) ; this includes the case  where E is nil or a number
    (t
      (let ((f (car E)) (arg (cdr E)))
        (cond
          ; handle built-in functions
          (
            (eq f 'if) 
            (if 
              (fl-interp (car arg) P)
              (fl-interp (second arg) P)
              (fl-interp (third arg) P)
            )
          )
          (
            (eq f 'null)
            (null (fl-interp (car arg) P))
          )
          (
            (eq f 'atom)
            (atom (fl-interp (car arg) P))
          )
          (
            (eq f 'eq)
            (eq 
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f 'first) 
            (car (fl-interp (car arg) P))
          )
          (
            (eq f 'rest) 
            (cdr (fl-interp (car arg) P))
          )
          (
            (eq f 'cons) 
            (cons 
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f 'equal) 
            (equal
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f 'number) 
            (numberp (fl-interp (car arg) P))
          )
          (
            (eq f '+)
            (+ 
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f '-)
            (- 
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f '*)
            (*
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f '>)
            (>
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f '<)
            (<
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f '=)
            (=
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f 'and)
            (and
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f 'or)
            (or
              (fl-interp (car arg) P)
              (fl-interp (cadr arg) P)
            )
          )
          (
            (eq f 'not)
            (not (fl-interp (car arg) P))
          )
          ; if f is a user-defined function, then evaluate arguments 
          ;(applicative order reduction)
          ; todo: user-defined functions
          ; otherwise f is defined (not intended to be a function),
          ; the E is returned as if it quoted in lisp
          ; todo: error handling
          (
            (find-fun E P)
            ; reference: https://stackoverflow.com/a/5959697/10024566
            (let
              ((FE (find-fun E P))) ; function expression???
              (fl-interp 
                (fl-sub
                  (second FE)
                  (mapcar (lambda (x) (fl-interp x P)) (cdr E))
                  (fourth FE)
                )
                P
              )
            )
          )

          (t E)
        )
      )
    )
  )
)

;; (fl-interp (cons '> (cdr '(greater 3 5))) nil)
;; (mapcar 'fl-interp '((1 nil) (2 nil) (3 nil)))
;; (mapcar (lambda (x) (fl-interp x nil)) '(1 2 3))

(defun last0 (X)
  (if
    (null (rest X))
    (first X)
    (last0 (rest X))
  )
)