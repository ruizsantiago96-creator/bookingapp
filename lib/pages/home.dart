import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import 'hotel_detail.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.authService});

  final AuthService? authService;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final AuthService _auth;
  late final Stream<AuthUser?> _userChanges;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _auth = widget.authService ?? FirebaseAuthService();
    _userChanges = _auth.userChanges;
  }

  Future<void> _signOut() async {
    setState(() => _signingOut = true);
    try {
      await _auth.signOut();
    } on AuthFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to sign out. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  Widget _accountCard(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: _userChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Unable to load your account.'),
            ),
          );
        }

        final user = snapshot.data;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user == null
                      ? 'Your account'
                      : 'Welcome, ${user.displayName?.isNotEmpty == true ? user.displayName : user.email ?? 'traveler'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  user == null
                      ? 'Sign in or create an account to save your stays.'
                      : 'You are signed in to Booking App.',
                ),
                const SizedBox(height: 12),
                if (user == null) ...[
                  FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SignIn(authService: _auth),
                      ),
                    ),
                    child: const Text('Sign in'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SignUp(authService: _auth),
                      ),
                    ),
                    child: const Text('Create an account'),
                  ),
                ] else
                  OutlinedButton(
                    onPressed: _signingOut ? null : _signOut,
                    child: Text(_signingOut ? 'Signing out...' : 'Sign out'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),
            Text(
              'Find your stay',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Discover a comfortable place for your next trip.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _accountCard(context),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'images/home.jpg',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Featured stay',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A place to call home',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hotel details and live availability are coming soon.',
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 18),
                        SizedBox(width: 4),
                        Text('Explore destinations'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const HotelDetail()),
                );
              },
              child: const Text('View hotel details'),
            ),
          ],
        ),
      ),
    );
  }
}
