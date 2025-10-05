import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class CollectionDataForm extends StatelessWidget {
  // Controladores para os campos de texto
  final TextEditingController volumeController;
  final TextEditingController temperatureController;
  final TextEditingController phController;
  final TextEditingController tubeNumberController;
  final TextEditingController observationController;

  // Variáveis e callbacks para o Dropdown
  final String? selectedNumtanque;
  final ValueChanged<String?> onNumTanqueChanged;

  // Callbacks para os botões de ação
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onFazerColeta;
  final VoidCallback onRejeitarColeta;

  const CollectionDataForm({
    super.key,
    required this.volumeController,
    required this.temperatureController,
    required this.phController,
    required this.tubeNumberController,
    required this.observationController,
    required this.selectedNumtanque,
    required this.onNumTanqueChanged,
    required this.onSave,
    required this.onCancel,
    required this.onFazerColeta,
    required this.onRejeitarColeta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botões de Ação
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onFazerColeta,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green),
                ),
                child: const Text('Fazer Coleta'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: onRejeitarColeta,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text('Rejeitar Coleta'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Campos do Leite
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: volumeController,
                decoration: const InputDecoration(labelText: 'Volume (L)'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Obrigatório' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: temperatureController,
                decoration: const InputDecoration(
                  labelText: 'Temperatura (°C)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Obrigatório';
                  final temp = double.tryParse(value);
                  if (temp == null) return 'Somente números';
                  if (temp < 2.0 || temp > 9.0) return 'T fora do padrão';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: phController,
                decoration: const InputDecoration(labelText: 'Alizarol (GL)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Obrigatório';
                  final aliz = double.tryParse(value);
                  if (aliz == null) return 'Somente números';
                  if (aliz < 75.0 || aliz > 80.0) return 'GL fora do padrão';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedNumtanque,
                decoration: const InputDecoration(labelText: 'N° do Tanque'),
                items: ['1', '2', '3']
                    .map(
                      (label) =>
                          DropdownMenuItem(value: label, child: Text(label)),
                    )
                    .toList(),
                onChanged: onNumTanqueChanged,
                validator: (v) => (v == null) ? 'Obrigatório' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: tubeNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'N° da Amostra'),
          validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: observationController,
          decoration: const InputDecoration(
            labelText: 'Observações (Opcional)',
          ),
        ),
        const SizedBox(height: 32),
        // Botões Finais
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: onSave,
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
