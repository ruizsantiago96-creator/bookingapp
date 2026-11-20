import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import 'hotel_detail.dart';

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
            content: Text('No se pudo cerrar sesión. Inténtalo de nuevo.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  void _openHotelDetail() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const HotelDetail()),
    );
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
              child: Text('No se pudo cargar tu cuenta.'),
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
                  'Te damos la bienvenida, ${user?.displayName?.isNotEmpty == true ? user!.displayName : user?.email ?? 'viajero'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text('Has iniciado sesión en Booking App.'),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _signingOut ? null : _signOut,
                  child: Text(
                    _signingOut ? 'Cerrando sesión...' : 'Cerrar sesión',
                  ),
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
              'Encuentra tu estancia',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Descubre un lugar cómodo para tu próximo viaje.',
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
              'Estancia destacada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: InkWell(
                onTap: _openHotelDetail,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Un lugar para sentirte en casa',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Próximamente habrá detalles del hotel y disponibilidad en tiempo real.',
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 18),
                          SizedBox(width: 4),
                          Text('Explora destinos'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _openHotelDetail,
              child: const Text('Ver detalles del hotel'),
            ),
          ],
        ),
      ),
    );
  }
}
