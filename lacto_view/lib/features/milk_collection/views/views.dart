import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/model.dart';
import '../view_models/view_models.dart';

class Producer {
  final int id;
  final String name;
  final String propertyName;
  Producer({required this.id, required this.name, required this.propertyName});
}

class MilkCollectionFormView extends StatefulWidget {
  const MilkCollectionFormView({super.key});

  @override
  State<MilkCollectionFormView> createState() => _MilkCollectionFormViewState();
}

class _MilkCollectionFormViewState extends State<MilkCollectionFormView> {
  final _formKey = GlobalKey<FormState>();

  final _searchController = TextEditingController();
  final _volumeController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _phController = TextEditingController();
  final _observationController = TextEditingController(); // NOME CORRIGIDO
  final _tubeNumberController = TextEditingController();

  // CORREÇÃO DE ERRO DE DIGITAÇÃO: _selectedProducer
  Producer? _selectedProducer;
  String? _selectedHygiene; // VARIÁVEL FALTANDO ADICIONADA

  bool _producerPresent = false;
  bool _sampleCollected = false;

  @override
  void dispose() {
    _searchController.dispose();
    _volumeController.dispose();
    _temperatureController.dispose();
    _phController.dispose();
    _observationController.dispose();
    _tubeNumberController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // CORREÇÃO CRÍTICA: Lógica de salvar ajustada ao novo modelo e fluxo
      final newCollection = MilkCollection(
        id: DateTime.now().millisecondsSinceEpoch,
        // Dados vêm do produtor selecionado
        producerId: _selectedProducer!.id,
        // O nome agora está junto, vamos dividir para o modelo
        producerFirstName: _selectedProducer!.name.split(' ').first,
        producerLastName: _selectedProducer!.name
            .split(' ')
            .sublist(1)
            .join(' '),
        producerPropertyId: 404, // Simulado
        propertyName: _selectedProducer!.propertyName,
        // Dados vêm dos controladores do formulário
        temperature: _temperatureController.text,
        volumeLt: double.tryParse(_volumeController.text) ?? 0.0,
        producerPresent: _producerPresent,
        ph: double.tryParse(_phController.text) ?? 0.0,
        hygiene: _selectedHygiene ?? 'Neutro', // Usando o valor do Dropdown
        sample: _sampleCollected,
        tubeNumber: _sampleCollected ? _tubeNumberController.text : '',
        observation: _observationController.text,
        status: "PENDING_ANALYSIS",
        collectorId: 55,
        analysisId: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<MilkCollectionViewModel>().addCollection(newCollection);
      Navigator.pop(context);
    }
  }

  void _cancel() {
    setState(() {
      // CORREÇÃO DE ERRO DE DIGITAÇÃO: _selectedProducer
      _selectedProducer = null;
      _volumeController.clear();
      _temperatureController.clear();
      _phController.clear();
      _observationController.clear();
      _tubeNumberController.clear();
      _selectedHygiene = null;
      _searchController.clear();
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        // CORREÇÃO DE ERRO DE DIGITAÇÃO: _selectedProducer
        _selectedProducer = Producer(
          id: 101,
          name: 'SeucuMiadora',
          propertyName: 'Fazenda Santa Rosa',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Coleta de Leite')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar Produtor',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _performSearch(_searchController.text),
                  ),
                ),
                onSubmitted: _performSearch,
              ),
              const SizedBox(height: 24),

              // CORREÇÃO DE ERRO DE DIGITAÇÃO: _selectedProducer
              if (_selectedProducer != null)
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Produtor: ${_selectedProducer!.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Propriedade: ${_selectedProducer!.propertyName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Checkbox(
                            value: _producerPresent,
                            onChanged: (val) =>
                                setState(() => _producerPresent = val!),
                          ),
                          const Text('Presente?'),
                        ],
                      ),
                      const Divider(height: 32, thickness: 1),
                      const Center(
                        child: Text(
                          'Dados do Leite',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _volumeController,
                              decoration: const InputDecoration(
                                labelText: 'Volume (L)',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Obrigatório'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _temperatureController,
                              decoration: const InputDecoration(
                                labelText: 'Temperatura (°C)',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Obrigatório'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _phController,
                              decoration: const InputDecoration(
                                labelText: 'PH (acidez)',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Obrigatório'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedHygiene,
                              decoration: const InputDecoration(
                                labelText: 'Higiene',
                              ),
                              items: ['Ruim', 'Neutro', 'Bom']
                                  .map(
                                    (label) => DropdownMenuItem(
                                      child: Text(label),
                                      value: label,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedHygiene = value),
                              validator: (v) =>
                                  (v == null) ? 'Obrigatório' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _sampleCollected,
                            onChanged: (val) =>
                                setState(() => _sampleCollected = val!),
                          ),
                          const Text('Coletou Amostra?'),
                        ],
                      ),
                      TextFormField(
                        enabled: _sampleCollected,
                        controller: _tubeNumberController,
                        decoration: InputDecoration(
                          labelText: 'Número do Tubo',
                          filled: !_sampleCollected,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _observationController,
                        decoration: const InputDecoration(
                          labelText: 'Observações',
                        ),
                        maxLines: 3,
                      ), // NOME CORRIGIDO
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _cancel,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveForm,
                              child: const Text('Salvar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
