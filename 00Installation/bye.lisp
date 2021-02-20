(load "hi.lisp")
(defun bye ()
    (format t "~a~%" (hi)))
(bye)