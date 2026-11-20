import 'package:flutter/material.dart';

class HotelDetail extends StatelessWidget {
  const HotelDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del hotel')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'images/home.jpg',
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          Text('Un lugar para sentirte en casa', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Próximamente habrá información del hotel y disponibilidad en tiempo real.'),
          const SizedBox(height: 24),
          Text('Servicios', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(avatar: Icon(Icons.wifi), label: Text('Wi-Fi')),
              Chip(avatar: Icon(Icons.local_parking_outlined), label: Text('Estacionamiento')),
              Chip(avatar: Icon(Icons.restaurant_outlined), label: Text('Restaurante')),
            ],
          ),
          const SizedBox(height: 24),
          const FilledButton(
            onPressed: null,
            child: Text('Reservas disponibles próximamente'),
          ),
        ],
      ),
    );
  }
}
