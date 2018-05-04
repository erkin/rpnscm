#!/usr/bin/csi -ss

(use args system)
(load "rpn.system")
(load-system rpn quiet: #t)
(import rpn-parse rpn-op)

(define verbose #f)

(define op-docstring
  '((~ . "(i->i) Negation")
    (a . "(i->i) Absolute value")
    (s . "(i->i) Signum")
    (d . "(i->ii) Duplication")
    (p . "(i->nil) Pop and discard")
    (+ . "(ii->i) Addition")
    (- . "(ii->i) Subtraction")
    (* . "(ii->i) Multiplication")
    (^ . "(ii->i) Exponentiation")
    (/ . "(ii->i) Integer division (quotient)")
    (% . "(ii->i) Integer modulo (remainder)")
    (Σ . "(n->i) Sum of entire stack")
    (Π . "(n->i) Product of entire stack")
    (m . "(n->i) Discard all but minimum")
    (M . "(n->i) Discard all but maximum")))

(define (rpn-version)
  (print "rpnscm v0.8")
  (print "All wrongs reversed.")
  (exit))

(define (rpn-usage)
  (print "Usage: " (car (argv)) " -e \"EXPRESSION\"")
  (print (args:usage opts))
  (print "See -o for a list of operators.")
  (exit))

(define (rpn-interactive)
  (print "Not yet implemented.")
  (exit))

(define (rpn-file)
  (print "Not yet implemented.")
  (exit))

(define (rpn-operators)
  (print "Notation:")
  (print "(i->): Pop")
  (print "(ii->): Pop two")
  (print "(n->): Pop all")
  (print "(->i): Push")
  (print "(->ii): Push two")
  (print "(->nil): Push nothing")
  (newline)
  (print "Operators:")
  (for-each
   (lambda (op)
     (display (car op))
     (display ": ")
     (print (cdr (assoc (car op) op-docstring))))
   operators)
  (exit))

  (define opts
    (list
     (args:make-option (h help) #:none "Print this help message"
                       (rpn-usage))
     (args:make-option (V version) #:none "Display version"
                       (rpn-version))
     (args:make-option (o operators) #:none "Print list of operators"
                       (rpn-operators))
     (args:make-option (e eval) (required: "\"EXPRESSION\"") "Evaluate EXPRESSION"
                       (rpn-calculate arg verbose))
     (args:make-option (i interactive) #:none "Start interactive mode"
                       (rpn-interactive))
     (args:make-option (f file) (required: "FILE") "Load expression from FILE"
                       (rpn-file))
     (args:make-option (v verbose) #:none "Explain each step"
                       (set! verbose #t))))

  (define (main options)
    (args:parse options opts))
