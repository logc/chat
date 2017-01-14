#lang info
(define collection "chat")
(define deps '("base"
               "rackunit-lib"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("scribblings/chat.scrbl" ())))
(define pkg-desc "A simple chat written in Racket")
(define version "0.1")
(define pkg-authors '(logc))
