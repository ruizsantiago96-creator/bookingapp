import 'package:flutter/material.dart';

class HotelDetail extends StatelessWidget {
  const HotelDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel details')),
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
          Text('A place to call home', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Hotel information and live availability are coming soon.'),
          const SizedBox(height: 24),
          Text('Amenities', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(avatar: Icon(Icons.wifi), label: Text('Wi-Fi')),
              Chip(avatar: Icon(Icons.local_parking_outlined), label: Text('Parking')),
              Chip(avatar: Icon(Icons.restaurant_outlined), label: Text('Dining')),
            ],
          ),
          const SizedBox(height: 24),
          const FilledButton(
            onPressed: null,
            child: Text('Booking available soon'),
          ),
        ],
      ),
    );
  }
}
