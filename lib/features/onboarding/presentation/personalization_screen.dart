import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../app/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_mascot.dart';
import '../../../core/widgets/pip_misc.dart';

/// Personalization — language selection (step 1) then "What are you
/// practicing for?" (step 2), matching the Stitch `choose_language` and
/// goal screens.
class PersonalizationScreen extends ConsumerStatefulWidget {
  const PersonalizationScreen({super.key, this.initialStep = 0});

  final int initialStep;

  @override
  ConsumerState<PersonalizationScreen> createState() =>
      _PersonalizationScreenState();
}

class _PersonalizationScreenState
    extends ConsumerState<PersonalizationScreen> {
  late int _step = widget.initialStep;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final language = ref.watch(selectedLanguageProvider);
    final goal = ref.watch(selectedGoalProvider);
    final isLang = _step == 0;

    return Scaffold(
      appBar: pipAppBar(context,
          title: 'Setup',
          showBack: isLang ? false : true,
          onBack: isLang ? null : () => setState(() => _step = 0)),
      body: Stack(children: [
        const AmbientBlobs(),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      StepProgress(step: _step + 1, total: 2),
                ),
                const SizedBox(height: 16),
                PipMascot(
                    asset:
                        isLang ? PipAsset.happy : PipAsset.stage,
                    size: 72,
                    showBadge: false),
                const SizedBox(height: 8),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    Text(
                        isLang
                            ? 'What language will you speak?'
                            : 'What are you practicing for?',
                        textAlign: TextAlign.center,
                        style: text.headlineMedium
                            ?.copyWith(color: scheme.primary)),
                    const SizedBox(height: 8),
                    Text(
                      isLang
                          ? 'Pip tunes accent detection and feedback to your choice.'
                          : 'Pip will tailor your drills and feedback to match.',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: isLang
                      ? _languageList(language)
                      : _goalGrid(goal),
                ),
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: PrimaryButton(
                    label:
                        isLang ? 'Continue' : 'Start Practicing',
                    icon: isLang
                        ? Icons.arrow_forward
                        : Icons.mic_external_on,
                    onPressed: () {
                      if (isLang) {
                        setState(() => _step = 1);
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _languageList(String selected) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: kLanguages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final o = kLanguages[i];
        final sel = o.code == selected;
        return Semantics(
          button: true,
          selected: sel,
          label: o.label,
          child: InkWell(
            onTap: () => ref
                .read(selectedLanguageProvider.notifier)
                .state = o.code,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel
                      ? scheme.primary
                      : scheme.outlineVariant
                          .withValues(alpha: 0.35),
                  width: sel ? 2 : 1,
                ),
                boxShadow: sel
                    ? const [
                        BoxShadow(
                            color: Color.fromRGBO(27, 42, 107, 0.12),
                            blurRadius: 16,
                            offset: Offset(0, 6))
                      ]
                    : null,
              ),
              child: Row(children: [
                Text(o.flag, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(o.label,
                      style: text.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface)),
                ),
                Icon(
                    sel
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: sel
                        ? scheme.primary
                        : scheme.outlineVariant),
              ]),
            ),
          ),
        );
      },
    );
  }

  Widget _goalGrid(String selected) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: kGoals.length,
      itemBuilder: (_, i) {
        final g = kGoals[i];
        final sel = g.id == selected;
        return Semantics(
          button: true,
          selected: sel,
          label: g.label,
          child: InkWell(
            onTap: () => ref
                .read(selectedGoalProvider.notifier)
                .state = g.id,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: sel
                    ? AppColors.secondaryFixed
                        .withValues(alpha: 0.35)
                    : scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel
                      ? scheme.primary
                      : scheme.outlineVariant
                          .withValues(alpha: 0.35),
                  width: sel ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(g.icon,
                      size: 28,
                      color: sel
                          ? scheme.primary
                          : AppColors.secondary),
                  const SizedBox(height: 6),
                  Text(g.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelLarge
                          ?.copyWith(color: scheme.onSurface)),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Text(g.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
