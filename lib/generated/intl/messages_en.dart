// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(userName) => "Hello ${userName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("BoxtoBikers"),
        "commonCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "commonConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "commonSave": MessageLookupByLibrary.simpleMessage("Save"),
        "flag": MessageLookupByLibrary.simpleMessage("en"),
        "homeCounterLabel": MessageLookupByLibrary.simpleMessage(
            "You have pushed the button this many times:"),
        "homeHello": m0,
        "homeIncrementTooltip":
            MessageLookupByLibrary.simpleMessage("Increment"),
        "homeItemExploreDescription": MessageLookupByLibrary.simpleMessage(
            "Make a tour to discover, it\'s here !"),
        "homeItemExploreTitle":
            MessageLookupByLibrary.simpleMessage("Explore the site"),
        "homeItemSettingsDescription": MessageLookupByLibrary.simpleMessage(
            "Configure cookies, notifications, ..."),
        "homeItemSettingsTitle":
            MessageLookupByLibrary.simpleMessage("Settings"),
        "homeItemWhoAmIDescription": MessageLookupByLibrary.simpleMessage(
            "We tell you everything... or almost !"),
        "homeItemWhoAmITitle":
            MessageLookupByLibrary.simpleMessage("Who am I ?"),
        "homeLoginButton": MessageLookupByLibrary.simpleMessage("Login"),
        "homeTitle": MessageLookupByLibrary.simpleMessage("Welcome to my site"),
        "ridingStartButton":
            MessageLookupByLibrary.simpleMessage("Start a ride"),
        "ridingStopButton": MessageLookupByLibrary.simpleMessage("End ride"),
        "ridingTitle": MessageLookupByLibrary.simpleMessage("My rides")
      };
}
