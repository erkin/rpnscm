(declare (uses rpn-doc))
(declare (uses rpn-parse))
(declare (uses rpn-colour))
(declare (uses rpn-infix))
(require-extension (only srfi-37 args-fold option))
(import rpn-parse rpn-doc rpn-colour rpn-infix)

(define (rpn:version #!optional args) ; ignore arguments
  (print   (tint "rpnscm v0.19" 'cyan #:style 'bold))
  (print   (tint "Copyright (C) 2018 Erkin Batu Altunbaş" 'cyan))
  (newline)
  (print* "Each file of this project's source code is subject ")
  (print  "to the terms of the Mozilla Public Licence v2.0")
  (print* "If a copy of the MPL was not distributed with this file, ")
  (print  "you can obtain one at https://mozilla.org/MPL/2.0/")
  (exit))

(define (rpn:usage #!optional opt name arg loads)
  (define unrecognised
    (if opt ; When called without options, the value of opt is #f.
        (if name
            (if (string? name)
                (if (string=? name "help")
                    #f
                    'long)
                (if (or (char=? name #\?) (char=? name #\h))
                    #f
                    'short))
            'operand)
        #f))
  (when unrecognised
    (print
     (tint "error: " 'red #:style 'bold)
     "Unrecognised "
     (case unrecognised
       ((long)    (string-append "argument: " (tint (string-append "--" name) 'yellow)))
       ((short)   (string-append "option: "   (tint (string #\- name) 'yellow)))
       ((operand) (string-append "operand: "  (tint opt 'yellow)))))
    (newline))
  (print* (tint "Usage: " 'green))
  (print  (car (argv)) " -e " (tint "\"EXPRESSION\"" 'yellow))
  (print* "       ")
  (print  (car (argv)) " -f " (tint "FILE" 'yellow))
  (for-each print (map tint-list rpn:help-messages))
  (exit (if unrecognised 1 0)))

(define (rpn:err error)
  (print (tint "error: " 'red 'bold) error)
  (print "See " (tint "--help" 'green) " for more information.")
  (exit -1))

(define rpn:opts
  (list
   (option '(#\h #\? "help") #f #f
           rpn:usage)
   (option '(#\V "version") #f #f
           rpn:version)
   (option '(#\v "verbose") #f #f
           (lambda _ 'verbose))
   (option '(#\o "operators") #f #f
           rpn:operator-usage)
   (option '(#\e "eval" "evaluate") #t #f
           (lambda (opt name arg seed)
             (if (not arg)
                 (rpn:err "No expression provided."))
             (rpn:calculate arg (eq? seed 'verbose))))
   (option '(#\i "interactive" "repl") #f #f
           (lambda (opt name arg seed)
             (rpn:repl (eq? seed 'verbose))))
   (option '(#\f "file") #t #f
           (lambda (opt name arg seed)
             (if (not arg)
                 (rpn:err "No filename specified."))
             (rpn:calculate
              (with-input-from-file arg read-string)
              (eq? seed 'verbose))))
   (option '(#\s "shunt") #t #f
           (lambda (opt name arg seed)
             (if (not arg)
                 (rpn:err "No expression provided."))
             (rpn:infix arg)))))

(define (main args)
  (if (pair? args)
      (args-fold args rpn:opts rpn:usage rpn:usage #f))
  (rpn:usage)
  (exit))

(main (command-line-arguments))
