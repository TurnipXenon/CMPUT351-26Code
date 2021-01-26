;QUESTION 1
;todo: documentation
(defun xmember (X Y)
    (cond   ((null Y) nil)
            ((atom Y) nil)
            (t (or (or  (equal X (car Y))
                        (xmember X (car Y))
                    )
                    (xmember X (cdr Y))
                )
            )
    )
)

;QUESTION 2
;todo: documentation
(defun flatten (X)
    (cond
        ((null X) X)
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