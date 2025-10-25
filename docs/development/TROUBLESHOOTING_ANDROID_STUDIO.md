# 🔍 Dépannage - Configuration Android Studio

## ❓ Problèmes courants

### 1. Les configurations n'apparaissent pas dans Android Studio

**Symptôme :** Le menu déroulant ne montre pas les configurations "main.dart (dev)", etc.

**Solutions :**

1. **Fermer et rouvrir le projet** :
   - File → Close Project
   - Rouvrir le projet

2. **Vérifier que les fichiers existent** :
   ```bash
   make check-run-configs
   ```

3. **Invalider les caches** :
   - File → Invalidate Caches → Invalidate and Restart

4. **Vérifier que le dossier `.run/` existe** :
   ```bash
   ls -la .run/
   ```
   Vous devriez voir 4 fichiers `.run.xml`

---

### 2. L'erreur "Configuration manquante" persiste

**Symptôme :** L'erreur apparaît même après avoir sélectionné une configuration.

**Solutions :**

1. **Vérifier la configuration sélectionnée** :
   - Regardez le nom en haut à droite
   - Il doit être `main.dart (dev)` et non juste `main.dart`

2. **Éditer la configuration manuellement** :
   - Cliquez sur le menu déroulant → Edit Configurations
   - Vérifiez que "Additional run args" contient :
     ```
     --dart-define-from-file=config/dev.json
     ```

3. **Recréer la configuration** :
   - Supprimez le fichier `.run/main.dart (dev).run.xml`
   - Créez-le à nouveau (voir ci-dessous)

---

### 3. Le fichier config/dev.json n'existe pas

**Symptôme :** Erreur "File not found: config/dev.json"

**Solution :**

```bash
# Copier l'exemple
cp config/example.json config/dev.json

# Éditer avec vos vraies clés
# Ouvrez config/dev.json et remplacez les valeurs
```

---

### 4. Android Studio ne reconnait pas le projet Flutter

**Symptôme :** Pas de bouton Run, configurations Flutter absentes

**Solutions :**

1. **Installer le plugin Flutter** :
   - Preferences → Plugins
   - Rechercher "Flutter"
   - Installer et redémarrer

2. **Vérifier le SDK Flutter** :
   - Preferences → Languages & Frameworks → Flutter
   - Vérifier que le chemin du SDK est correct

3. **Ouvrir le bon dossier** :
   - Assurez-vous d'ouvrir le dossier racine contenant `pubspec.yaml`

---

### 5. Les configurations apparaissent mais ne fonctionnent pas

**Symptôme :** L'application se lance mais avec l'erreur de configuration

**Solutions :**

1. **Vérifier le contenu du fichier de configuration** :
   ```bash
   cat .run/main.dart\ \(dev\).run.xml
   ```
   
   Il doit contenir :
   ```xml
   <configuration name="main.dart (dev)" type="FlutterRunConfigurationType" factoryName="Flutter">
     <option name="additionalArgs" value="--dart-define-from-file=config/dev.json" />
     <option name="filePath" value="$PROJECT_DIR$/lib/main.dart" />
     <method v="2" />
   </configuration>
   ```

2. **Recréer manuellement la configuration** :
   - Run → Edit Configurations
   - Cliquez sur "+" → Flutter
   - Name: `main.dart (dev)`
   - Dart entrypoint: `lib/main.dart`
   - Additional run args: `--dart-define-from-file=config/dev.json`
   - Apply → OK

---

## 🆘 Solutions de secours

### Option A : Utiliser le terminal

Si Android Studio pose problème, utilisez le terminal :

```bash
# Mode développement
make dev

# Ou directement
flutter run --dart-define-from-file=config/dev.json
```

### Option B : Utiliser VS Code

VS Code a aussi des configurations dans `.vscode/launch.json` qui fonctionnent peut-être mieux.

---

## 🔧 Recréer les configurations manuellement

Si les fichiers `.run/` ne fonctionnent pas, vous pouvez les recréer :

### 1. Supprimer les anciens fichiers
```bash
rm -rf .run/
mkdir .run/
```

### 2. Créer la configuration dev

Créez `.run/main.dart (dev).run.xml` avec ce contenu :

```xml
<configuration name="main.dart (dev)" type="FlutterRunConfigurationType" factoryName="Flutter">
  <option name="additionalArgs" value="--dart-define-from-file=config/dev.json" />
  <option name="filePath" value="$PROJECT_DIR$/lib/main.dart" />
  <method v="2" />
</configuration>
```

### 3. Redémarrer Android Studio

---

## ✅ Comment vérifier que tout fonctionne

Au lancement de l'application, vous devriez voir dans la console :

```
✅ Mode development détecté
📡 Supabase URL: https://lnoondakrogdriiwqtcp.supabase.co
🔑 Anon Key: eyJhbGci...
🌍 API URL: https://api-dev.boxtobikers.com
```

**Pas d'erreur "Configuration manquante" !** 🎉

---

## 📞 Besoin d'aide supplémentaire ?

1. **Vérifier la documentation** : `docs/development/ANDROID_STUDIO_LAUNCH.md`
2. **Vérifier les configurations** : `make check-run-configs`
3. **Tester depuis le terminal** : `make dev`

Si le problème persiste, c'est probablement un problème de configuration de l'IDE plutôt que de l'application elle-même.

