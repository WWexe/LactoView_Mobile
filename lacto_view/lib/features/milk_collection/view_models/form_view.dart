import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/model.dart';
import '../services/services.dart'; // Importe o service para ter a classe Producer
import '../view_models/view_models.dart';

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
  final _observationController = TextEditingController();
  final _tubeNumberController = TextEditingController();
  Producer? _selectedProducer;
  String? _selectedHygiene;
  bool _producerPresent = true;
  bool _sampleCollected = false;

  void _onProducerSelected(Producer producer) {
    setState(() {
      _selectedProducer = producer;
      _searchController.clear();
      context.read<MilkCollectionViewModel>().searchProducers('');
    });
  }

  void _cancel() {
    setState(() {
      _selectedProducer = null;
      _searchController.clear();
      _volumeController.clear();
      _temperatureController.clear();
      _phController.clear();
      _observationController.clear();
      _tubeNumberController.clear();
      _selectedHygiene = null;
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Lógica de salvar que já corrigimos antes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MilkCollectionViewModel>(
      builder: (context, viewModel, child) {
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
                    onChanged: (query) => viewModel.searchProducers(query),
                    decoration: InputDecoration(
                      labelText: 'Buscar Produtor',
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                viewModel.searchProducers('');
                              },
                            )
                          : const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (viewModel.isSearching)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (!viewModel.isSearching &&
                      viewModel.searchResults.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemCount: viewModel.searchResults.length,
                        itemBuilder: (context, index) {
                          final producer = viewModel.searchResults[index];
                          return ListTile(
                            title: Text(producer.name),
                            subtitle: Text(producer.propertyName),
                            onTap: () => _onProducerSelected(producer),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (_selectedProducer != null)
                    Form(
                      key: _formKey,
                      child: Column(
                        // ==========================================================
                        // INÍCIO DO FORMULÁRIO INTERNO QUE ESTAVA FALTANDO
                        // ==========================================================
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
                          const Center(
                            child: Text(
                              'Dados do Leite',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          const Divider(height: 32, thickness: 1),
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
                          ),
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
                        // ==========================================================
                        // FIM DO FORMULÁRIO INTERNO
                        // ==========================================================
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
