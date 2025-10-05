// lib/views/form_rejection_view.dart

import 'package:flutter/material.dart';

class RejectionDataForm extends StatelessWidget {
  // Controladores para campos condicionais
  final TextEditingController volumeController;
  final TextEditingController temperatureController;
  final TextEditingController phController;

  // Variáveis e callbacks para o Dropdown de motivo
  final String? selectedRejectionReason;
  final List<String> rejectionReasons;
  final ValueChanged<String?> onReasonChanged;

  // Callbacks para os botões de ação
  final VoidCallback onSave;
  final VoidCallback onGoBack;

  const RejectionDataForm({
    super.key,
    required this.volumeController,
    required this.temperatureController,
    required this.phController,
    required this.selectedRejectionReason,
    required this.rejectionReasons,
    required this.onReasonChanged,
    required this.onSave,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedRejectionReason,
          decoration: const InputDecoration(labelText: 'Motivo da Rejeição'),
          items: rejectionReasons.map((String reason) {
            return DropdownMenuItem<String>(
              value: reason,
              child: Text(reason, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: onReasonChanged,
          validator: (value) => value == null ? 'Campo obrigatório' : null,
        ),
        const SizedBox(height: 16),

        // Mostra os campos de dados do leite se o motivo 1 for selecionado
        if (selectedRejectionReason == rejectionReasons[0])
          ..._buildMilkDataFieldsForRejection(),

        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onGoBack,
                child: const Text('Voltar'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Salvar Rejeição'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper para construir os campos condicionais
  List<Widget> _buildMilkDataFieldsForRejection() {
    return [
      const SizedBox(height: 16),
      const Text(
        "Informe os dados para registro:",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: volumeController,
              decoration: const InputDecoration(labelText: 'Volume (L)'),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: temperatureController,
              decoration: const InputDecoration(labelText: 'Temperatura (°C)'),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: phController,
        decoration: const InputDecoration(labelText: 'Alizarol (GL)'),
        keyboardType: TextInputType.number,
        validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
      ),
    ];
  }
}
