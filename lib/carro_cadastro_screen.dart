import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importar o DatabaseHelper

class Destino {
  String nome;
  double distancia;

  Destino(this.nome, this.distancia);
}

class DestinoCadastroScreen extends StatefulWidget {
  @override
  _DestinoCadastroScreenState createState() => _DestinoCadastroScreenState();
}

class _DestinoCadastroScreenState extends State<DestinoCadastroScreen> {
  final _nomeController = TextEditingController();
  final _distanciaController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Destino> _destinos = [];

  void _adicionarDestino() async {
    String nome = _nomeController.text;
    double? distancia = double.tryParse(_distanciaController.text);

    if (nome.isNotEmpty && distancia != null) {
      await _dbHelper.insertDestino({'nome': nome, 'distancia': distancia});
      _nomeController.clear();
      _distanciaController.clear();
      _carregarDestinos();
    }
  }

  Future<void> _carregarDestinos() async {
    List<Map<String, dynamic>> destinos = await _dbHelper.getDestinos();
    setState(() {
      _destinos = destinos.map((d) => Destino(d['nome'], d['distancia'])).toList();
    });
  }

  void _removerDestino(int index) async {
    // Remover diretamente do banco de dados usando o mesmo método de inserção, se você quiser, pode implementar um método para remover.
    await _dbHelper.deleteDestinoByName(_destinos[index].nome); // Método que você terá que adicionar
    _carregarDestinos();
  }

  @override
  void initState() {
    super.initState();
    _carregarDestinos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Destino')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nomeController, decoration: InputDecoration(labelText: 'Nome do Destino')),
            TextField(controller: _distanciaController, decoration: InputDecoration(labelText: 'Distância (km)')),
            ElevatedButton(onPressed: _adicionarDestino, child: Text('Adicionar Destino')),
            Expanded(
              child: ListView.builder(
                itemCount: _destinos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_destinos[index].nome),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.black),
                      onPressed: () => _removerDestino(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
