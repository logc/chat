package com.nacionlumpen

import scala.util.parsing.combinator.RegexParsers
import scalaz.\/
import scalaz.syntax.either._

import com.nacionlumpen.model.{Command, Nick}

object CommandParser {

  private object Grammar extends RegexParsers {
    val nick = Nick.Pattern ^^ Nick.apply
    val trailingText = """.*""".r
    def renameTo = "NICK" ~> nick ^^ Command.RenameTo.apply
    def lookupNick = "NICK" ^^^ Command.LookupNick
    def message = "MSG" ~> trailingText ^^ Command.Message.apply
    def lookupNames = "NAMES" ^^^ Command.LookupNames
    def kick = "KICK" ~> nick ^^ Command.Kick.apply
    def command: Parser[Command] = renameTo | lookupNick | message | lookupNames | kick
  }

  def parse(message: String): String \/ Command =
    Grammar.parseAll(Grammar.command, message) match {
      case Grammar.Success(command, _) => command.right
      case Grammar.NoSuccess(cause, _) => cause.left
    }
}
