import 'package:flutter/material.dart';

class MedicationPage extends StatelessWidget {
  const MedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Espacio superior
            const SizedBox(height: 20),

            // Información del medicamento
            _buildMedicationInfo(
              medicationName: 'Aspirina',
              dosage: '500 mg',
              frequency: 'Cada 4 horas',
              imageUrl: 'https://via.placeholder.com/200', // URL de la imagen del medicamento
            ),

            // Espacio entre la información del medicamento y las opciones de configuración
            const SizedBox(height: 20),

            // Opciones de configuración de medicamentos
            _buildSettingsOption(
              title: 'Agregar nuevo medicamento',
              icon: Icons.add_circle_outline,
              onPressed: () {
                // Lógica para agregar un nuevo medicamento
              },
            ),
            _buildSettingsOption(
              title: 'Editar medicamento',
              icon: Icons.edit,
              onPressed: () {
                // Lógica para editar un medicamento existente
              },
            ),
            _buildSettingsOption(
              title: 'Eliminar medicamento',
              icon: Icons.delete,
              onPressed: () {
                // Lógica para eliminar un medicamento
              },
            ),

            // Puedes agregar más opciones de configuración aquí

            // Espacio inferior
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationInfo({
    required String medicationName,
    required String dosage,
    required String frequency,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del medicamento
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(imageUrl),
          ),
          // Espacio entre la imagen y el nombre del medicamento
          const SizedBox(height: 20),
          // Nombre del medicamento
          Text(
            'Nombre del medicamento: $medicationName',
            style: const TextStyle(fontSize: 18),
          ),
          // Espacio entre el nombre del medicamento y la dosis
          const SizedBox(height: 10),
          // Dosis del medicamento
          Text(
            'Dosis: $dosage',
            style: const TextStyle(fontSize: 18),
          ),
          // Espacio entre la dosis y la frecuencia
          const SizedBox(height: 10),
          // Frecuencia del medicamento
          Text(
            'Frecuencia: $frequency',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({required String title, required IconData icon, required VoidCallback onPressed}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Colors.blue,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: onPressed,
    );
  }
}
