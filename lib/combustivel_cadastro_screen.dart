import 'package:flutter/material.dart';
import 'database_helper.dart';

class Combustivel {
  String tipo;
  double preco;
  String data;

  Combustivel(this.tipo, this.preco, this.data);
}

class CombustivelCadastroScreen extends StatefulWidget {
  @override
  _CombustivelCadastroScreenState createState() => _CombustivelCadastroScreenState();
}

class _CombustivelCadastroScreenState extends State<CombustivelCadastroScreen> {
  final _tipoController = TextEditingController();
  final _precoController = TextEditingController();
  final _dataController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Combustivel> _combustiveis = [];

  void _adicionarCombustivel() async {
    String tipo = _tipoController.text;
    double? preco = double.tryParse(_precoController.text);
    String data = _dataController.text;

    if (tipo.isNotEmpty && preco != null && data.isNotEmpty) {
      await _dbHelper.insertCombustivel({'tipo': tipo, 'preco': preco, 'data': data});
      _tipoController.clear();
      _precoController.clear();
      _dataController.clear();
      _carregarCombustiveis();
    }
  }

  Future<void> _carregarCombustiveis() async {
    List<Map<String, dynamic>> combustiveis = await _dbHelper.getCombustiveis();
    setState(() {
      _combustiveis = combustiveis.map((c) => Combustivel(c['tipo'], c['preco'], c['data'])).toList();
    });
  }

  void _removerCombustivel(int index) async {
    await _dbHelper.deleteCombustivel(index); // Remover pelo índice
    _carregarCombustiveis();
  }

  @override
  void initState() {
    super.initState();
    _carregarCombustiveis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Combustível')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _tipoController, decoration: InputDecoration(labelText: 'Tipo de Combustível')),
            TextField(controller: _precoController, decoration: InputDecoration(labelText: 'Preço por Litro')),
            TextField(controller: _dataController, decoration: InputDecoration(labelText: 'Data (dd/MM/yyyy)')),
            ElevatedButton(onPressed: _adicionarCombustivel, child: Text('Adicionar Combustível')),
            Expanded(
              child: ListView.builder(
                itemCount: _combustiveis.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(child: Text('${_combustiveis[index].tipo}: R\$${_combustiveis[index].preco} em ${_combustiveis[index].data}')),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.black),
                          onPressed: () => _removerCombustivel(index),
                        ),
                      ],
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
