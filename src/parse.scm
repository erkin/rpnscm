(module rpn.parse (rpn:calculate rpn:repl)
  (import chicken scheme extras)
  (require-extension (only srfi-13 string-pad string-tokenize))
  (import rpn.op)

  (define *padding* (make-parameter 0))
  (define *verbose* (make-parameter #f))

  (define (err-with-value message value code)
    (print "Error: " message value)
    (exit code))

  (define (int-check value)
    (let ((num (string->number value)))
      (if (not (inexact? num))
          num
          (inexact->exact (round num)))))

  (define (sym-check value)
    (if (assoc (string->symbol value) rpn:operators)
        (string->symbol value)
        (err-with-value "Unrecognised token: " value 2)))

  (define (exp-check exp #!optional (new-exp '()))
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
    (display (string-pad (number->string step) (*padding*)))
    (print ": " (cdr exp) " -> " (car exp) " -> " stack))

  (define (calc-step exp #!optional (stack '()) (step 0))
    (cond
     ((null? exp) stack)
     (else
      (if (*verbose*)
          (verbose-print exp stack step))
      (calc-step (cdr exp) (rpn:eval (car exp) stack) (+ 1 step)))))
  
  (define (rpn:calculate expression #!optional (verbose #f))
    (*verbose* verbose)
    (let ((exp (exp-check (string-tokenize expression))))
      (when (*verbose*)
        (*padding* (+ 1 (quotient (length exp) 10)))
        (print "Input: " exp))
      (print (calc-step exp)))
    (exit))
  
  (define (rpn:repl #!optional (verbose #f))
    (define (rpn:read stack)
      (let ((line (read-line)))
        (cond ((eof-object? line)
               stack)
              ((zero? (string-length line))
               (rpn:read
                stack))
              (else
               (rpn:read
                (calc-step (exp-check (string-tokenize line) stack)))))))
    (*verbose* verbose)
    (*padding* 2)
    (print (rpn:read '()))
    (exit)))
