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
          (t E)
        )
      )
    )
  )
)