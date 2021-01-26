;QUESTION 1
;todo: documentation
(defun xmember (X Y)
    (if (or (null Y) (atom Y))
        nil
        (or (or (equal X (car Y))
                (xmember X (car Y))
            )
            (xmember X (cdr Y))
        )
    )
)

;; (xmember '1 '(1))
;; T
;; >(xmember '1 '( (1) 2 3))
;; NIL
;; >(xmember '(1) '((1) 2 3))
;; T
;; (xmember nil nil)
;; NIL
;; (xmember nil '(nil))
;; T
;; (xmember nil '((nil)))
;; NIL
;; (xmember '(nil) '(1 2 3 (nil)))
;; T
(xmember '(nil) '(nil))

;QUESTION 2
;todo: documentation
(defun flatten (X)
    (cond
        ((null X) nil)
        ((atom (car X)) 
                (cons (car X)
                    (flatten (cdr X))))
        (t
            (append
                (flatten (car X))
                (flatten (cdr X))
            )
        )
    )
)

;; (flatten '(a (b c) d))
;; (flatten '((((a)))))
;; (flatten '(a (b c) (d ((e)) f)))

;QUESTION 3
;todo: documentation
(defun remove-duplicate (X)
    (cond
        ((null X) nil)
        ((null (cdr X)) X)
        ((xmember (car X) (cdr X)) (remove-duplicate (cdr X)))
        (t (cons (car X) (remove-duplicate (cdr X))))
    )
)

;QUESTION 4
;todo: documentation
(defun mix (L1 L2)
    (cond
        ((null L1) L2)
        ((null L2) L1)
        (t (append
                (cons (car L1) (cons(car L2) nil))
                (mix (cdr L1) (cdr L2))
            )
        )
    )
)

;QUESTION 5
;todo: documentation
(defun gen-subsets (L AC)
    (cond
        ((or (null (car L)) (null L)) AC)
        ((null (cdr L)) (cons L AC))
        (t (cons L AC))
    )
)

(defun allsubsets (L)
    (gen-subsets L (cons nil nil))
)