(module rpn-parse (rpn:calculate rpn:repl)
  (import chicken scheme)
  (require-extension (only srfi-13 string-pad string-tokenize))
  (use (only extras read-line))
  (import rpn-op rpn-colour)

  ;; Our entrance point, `rpn:calculate` or `rpn:repl`,
  ;; first tokenises the expression:
  ;; "1 2.08 +" -> ("1" "2.08" "+")
  
  ;; Then calls `exp-check` to check for unrecognised tokens
  ;; and to round inexact numbers to integers:
  ;; ("1" "2.08" "+") -> (1 2 '+)
  
  ;; The list returned by `exp-check` is then passed to
  ;; `calc-step` which iterates recursively applies `rpn:eval` (in rpn-op)
  ;; (1 2 '+) -> (rpn:eval '(1 2) '+)
  
  ;; `rpn:eval` checks the `rpn:operators` alist and complains if
  ;; the operator does not have enough arguments in the stack.
  ;; The symbol is evaluated in accordance to the corresponding
  ;; procedure in `rpn:operators`
  ;; (rpn:eval '(1 2) '+) -> (list (+ (car '(1 2)) (cadr '(1 2)))) -> (3)
  
  (define *padding* (make-parameter  0))
  (define *verbose* (make-parameter #f))

  (define (exp-check exp new-exp)
    (cond
     ((null? exp) ; If there are no values,
      new-exp)    ; just return what we have so far.
     ((string->number (car exp)) ; Is it a number?
      (exp-check (cdr exp)       ; If so, make sure it's round and exact
                 `(,@new-exp     ; then push it and keep going.
                   ,(inexact->exact (round (string->number (car exp)))))))
     ((assoc (string->symbol (car exp)) rpn:operators) ; Is it an operator?
      (exp-check (cdr exp)                        ; if so, just push the symbol.
                 `(,@new-exp
                   ,(string->symbol (car exp)))))
     (else ; Otherwise, pretend nothing happened.
      (print (tint "Unrecognised token: " 'red) (car exp))
      new-exp)))

  (define (verbose-print exp stack step)
    (display (tint (string-pad (number->string step) (*padding*)) 'green))
    (print
     (tint  ": "  'green) (tint (cdr exp) 'cyan)
     (tint " -> " 'green) (tint (car exp) 'cyan)
     (tint " -> " 'green) (tint   stack   'cyan)))

  (define (calc-step exp stack step)
    (cond
     ((null? exp) ; When we're done
      stack) ; just return the stack.
     (else
      (if (*verbose*) ; this is ugly
          (verbose-print exp stack step))
      (calc-step (cdr exp) (rpn:eval (car exp) stack) (+ 1 step)))))

  (define (rpn:calculate expression #!optional (verbose #f))
    (*verbose* verbose)
    (let ((exp (exp-check (string-tokenize expression) '())))
      (when (*verbose*)  ; TODO make padding cleaner w/ alignment
        (*padding* (+ 1 (quotient (length exp) 10)))
        (print (tint "Input: " 'yellow) (tint exp 'cyan)))
      (print (if (*verbose*) (tint "Output: " 'yellow) "") (tint (calc-step exp '() 0) 'cyan)))
    (exit))
  
  (define (rpn:repl #!optional (verbose #f))
    (define (rpn:read stack)
      (let ((line (read-line)))
        (cond ((eof-object? line)
               stack)    ; exit on EOF
              ((zero? (string-length line))
               (rpn:read ; nothing to read if the user just pressed return
                stack))
              (else
               (rpn:read
                (calc-step (exp-check (string-tokenize line) stack) '() 0))))))
    (*verbose* verbose)
    (*padding* 2)        ; TODO fix verbose behaviour in REPL
    (print
     (if (*verbose*) (tint "Output: " 'yellow) " ")
     (tint (rpn:read '()) 'cyan))
    (exit)))
