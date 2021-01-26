;QUESTION 1
;todo: documentation
;; (defun xmember (X Y)
;;     (if (null Y)
;;         nil
;;         (or (or (equal X (car Y))
;;                 (xmember)
;;                 )
;;             ()
;;             )
;;     )
;; )

(defun xmember (X Y)
    (cond   ((null Y) nil)
            ((atom Y) nil)
            (t (or (or (equal X (car Y))
                    (xmember X (car Y))
                        )
                    (xmember X (cdr Y))
                    )
                )
    )
)