(module rpn (calculate operators)
  (import chicken scheme)
  (use (only srfi-13 string-pad))
  
  (define operators '((+ . +) (- . -) (* . *) (/ . quotient)
                      (^ . expt) (% . remainder)))
  (define padding 0)
  
  (define (err message code)
    (print "Error: " message)
    (exit code))

  (define (int-check value)
    (let ((num (string->number value)))
      (if (and (integer? num) (not (inexact? num)))
          num
          (err (string-append "Not an exact integer: " value) 2))))

  (define (sym-check value)
    (if (assoc (string->symbol value) operators)
        (string->symbol value)
        (err (string-append "Unrecognised token: " value) 2)))

  (define (exp-check exp new-exp)
    (if (pair? exp)
        (let ((value (car exp)))
          (exp-check
           (cdr exp)
           `(,@new-exp
             ,(if (string->number value)
                  (int-check value)
                  (sym-check value)))))
        new-exp))
  
  (define (work token stack)
    (cond
     ((integer? token)
      `(,@stack ,token))
     ((null? stack)
      (err "Stack empty." 1))
     ((null? (cdr stack))
      (err "Stack too short." 1))
     (else
      (cons
       ((eval (cdr (assoc token operators))) (car stack) (cadr stack))
       (cddr stack)))))
  
  (define (calc exp stack step)
    (display (string-pad (number->string step) padding))
    (print ": " exp " ⇒ " stack)
    (if (null? exp)
        stack
        (let ((token (car exp)))
          (calc (cdr exp) (work token stack) (+ 1 step)))))

  (define (calculate exp)
    (set! padding (+ 1 (quotient (length exp) 10)))
    (print (length exp))
    (print "Input: " exp)
    (print "Output: " (calc (exp-check exp '()) '() 0))
    (exit)))
