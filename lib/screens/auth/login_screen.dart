import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  final bool isAdminLogin;
  const LoginScreen({super.key, this.isAdminLogin = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _idCtrl;
  late TextEditingController _passCtrl;
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _idCtrl = TextEditingController();
    _passCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_idCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      setState(() => _errorMsg = 'Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);
    final appState = context.read<AppState>();

    final success = await appState.loginUser(
      _idCtrl.text.trim(),
      _passCtrl.text,
      widget.isAdminLogin,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      appState.notifyListeners();
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isAdminLogin ? '🛡 Welcome Admin' : '👤 Welcome ${appState.userId ?? 'Student'}',
          ),
          backgroundColor: AppTheme.textPrimary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      setState(() => _errorMsg = 'Invalid ID or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdminLogin ? 'Admin Login' : 'Student Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isAdminLogin ? Icons.shield_rounded : Icons.person_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              widget.isAdminLogin ? 'Admin Portal' : 'Student Portal',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isAdminLogin
                  ? 'Enter your admin credentials'
                  : 'Enter your student ID and password',
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 32),
            if (_errorMsg != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.danger.withOpacity(0.1),
                  border: Border.all(color: AppTheme.danger.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _errorMsg!,
                  style: const TextStyle(
                    color: AppTheme.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            const Text(
              'ID / Username',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _idCtrl,
              decoration: InputDecoration(
                hintText: widget.isAdminLogin ? 'ADMIN001' : 'S001',
                prefixIcon: const Icon(Icons.badge_rounded),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '••••••••',
                prefixIcon: Icon(Icons.lock_rounded),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Login'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text.rich(
                TextSpan(
                  text: widget.isAdminLogin
                      ? 'Demo: ADMIN001 / admin123'
                      : 'Demo: S001 / pass123',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
