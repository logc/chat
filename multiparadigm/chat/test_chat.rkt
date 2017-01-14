#lang racket
(require rackunit)

(require "client.rkt" "server.rkt")

(test-case
    "Serve a NICK request"
  (define listener (tcp-listen 1212))
  (define server
    (thread
     (lambda () (serve-request (sync listener)))))
  (check-equal? (send-request) "sortega"))
