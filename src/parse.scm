(module rpn-parse (rpn-calculate)
  (import chicken scheme)
  (require-extension (only srfi-13 string-pad string-tokenize))
  (import rpn-op)

  (define padding 0)
  (define verbose #f)

  (define (err-with-value message value code)
    (print "Error: " message value)
    (exit code))

  (define (int-check value)
    (let ((num (string->number value)))
      (if (not (inexact? num))
          num
          (inexact->exact (round num)))))

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

  (define (verbose-print exp stack step)
    (display (string-pad (number->string step) padding))
    (print ": " (cdr exp) " -> " (car exp) " -> " stack))

  (define (calc-step exp stack step)
    (cond
     ((null? exp)
      (if verbose
          (display "Output: "))
      stack)
     (else
      (if verbose
          (verbose-print exp stack step))
      (calc-step (cdr exp) (rpn-eval (car exp) stack) (+ 1 step)))))

  (define (rpn-calculate arg v)
    (set! verbose v)
    (let ((exp (string-tokenize arg)))
      (set! padding (+ 1 (quotient (length exp) 10)))
      (if verbose
          (print "Input: " exp))
      (print (calc-step (exp-check exp '()) '() 0))
      (exit))))
