import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'voting_provider.dart';
import 'language_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleKey;
  final bool implyLeading;
  final bool showLanguageToggle;

  const CustomAppBar({
    super.key,
    required this.titleKey,
    this.implyLeading = true,
    this.showLanguageToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return AppBar(
      automaticallyImplyLeading: implyLeading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/logo.png', width: 40, height: 40, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Text(lang.translate(titleKey), style: const TextStyle(fontSize: 20)),
        ],
      ),
      actions: showLanguageToggle
          ? [
              IconButton(
                icon: const Icon(Icons.language),
                onPressed: () => context.read<LanguageProvider>().toggleLanguage(),
                tooltip: lang.translate('language'),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    lang.currentLang.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _epicController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'welcome_title', showLanguageToggle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 2),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(65),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  lang.translate('welcome_title'),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  lang.translate('welcome_subtitle'),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _epicController,
                  decoration: InputDecoration(
                    labelText: lang.translate('enter_epic'),
                    hintText: lang.translate('hint_epic'),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_epicController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(lang.translate('please_enter_id'))),
                            );
                            return;
                          }
                          setState(() => _isLoading = true);
                          await context.read<VotingProvider>().fetchVoterData(_epicController.text.trim());
                          setState(() => _isLoading = false);

                          if (!mounted) return;
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const EligibilityScreen()));
                        },
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(lang.translate('verify_id')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VotingProvider>();
    final lang = context.watch<LanguageProvider>();
    final voter = provider.voterData;

    if (voter == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'eligibility_check'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, double value, child) {
            return Transform.scale(scale: 0.95 + (0.05 * value), child: Opacity(opacity: value, child: child));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${lang.translate('name')}${voter.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('${lang.translate('age')}${voter.age}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('${lang.translate('constituency')}${voter.constituency}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (!provider.isEligible) ...[
                const Icon(Icons.cancel, color: Colors.redAccent, size: 50),
                const SizedBox(height: 16),
                Text(
                  lang.translate('not_eligible'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  lang.translate('age_restriction'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(lang.translate('back')),
                ),
              ] else ...[
                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                const SizedBox(height: 16),
                Text(
                  lang.translate('eligible'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          await context.read<VotingProvider>().fetchLocation();
                          setState(() => _isLoading = false);
                          if (!mounted) return;
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ModeSelectionScreen()));
                        },
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(lang.translate('verify_loc')),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VotingProvider>();
    final lang = context.watch<LanguageProvider>();
    final isLocal = provider.isLocalVoter;

    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'voting_mode'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(isLocal ? Icons.location_on : Icons.public, size: 70, color: Theme.of(context).primaryColor),
              const SizedBox(height: 24),
              Text(
                '${lang.translate('your_loc')}${provider.currentLocation}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${lang.translate('constituency')}${provider.voterData?.constituency}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Text(
                      isLocal ? lang.translate('local_mode') : lang.translate('remote_mode'),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isLocal ? lang.translate('local_msg') : lang.translate('remote_msg'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => isLocal ? const LocalVotingScreen() : const RemoteVotingScreen()),
                  );
                },
                child: Text(lang.translate('continue')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocalVotingScreen extends StatelessWidget {
  const LocalVotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'local_voting'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, double value, child) {
            return Opacity(opacity: value, child: child);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.how_to_vote, size: 70, color: Theme.of(context).primaryColor),
              const SizedBox(height: 24),
              Text(lang.translate('visit_local'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(lang.translate('local_steps'), style: const TextStyle(fontSize: 16)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const VerificationScreen(isLocal: true)));
                },
                child: Text(lang.translate('start_verify')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RemoteVotingScreen extends StatelessWidget {
  const RemoteVotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'remote_voting'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, double value, child) {
            return Opacity(opacity: value, child: child);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.business, size: 70, color: Theme.of(context).primaryColor),
              const SizedBox(height: 24),
              Text(lang.translate('visit_remote'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(lang.translate('remote_steps'), style: const TextStyle(fontSize: 16)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const VerificationScreen(isLocal: false)));
                },
                child: Text(lang.translate('proceed_avn')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationScreen extends StatefulWidget {
  final bool isLocal;
  const VerificationScreen({super.key, required this.isLocal});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  int _step = 0;
  bool _isScanning = false;

  void _startScan() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate scanning time
    if (!mounted) return;
    setState(() {
      _isScanning = false;
      _step++;
    });
    if (_step == 2) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VotingInterfaceScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'verification'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Column(
              key: ValueKey<String>('$_step-$_isScanning'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_step == 0) ...[
                  _isScanning 
                      ? ScannerAnimation(icon: widget.isLocal ? Icons.assignment_ind : Icons.fingerprint)
                      : Icon(widget.isLocal ? Icons.assignment_ind : Icons.fingerprint, size: 100, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 24),
                  Text(
                    widget.isLocal ? lang.translate('basic_id') : lang.translate('bio_scan'),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isScanning ? null : _startScan,
                    child: _isScanning ? const CircularProgressIndicator(color: Colors.white) : Text(lang.translate('verify')),
                  ),
                ] else if (_step == 1) ...[
                  _isScanning 
                      ? const ScannerAnimation(icon: Icons.face)
                      : Icon(Icons.face, size: 100, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 24),
                  Text(
                    widget.isLocal ? lang.translate('voter_match') : lang.translate('face_check'),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isScanning ? null : _startScan,
                    child: _isScanning ? const CircularProgressIndicator(color: Colors.white) : Text(lang.translate('verify')),
                  ),
                ] else ...[
                  const Icon(Icons.check_circle, color: Colors.green, size: 100),
                  const SizedBox(height: 24),
                  Text(lang.translate('completing'), style: const TextStyle(fontSize: 18)),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScannerAnimation extends StatefulWidget {
  final IconData icon;
  const ScannerAnimation({super.key, required this.icon});

  @override
  State<ScannerAnimation> createState() => _ScannerAnimationState();
}

class _ScannerAnimationState extends State<ScannerAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(widget.icon, size: 100, color: Theme.of(context).primaryColor.withOpacity(0.3)),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: 10 + (_controller.value * 80),
                child: Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    boxShadow: [
                      BoxShadow(color: Colors.greenAccent.withOpacity(0.8), blurRadius: 15, spreadRadius: 3),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class VotingInterfaceScreen extends StatefulWidget {
  const VotingInterfaceScreen({super.key});

  @override
  State<VotingInterfaceScreen> createState() => _VotingInterfaceScreenState();
}

class _VotingInterfaceScreenState extends State<VotingInterfaceScreen> {
  String? _selectedParty;
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> parties = [
    {'name': 'Party A', 'icon': Icons.star},
    {'name': 'Party B', 'icon': Icons.favorite},
    {'name': 'Party C', 'icon': Icons.wb_sunny},
    {'name': 'NOTA', 'icon': Icons.block},
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'cast_vote', implyLeading: false, showLanguageToggle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              lang.translate('select_symbol'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: parties.length,
                itemBuilder: (context, index) {
                  final party = parties[index];
                  final isSelected = _selectedParty == party['name'];
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedParty = party['name']),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300, width: isSelected ? 3 : 1),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
                          boxShadow: isSelected ? [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] : [],
                        ),
                        child: Row(
                          children: [
                            Icon(party['icon'], size: 40, color: isSelected ? Theme.of(context).primaryColor : Colors.black87),
                            const SizedBox(width: 20),
                            Text(party['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            if (isSelected) Icon(Icons.check_circle, size: 28, color: Theme.of(context).primaryColor),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _selectedParty == null || _isSubmitting
                  ? null
                  : () async {
                      setState(() => _isSubmitting = true);
                      await context.read<VotingProvider>().submitVote();
                      if (!mounted) return;
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ConfirmationScreen()));
                    },
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(lang.translate('submit_vote'), style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VotingProvider>();
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: const CustomAppBar(titleKey: 'vote_success', implyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, double value, child) {
            return Transform.scale(scale: value, child: Opacity(opacity: value.clamp(0.0, 1.0), child: child));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.verified, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                lang.translate('vote_success'),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                lang.translate('vote_enc'),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Text(lang.translate('conf_id'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      provider.confirmationId ?? '',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  provider.resetApp();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: Text(lang.translate('back_home')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
