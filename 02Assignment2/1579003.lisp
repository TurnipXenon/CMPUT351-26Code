#| Helper function count-elements

The function count-elements returns a number which represents the number of elements
in the list L.

This is a helper function for find-fun.

Test cases:
> (count-elements nil) ; > 0
> (count-elements '((a))) ; > 1
> (count-elements '(() a)) ; > 2

|#

(defun count-elements (L)
  (if (null L)
    0
    (+ 1 (count-elements (cdr L)))
  )
)



#| Helper function find-fun

Given a function F, and a program P (which is a list of function 
definitions), the function find-fun returns a matching function definition if said
function definition exists in P. Otherwise, nil is returned. A function definition
matches with a function if its name and arity matches with the funciton definition's
header.

This is a helper function for find-fun.

This assumes that F has a proper format for a function, and P is a valid program.

Test cases:
(find-fun '(greater 3 5) '((greater (x y) = (if (> x y) x (if (< x y) y nil))))) ; > t
(find-fun '(greater 3 5) '((lesser (x y) = (if (> x y) x (if (< x y) y nil))))) ; > nil
(find-fun '(greater 3 5) '((greater (x y z) = (if (> x y) x (if (< x y) y nil))))) ; > nil

|#

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



#| Helper function replace0
Given a list of variables A and a list of values V, the function returns a matching value in V
if X is equal to a variable in A. Otherwise, X is returned. A variable in A matches with 
a value in V if they both are in the same position in their list. This assumes that 
the length of A and length of V are equal.

This is a helper function for fl-sub.

Test cases:
> (replace0 '(X Y) '(1 2) 'Z) > Z
> (replace0 '(X Y) '(1 2) 'Y) > 2

|#
(defun replace0 (A V X)
  (cond
    ((null A) X)
    (
      (eq (car A) X) 
      (car V)
    )
    (t (replace0 (cdr A) (cdr V) X))
  )
)



#| Helper function fl-sub

Given the list of variables A, list of values V, and function body B, the function returns
an expression based on B where all the variables are substituted with a matching value.
A variable in A matches with a value in V if they both are in the same position in their list. 
This assumes that the length of A and length of V are equal.

This is a helper function for fl-interp for substituting a matching function header
with an appropriate function body.

Test cases:
> '(fl-sub '(X Y) '(3 5) '(if (> x y) x (if (< x y) y nil))) ; > (if (> 3 5) 3 (if (< 3 5) 5 nil))
> '(fl-sub '(A B) '(3 5) '(if (> x y) x (if (< x y) y nil))) ; > (if (> x y) x (if (< x y) y nil))
|#

(defun fl-sub (A V B)
  (cond 
    ((null B) nil)
    (
      (atom B)
      (replace0 A V B)
    )
    (
      t
      (cons
        (if (atom (car B))
          (replace0 A V (car B)) ; replace the atom
          (fl-sub A V (car B)) ; replace deeply if list
        )
        (fl-sub A V (cdr B)) ; move to next element
      )
    )
  )
)



#| fl-interp

Taken from the assignment specification:

A program P in FL is a list of function definitions. The FL interpreter takes such a program, 
together with a function application, and returns the result of evaluating the application. 
This evaluation is based on the principle of "replacing equals by equals". Your interpreter 
should be defined as a Lisp function

(fl-interp E P)

which, given a program P and an expression E, returns the result of evaluating E with 
respect to P.

Test cases:
> (fl-interp '(+ 10 5) nil) ; > '15
> (fl-interp '(+ (* 2 2) (* 2 (- (+ 2 (+ 1 (- 7 4))) 2))) nil) ; > '12
> (fl-interp '(cadr (5 1 2 7)) '((cadr(x) = (first (rest x))))) ; > '1
> (fl-interp '(divide 24 4) '((divide (x y) = (div x y 0)) (div (x y z) = (if (> (* y z) x) (- z 1) (div x y (+ z 1)))))) ; > '6
|#

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
      ; this includes the case where E is nil or a number
      (atom E) E
    )
    (t
      (let ((f (car E)) (arg (cdr E)))
        (cond
          ; handle primitive functions
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
          ; (applicative order reduction)
          (
            (find-fun E P)
            (let
              ((FE (find-fun E P)))
              (fl-interp 
                (fl-sub
                  (second FE)
                  ; Reference: 
                  ; Terje Norderhaug. Multiple arguments to mapcar. 
                  ; https://stackoverflow.com/a/5959697/10024566
                  (mapcar (lambda (x) (fl-interp x P)) (cdr E))
                  (fourth FE)
                )
                P
              )
            )
          )
          ; otherwise f is defined (not intended to be a function),
          ; then E is returned as if it is quoted in lisp
          (t E)
        )
      )
    )
  )
)