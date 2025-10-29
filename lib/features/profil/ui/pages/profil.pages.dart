import 'package:boxtobikers/core/app/app_router.dart';
import 'package:boxtobikers/core/app/helpers/app_session.helpers.dart';
import 'package:boxtobikers/core/auth/providers/app_auth.provider.dart';
import 'package:boxtobikers/features/profil/business/models/user_profile.model.dart';
import 'package:boxtobikers/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilPages extends StatefulWidget {
  const ProfilPages({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilPagesState();
}

class _ProfilPagesState extends State<ProfilPages> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour les champs de texte
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _dateOfBirthController;

  DateTime? _selectedDate;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    // Récupérer le profil depuis le AuthProvider
    final authProvider = context.read<AppAuthProvider>();
    final userSession = authProvider.currentSession;
    final userProfile = userSession?.profile;

    // Si pas de profil (ne devrait pas arriver), utiliser un profil par défaut
    final profile = userProfile ?? UserProfileModel.createVisitor();

    _selectedDate = profile.birthdate;

    // Initialisation des controllers avec les données du profil réel
    _firstNameController = TextEditingController(text: profile.firstName);
    _lastNameController = TextEditingController(text: profile.lastName);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _addressController = TextEditingController(text: profile.address);
    _dateOfBirthController = TextEditingController(
      text: profile.birthdate != null
          ? DateFormat('dd/MM/yyyy').format(profile.birthdate!)
          : '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    // Récupérer les valeurs actuelles depuis le provider
    final authProvider = context.read<AppAuthProvider>();
    final currentProfile = authProvider.currentSession?.profile;

    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing && currentProfile != null) {
        // Annuler les modifications - restaurer les valeurs originales
        _firstNameController.text = currentProfile.firstName;
        _lastNameController.text = currentProfile.lastName;
        _emailController.text = currentProfile.email;
        _phoneController.text = currentProfile.phone;
        _addressController.text = currentProfile.address;
        _selectedDate = currentProfile.birthdate;
        _dateOfBirthController.text = currentProfile.birthdate != null
            ? DateFormat('dd/MM/yyyy').format(currentProfile.birthdate!)
            : '';
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AppAuthProvider>();
      final currentSession = authProvider.currentSession;

      if (currentSession == null) {
        // Ne devrait pas arriver, mais on gère quand même
        return;
      }

      // Créer le nouveau profil avec les données modifiées
      final updatedProfile = UserProfileModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        birthdate: _selectedDate,
      );

      // Créer une nouvelle session avec le profil mis à jour
      final updatedSession = currentSession.copyWith(
        profile: updatedProfile,
        email: _emailController.text,
      );

      // Sauvegarder la session mise à jour
      // Le AuthProvider se chargera de notifier les listeners
      // et le SessionService sauvegardera dans SharedPreferences
      await authProvider.updateSession(updatedSession);

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(S.of(context).profilSaveSuccess),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final l10n = S.of(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 48,
          ),
          // title: Text(l10n.profilDeleteDialogTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profilDeleteDialogMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.profilDeleteDialogWarning,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implémenter la logique de suppression du compte
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(l10n.profilDeleteAccountInfo),
                        ),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: Text(l10n.commonConfirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    // Constantes pour le design de profil
    const double avatarRadius = 50.0;
    final double headerImageHeight = MediaQuery.of(context).size.height / 4;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SafeArea(
        child: Stack(
          children: [
            // Contenu principal avec formulaire
            Column(
              children: [
                // Espace pour le header image
                SizedBox(height: headerImageHeight),
                // Espace pour la moitié inférieure de l'avatar
                SizedBox(height: avatarRadius + 16),
                // Zone de contenu scrollable avec formulaire
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        // Section Informations personnelles
                        Text(
                          l10n.profilPersonalInfoTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Prénom
                        TextFormField(
                          controller: _firstNameController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: l10n.profilFirstNameLabel,
                            prefixIcon: const Icon(Icons.person_outline),
                            border: const OutlineInputBorder(),
                            filled: !_isEditing,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.profilFirstNameError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Nom
                        TextFormField(
                          controller: _lastNameController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: l10n.profilLastNameLabel,
                            prefixIcon: const Icon(Icons.person),
                            border: const OutlineInputBorder(),
                            filled: !_isEditing,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.profilLastNameError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Date de naissance
                        TextFormField(
                          controller: _dateOfBirthController,
                          enabled: _isEditing,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: l10n.profilBirthDateLabel,
                            prefixIcon: const Icon(Icons.cake_outlined),
                            border: const OutlineInputBorder(),
                            filled: !_isEditing,
                            suffixIcon: _isEditing
                                ? IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            )
                                : null,
                          ),
                          onTap: _isEditing ? () => _selectDate(context) : null,
                        ),
                        const SizedBox(height: 24),

                        // Section Contact
                        Text(
                          l10n.profilContactTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: l10n.profilEmailLabel,
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: const OutlineInputBorder(),
                            filled: !_isEditing,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.profilEmailError;
                            }
                            if (!value.contains('@')) {
                              return l10n.profilEmailInvalidError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Téléphone
                        TextFormField(
                          controller: _phoneController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: l10n.profilPhoneLabel,
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: const OutlineInputBorder(),
                            filled: !_isEditing,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.profilPhoneError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Section Adresse
                        Text(
                          l10n.profilAddressTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Adresse
                        TextFormField(
                          controller: _addressController,
                          enabled: _isEditing,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: l10n.profilAddressLabel,
                            prefixIcon: const Icon(Icons.home_outlined),
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder(),
                            filled: !_isEditing,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.profilAddressError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Boutons d'action
                        if (_isEditing) ...[
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.tonal(
                                  onPressed: _toggleEdit,
                                  child: Text(l10n.commonCancel),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FilledButton(
                                  onPressed: _saveProfile,
                                  child: Text(l10n.commonSave),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          FilledButton.icon(
                            onPressed: _toggleEdit,
                            icon: const Icon(Icons.edit),
                            label: Text(l10n.profilEditButton),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          // Bouton Supprimer le compte
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: () => _showDeleteAccountDialog(context),
                              icon: const Icon(Icons.delete_outline),
                              label: Text(l10n.profilDeleteAccountButton),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.error,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Header image - DESSOUS
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  height: headerImageHeight,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/btb_header_paris_arc_de_triomphe.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Bouton retour - AU DESSUS de l'image
            Positioned(
              top: 8.0,
              left: 24.0,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  AppRouter.goBack(context);
                },
              ),
            ),
            // Avatar + badge caméra - AU PREMIER PLAN, centré et superposé sur le bord de l'image
            Positioned(
              top: headerImageHeight - avatarRadius,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Avatar principal
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Consumer<AppAuthProvider>(
                        builder: (context, authProvider, _) {
                          final profile = authProvider.currentSession?.profile;
                          final initials = AppSessionHelpers.getInitials(profile);

                          return CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              initials,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Badge de modification - AU PREMIER PLAN
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        color: Theme.of(context).colorScheme.primary,
                        shape: const CircleBorder(),
                        elevation: 4,
                        shadowColor: Colors.black.withValues(alpha: 0.3),
                        child: InkWell(
                          onTap: () {
                            print('Camera icon tapped!'); // Debug
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.info_outline),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(l10n.profilPhotoChangeInfo),
                                    ),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
