import 'package:flutter/material.dart';
import '../core/auth_state.dart';
import '../core/ui_helpers.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onAuthenticated});

  final VoidCallback onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _BrandFeature extends StatelessWidget {
  const _BrandFeature({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Color(0xFFCBD9CF), fontSize: 12)),
              ],
            ),
          ),
        ],
      );
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();

  bool _obscureLoginPassword = true;
  bool _obscureSignupPassword = true;
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final res = await AuthManager.instance.login(
        _loginEmailController.text.trim(),
        _loginPasswordController.text,
      );
      if (res.success && mounted) {
        widget.onAuthenticated();
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = friendlyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleSignup() async {
    if (!_signupFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final res = await AuthManager.instance.register(
        _signupNameController.text.trim(),
        _signupEmailController.text.trim(),
        _signupPasswordController.text,
      );
      if (res.success && mounted) {
        widget.onAuthenticated();
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = friendlyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fillDemoAccount() {
    _tabController.animateTo(0);
    _loginEmailController.text = 'alex@unbound.ai';
    _loginPasswordController.text = 'unbound2026';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo credentials loaded. Click "Sign In" or "Create Account" if first time!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: ColoredBox(
        color: UnboundTheme.canvas,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, viewport) => SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1060),
                  child: LayoutBuilder(
                    builder: (context, box) {
                      final desktop = box.maxWidth >= 760;
                      final brand = _buildBrandPanel(desktop);
                      final form = _buildAuthCard(theme, colorScheme);
                      if (desktop) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(minHeight: viewport.maxHeight - 48),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: brand),
                              const SizedBox(width: 28),
                              Expanded(child: form),
                            ],
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [brand, const SizedBox(height: 20), form],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandPanel(bool desktop) {
    return Container(
      constraints: BoxConstraints(minHeight: desktop ? 540 : 0),
      padding: EdgeInsets.all(desktop ? 38 : 24),
      decoration: BoxDecoration(
        color: UnboundTheme.forestDeep,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.hub_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text('unbound', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700, letterSpacing: -.5)),
            ],
          ),
          if (desktop) ...[
            const SizedBox(height: 44),
            const Text(
              'Make room for\nyour best thinking.',
              style: TextStyle(color: Colors.white, fontSize: 38, height: 1.12, fontWeight: FontWeight.w700, letterSpacing: -1.1),
            ),
            const SizedBox(height: 16),
            const Text(
              'A calmer place to shape ideas, plan your day, and keep the important things moving.',
              style: TextStyle(color: Color(0xFFD1DED5), fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 30),
            const _BrandFeature(icon: Icons.account_tree_outlined, title: 'Think visually', subtitle: 'Turn loose ideas into clear maps.'),
            const SizedBox(height: 18),
            const _BrandFeature(icon: Icons.check_circle_outline, title: 'Move with focus', subtitle: 'Keep the next right task in view.'),
            const SizedBox(height: 18),
            const _BrandFeature(icon: Icons.auto_awesome_outlined, title: 'Let AI help', subtitle: 'Find summaries and useful next steps.'),
            const SizedBox(height: 36),
            const Text('A little more clarity, every day.', style: TextStyle(color: Color(0xFFB9CBBE), fontSize: 12)),
          ] else ...[
            const SizedBox(height: 12),
            const Text('Make room for your best thinking.', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700, letterSpacing: -.4)),
            const SizedBox(height: 6),
            const Text('Ideas, notes, and plans in one calm workspace.', style: TextStyle(color: Color(0xFFD1DED5), fontSize: 13)),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome back', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -.5)),
            const SizedBox(height: 6),
            Text('Pick up where your thoughts left off.', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(color: const Color(0xFFF2F4EF), borderRadius: BorderRadius.circular(14)),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(color: UnboundTheme.forest, borderRadius: BorderRadius.circular(12)),
                labelColor: Colors.white,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                tabs: const [Tab(text: 'Sign in'), Tab(text: 'Create account')],
              ),
            ),
            const SizedBox(height: 18),
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: colorScheme.errorContainer, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Icon(Icons.error_outline, color: colorScheme.onErrorContainer, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_errorMessage!, style: TextStyle(color: colorScheme.onErrorContainer, fontSize: 13))),
                ]),
              ),
              const SizedBox(height: 14),
            ],
            SizedBox(
              height: 290,
              child: TabBarView(
                controller: _tabController,
                children: [_buildLoginForm(colorScheme), _buildSignupForm(colorScheme)],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _loading ? null : _fillDemoAccount,
              icon: const Icon(Icons.bolt_rounded, size: 18),
              label: const Text('Fill demo account'),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(46)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(ColorScheme scheme) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
            validator: (v) =>
                v == null || !v.contains('@') ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _loginPasswordController,
            obscureText: _obscureLoginPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureLoginPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscureLoginPassword = !_obscureLoginPassword),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
            validator: (v) =>
                v == null || v.length < 6 ? 'Password must be >= 6 characters' : null,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _handleLogin,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text('Sign In to Unbound', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm(ColorScheme scheme) {
    return Form(
      key: _signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _signupNameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
            validator: (v) =>
                v == null || v.trim().length < 2 ? 'Name must be at least 2 characters' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _signupEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
            validator: (v) =>
                v == null || !v.contains('@') ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _signupPasswordController,
            obscureText: _obscureSignupPassword,
            decoration: InputDecoration(
              labelText: 'Create Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureSignupPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscureSignupPassword = !_obscureSignupPassword),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
            validator: (v) =>
                v == null || v.length < 6 ? 'Password must be >= 6 characters' : null,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _loading ? null : _handleSignup,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text('Create Free Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
