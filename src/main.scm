(use args extras)
(import rpn-parse rpn-doc)

(define *verbose* (make-parameter #f))

(define (rpn:version)
  (print   "rpnscm v0.13")
  (print   "Copyright (C) Erkin Batu Altunbaş")
  (display "This project's source code is subject to the terms of the ")
  (print   "Mozilla Public Licence v2.0")
  (display "If a copy of the MPL was not distributed with this file, ")
  (print   "you can obtain one at http://mozilla.org/MPL/2.0/")
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
   (args:make-option (V version) #:none "Display version and licence"
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

(if (or (null? (command-line-arguments))
        (eq? (command-line-arguments) '("-v")))
    (rpn:usage)
    (args:parse (command-line-arguments) opts))

(print (command-line-arguments))
