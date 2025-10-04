// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(userName) => "Bonjour ${userName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("BoxtoBikers"),
        "commonCancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "commonConfirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
        "commonSave": MessageLookupByLibrary.simpleMessage("Enregistrer"),
        "flag": MessageLookupByLibrary.simpleMessage("fr"),
        "homeCounterLabel": MessageLookupByLibrary.simpleMessage(
            "Vous avez appuyé sur le bouton ce nombre de fois :"),
        "homeHello": m0,
        "homeIncrementTooltip":
            MessageLookupByLibrary.simpleMessage("Incrémenter"),
        "homeItemExploreDescription": MessageLookupByLibrary.simpleMessage(
            "Envie de découvrir, c\'est ici !"),
        "homeItemExploreTitle":
            MessageLookupByLibrary.simpleMessage("Visiter le site"),
        "homeItemSettingsDescription": MessageLookupByLibrary.simpleMessage(
            "Configurez vos cookies, notifications, ..."),
        "homeItemSettingsTitle":
            MessageLookupByLibrary.simpleMessage("Paramètres"),
        "homeItemWhoAmIDescription": MessageLookupByLibrary.simpleMessage(
            "On vous dit tout... ou presque !"),
        "homeItemWhoAmITitle":
            MessageLookupByLibrary.simpleMessage("Qui sommes-nous ?"),
        "homeLoginButton": MessageLookupByLibrary.simpleMessage("Se connecter"),
        "homeTitle":
            MessageLookupByLibrary.simpleMessage("BoxToBikers, en route ! "),
        "ridingStartButton":
            MessageLookupByLibrary.simpleMessage("Commencer un trajet"),
        "ridingStopButton":
            MessageLookupByLibrary.simpleMessage("Terminer le trajet"),
        "ridingTitle": MessageLookupByLibrary.simpleMessage("Mes trajets")
      };
}
