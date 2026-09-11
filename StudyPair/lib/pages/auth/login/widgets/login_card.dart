import 'package:flutter/material.dart';

import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text_field.dart';
import 'package:study_pair/widgets/gap.dart';
import 'package:study_pair/widgets/app_text.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.loading,
    required this.onToggleObscure,
    required this.onGoogleSignIn,
    required this.onForgotPassword,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool loading;
  final VoidCallback onToggleObscure;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onForgotPassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GoogleButton(loading: loading, onPressed: onGoogleSignIn),

          const VGap.lg(),

          const _Divider(),

          const VGap.lg(),

          const _FieldLabelRow(
            label: 'Email académique',
            trailing: '@sorbonne-universite.fr, @*.edu',
          ),

          const VGap.sm(),

          AppTextField(
            controller: emailController,
            hint: 'etudiant@sorbonne-universite.fr',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(
              Icons.mail_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const VGap.lg(),

          _FieldLabelRow(
            label: 'Mot de passe',
            trailingWidget: GestureDetector(
              onTap: loading ? null : onForgotPassword,
              child: const AppText(
                'Mot de passe oublié ?',
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),

          const VGap.sm(),

          AppTextField(
            controller: passwordController,
            hint: '••••••••••••',
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onToggleObscure,
            ),
          ),

          const VGap.xl(),

          _PrimaryButton(loading: loading, onPressed: onSubmit),
        ],
      ),
    );
  }
}

class _FieldLabelRow extends StatelessWidget {
  const _FieldLabelRow({
    required this.label,
    this.trailing,
    this.trailingWidget,
  });

  final String label;
  final String? trailing;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, fontWeight: FontWeight.w700, fontSize: 14),
        if (trailingWidget != null) trailingWidget!,
        if (trailing != null)
          Flexible(
            child: AppText(
              trailing!,
              textAlign: TextAlign.right,
              fontWeight: FontWeight.w500,
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.inputBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: loading ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

                const HGap.md(),

                const Flexible(
                  child: AppText(
                    'Continuer avec Google',
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        const HGap.md(),

        const SizedBox(
          width: 150,
          child: AppText(
            'ou avec votre email institutionnel',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
            fontSize: 12.5,
            color: AppColors.textSecondary,
            maxLines: 3,
          ),
        ),

        const HGap.md(),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: loading ? null : onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17),
            child: loading
                ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        'Se connecter',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                      ),

                      HGap.sm(),

                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
