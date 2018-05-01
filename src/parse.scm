(module rpn-parse (rpn-calculate operators)
  (import chicken scheme)
  (require-extension (only srfi-13 string-pad string-tokenize))
  (import rpn-op)
  
  (define padding 0)
  
  (define (err-with-value message value code)
    (print "Error: " message value)
    (exit code))

  (define (int-check value)
    (let ((num (string->number value)))
      (if (and (integer? num) (not (inexact? num)))
          num
          (err-with-value "Not an exact integer: " value 2))))

  (define (sym-check value)
    (if (assoc (string->symbol value) operators)
        (string->symbol value)
        (err-with-value "Unrecognised token: " value 2)))

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
  
  (define (calc-step exp stack step)
    (if (null? exp)
        stack
        (begin
          (display (string-pad (number->string step) padding))
          (print ": " (cdr exp) " ⇒ " (car exp) " ⇒ " stack)
          (let ((token (car exp)))
           (calc-step (cdr exp) (rpn-eval token stack) (+ 1 step))))))

  (define (rpn-calculate arg)
    (let ((exp (string-tokenize arg)))
      (set! padding (+ 1 (quotient (length exp) 10)))
      (print "Input: " exp)
      (print "Output: " (calc-step (exp-check exp '()) '() 0))
      (exit))))
