import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Espacio superior
            const SizedBox(height: 20),

            // Título de la página
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Notificaciones',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Espacio entre el título y las notificaciones
            const SizedBox(height: 20),

            // Notificación 1
            _buildNotification(
              title: 'Nuevo mensaje',
              content: '¡Tienes un nuevo mensaje de un amigo!',
            ),

            // Espacio entre notificaciones
            const SizedBox(height: 20),

            // Notificación 2
            _buildNotification(
              title: 'Recordatorio de evento',
              content: 'Recuerda asistir al evento de mañana a las 10:00 AM',
            ),

            // Puedes agregar más notificaciones aquí

            // Espacio inferior
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotification({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la notificación
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              // Espacio entre el título y el contenido
              const SizedBox(height: 8),
              // Contenido de la notificación
              Text(
                content,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
