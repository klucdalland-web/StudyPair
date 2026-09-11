import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/utils/validators.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/app_text_field.dart';
import 'package:study_pair/widgets/gap.dart';

class RegisterForm extends StatefulWidget {
  final bool acceptTerms;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onSubmit;

  const RegisterForm({
    super.key,
    required this.acceptTerms,
    required this.onTermsChanged,
    required this.onSubmit,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || !widget.acceptTerms) return;
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bouton Google
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Google
                Image.asset(
                  'assets/images/google-logo.svg',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.g_mobiledata,
                      size: 22,
                      color: AppColors.primary,
                    );
                  },
                ),

                const HGap.sm(),
                const AppText(
                  'S\'inscrire avec Google',
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          const VGap.lg(),

          // Séparateur
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              const HGap.md(),
              const AppText(
                'OU AVEC VOTRE EMAIL D\'UNIVERSITÉ',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              const HGap.md(),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          const VGap.lg(),

          // Champ Prénom & Nom
          const _FieldLabelRow(label: 'Prénom & Nom', trailing: 'Obligatoire'),
          const VGap.sm(),
          AppTextField(
            controller: _nameController,
            hint: 'Ex. Camille Bernard',
            textInputAction: TextInputAction.next,
            validator: Validators.name,
            prefixIcon: Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const VGap.lg(),

          // Champ Email
          const _FieldLabelRow(
            label: 'Email',
            trailing: 'Obligatoire',
          ),
          const VGap.sm(),
          AppTextField(
            controller: _emailController,
            hint: 'nom.prenom@exemple.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.email,
            prefixIcon: Icon(
              Icons.mail_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const VGap.lg(),

          // Champ Mot de passe
          const _FieldLabelRow(label: 'Mot de passe', trailing: '8+ caractères'),
          const VGap.sm(),
          AppTextField(
            controller: _passwordController,
            hint: '••••••••••••',
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            validator: (value) => Validators.password(value, minLength: 8),
            onSubmitted: (_) => _handleSubmit(),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
          const VGap.lg(),

          // Case à cocher pour accepter les conditions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: widget.acceptTerms,
                  onChanged: widget.onTermsChanged,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const HGap.sm(),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: "J'accepte la "),
                      TextSpan(
                        text: 'Charte de bienveillance académique',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text:
                            ' et le traitement de mes données conformément au',
                      ),
                      TextSpan(
                        text: ' RGPD.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const VGap.xl(),

          // Bouton de validation
          ElevatedButton(
            onPressed: widget.acceptTerms ? _handleSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  'Créer mon compte et continuer',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                HGap.sm(),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget privé pour les labels au-dessus des champs
class _FieldLabelRow extends StatelessWidget {
  final String label;
  final String? trailing;

  const _FieldLabelRow({required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: AppColors.textPrimary,
        ),
        if (trailing != null)
          AppText(
            trailing!,
            fontWeight: FontWeight.w500,
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
      ],
    );
  }
}
