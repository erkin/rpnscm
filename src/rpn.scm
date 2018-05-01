(use args)
(import rpn)

(define (version)
  (print "rpnscm v0.7")
  (print "All wrongs reversed.")
  (exit))

(define (usage)
  (print "Usage: " (car (argv)) " -e \"EXPRESSION\"")
  (print (args:usage opts)))

(define opts
  (list
   (args:make-option (h help) #:none "Print this help message"
                     (usage))
   (args:make-option (v version) #:none "Display version"
                     (version))
   (args:make-option (e eval) (required: "\"EXPRESSION\"") "Evaluate EXPRESSION"
                     (calculate arg))))

(receive (options operands)
    (args:parse (command-line-arguments) opts)
  (if (null? (command-line-arguments))
      (usage)))
