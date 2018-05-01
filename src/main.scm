(use args)
(import rpn-parse)

(define (rpn-version)
  (print "rpnscm v0.8")
  (print "All wrongs reversed.")
  (exit))

(define (rpn-usage)
  (print "Usage: " (car (argv)) " -e \"EXPRESSION\"")
  (print (args:usage opts))
  (exit))

(define (rpn-interactive)
  (print "Not yet implemented.")
  (exit))

(define (rpn-operators)
  (print "TODO: Add some docstrings or something")
  (for-each
   (lambda (op)
     (print (car op) ": " (cdr op)))
   operators))

(define opts
  (list
   (args:make-option (h help) #:none "Print this help message"
                     (rpn-usage))
   (args:make-option (v version) #:none "Display version"
                     (rpn-version))
   (args:make-option (o operators) #:none "Print operators"
                     (rpn-operators))
   (args:make-option (e eval) (required: "\"EXPRESSION\"") "Evaluate EXPRESSION"
                     (rpn-calculate arg))
   (args:make-option (i interactive) #:none "Start interactive mode"
                     (rpn-interactive))))

(args:parse (command-line-arguments) opts)
