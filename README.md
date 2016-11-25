# Chat

A simple chat implemented in several programming paradigms.

-[Dynamic OOP](oop/dynamically-typed/ruby/README.md) (Ruby)
-["Dynamic" actor model](actors/akkachat/README.md) (Scala/Akka)

## Protocol specification

This simplistic and informally specified protocol is somewhat inspired in
[IRC][irc] but don't take it too seriously as this is just a proof of concept
for comparing programming paradigms.

[irc]: https://tools.ietf.org/html/rfc2812

### Generalities

The protocol is client-server, TCP-based and text (ASCII) oriented. There is
just one channel all the clients will be connected.

Each message will consist of a single line of at most 255 bytes. If a longer
line is sent to the server, the connection will be terminated. Empty lines
will be ignored with no consequence.

### Commands

Commands are messages sent from the client to the server. They start with an
uppercase command name (e.g. `NICK`) and, depending on the command, space
separated arguments. All commands will have a response consisting in a
three-digit status and an optional status message. Example:

    NICK sortega
    200 OK

The status code 400 is reserved to respond to unrecognized/unsupported
commands. Some commands have more than one consecutive response message (e.g.
listing the people in the chat when it is crowded).

#### `NICK`

This command allows a user to check their nick.

Response codes:
 - 201 `<current nick>`

#### `NICK <nick>`

This command allows a user to identify himself. Nicks must have at most 10
characters that must be letters, numbers, `_` or `-`. Users will have an
autogenerated nickname until properly identified (e.g. `anon101`)

Response codes:
 - 200 Nick name accepted
 - 301 Malformed nick
 - 302 Nick name in use

#### `MSG <message...>`

This command will send a message to the single and one chat channel.

Response codes:
 - 200 Message accepted

#### `NAMES`

Requests a listing on the connected users.

Response codes:
 - 202 `<nick>*`  Complete or rest of the list of nicks
 - 203 `<nick>*`  Part of the list of nicks. It will be followed by another
   response with code 200 or 201

#### `QUIT [<parting message>]`

Exits the channel and therefore the chat. The optional parting message will
be notified to the other users if present.

Response codes:
 - 200  Command acknowledged. Connection will be closed from the server side
   after this response code is sent.

#### `KICK <nick>`

Kicks an user out of the chat. This was reserved for ops in IRC but we want
to democratize fun!

Response codes:
 - 200  Bon voyage
 - 303  Unknown user

### Notifications

Unlike commands, notifications are initiated by the server side. They allow
the client to receive other users messages and some other information.
Notifications can come while waiting for a command response but, in no case,
a notification will break a command response in two.

#### `MSG <author>: <message...>`

Notification of a message sent by another user. User messages won't be echoed
back in form of MSG notifications.

#### `JOINED <nick>`

Notification of new user joining the channel.

#### `RENAME <old_nick> <new_nick>`

Notification of user rename.

#### `LEFT <nick>`

Notification of an user leaving the chat.
