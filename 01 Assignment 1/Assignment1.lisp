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
(defun mix_helper (L1 L2 AC)
    (cond
        ((null L1) (append AC L2))
        ((null L2) (append AC L1))
        (t (append
                (cons (car L1) (cons(car L2) nil))
                (mix_helper (cdr L1) (cdr L2) AC)
            )
        )
    )
)

(defun mix (L1 L2)
    (mix_helper L1 L2 nil)
)