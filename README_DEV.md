# Configuration pour améliorer le Hot Reload Flutter

# 1. Assurez-vous que ces packages sont à jour dans pubspec.yaml
# 2. Utilisez les commandes suivantes dans le terminal :

# Pour nettoyer et redémarrer :
flutter clean && flutter pub get && flutter run

# Pour forcer un hot restart :
# Appuyez sur 'R' dans le terminal où Flutter s'exécute

# Pour un hot reload :
# Appuyez sur 'r' dans le terminal où Flutter s'exécute

# Solutions communes pour les problèmes de rafraîchissement :

1. Vérifiez que vous lancez Flutter avec : flutter run (pas flutter build)
2. Si le hot reload ne fonctionne pas, utilisez hot restart (R)
3. Vérifiez que votre simulateur/émulateur est bien connecté
4. Pour les fichiers de localisation (.arb), un restart complet peut être nécessaire
5. Fermez et relancez l'application si les changements ne s'affichent pas

# Raccourcis clavier utiles :
# r : Hot reload
# R : Hot restart  
# h : Aide
# d : Detach (quitter sans fermer l'app)
# q : Quit (quitter complètement)
