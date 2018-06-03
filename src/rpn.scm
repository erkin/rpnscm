(use args)
(import rpn-parse rpn-doc)

(define *verbose* (make-parameter #f))

(define (rpn:version)
  (print "rpnscm v0.12")
  (print "All wrongs reversed.")
  (exit))

(define (rpn:usage)
  (print "Usage: " (car (argv)) " -e \"EXPRESSION\"")
  (print (args:usage opts))
  (print "See -o for a list of operators.")
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
                     (rpn:repl (*verbose*)))
   (args:make-option (f file) (required: "FILE") "Load expression from FILE"
                     (rpn:calculate
                      (with-input-from-file arg read-string)
                      (*verbose*)))
   (args:make-option (v verbose) #:none "Explain each step"
                     (*verbose* #t))))

(if (null? (command-line-arguments))
    (rpn:usage)
    (args:parse (command-line-arguments) opts))
