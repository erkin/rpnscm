#!/usr/bin/csi -ss

(use args system)
(load "rpn.system")
(load-system rpn quiet: #t)
(import rpn-parse rpn-op)

(define *verbose* (make-parameter #f))

(define rpn:operator-docstring
  '((! . "( i -> nil) Pop and discard")
    (n . "( i ->   i) Negation")
    (@ . "( i ->   i) Absolute value")
    (s . "( i ->   i) Signum")
    (? . "( i ->   i) Pop and push back")
    (: . "( i ->  ii) Duplication")
    (+ . "(ii ->   i) Addition")
    (- . "(ii ->   i) Subtraction")
    (* . "(ii ->   i) Multiplication")
    (^ . "(ii ->   i) Exponentiation")
    (/ . "(ii ->   i) Integer division (quotient)")
    (% . "(ii ->   i) Integer modulo (remainder)")
    (~ . "(ii ->  ii) Swap")
    (S . "( n ->   i) Sum of entire stack")
    (P . "( n ->   i) Product of entire stack")
    (m . "( n ->   i) Discard all but minimum")
    (M . "( n ->   i) Discard all but maximum")))

(define (rpn:version)
  (print "rpnscm v0.9")
  (print "All wrongs reversed.")
  (exit))

(define (rpn:usage)
  (print "Usage: " (car (argv)) " -e \"EXPRESSION\"")
  (print (args:usage opts))
  (print "See -o for a list of operators.")
  (exit))

(define (rpn:file)
  (print "Not yet implemented.")
  (exit))

(define (rpn:interactive)
  (print "Not yet implemented.")
  (exit))

(define (rpn:operator-usage)
  (print "Notation:")
  (print "( i ->    ): Pop")
  (print "(ii ->    ): Pop two")
  (print "( n ->    ): Pop all")
  (print "(   ->   i): Push")
  (print "(   ->  ii): Push two")
  (print "(   -> nil): Push nothing")
  (newline)
  (print "Operators:")
  (for-each
   (lambda (op)
     (display (car op))
     (display ": ")
     (print (cdr (assoc (car op) rpn:operator-docstring))))
   rpn:operators)
  (exit))

(define opts
  (list
   (args:make-option (h help) #:none "Print this help message"
                     (rpn:usage))
   (args:make-option (V version) #:none "Display version"
                     (rpn:version))
   (args:make-option (o operators) #:none "Print list of operators"
                     (rpn:operator-usage))
   (args:make-option (e eval) (required: "\"EXPRESSION\"") "Evaluate EXPRESSION"
                     (rpn:calculate arg (*verbose*)))
   (args:make-option (i interactive) #:none "Start interactive mode"
		     (rpn:interactive))
   (args:make-option (f file) (required: "FILE") "Load expression from FILE"
		     (exit))
   (args:make-option (v verbose) #:none "Explain each step"
                     (*verbose* #t))))

(define (main args)
  (args:parse args opts)
  (if (null? args) (rpn:usage)))
