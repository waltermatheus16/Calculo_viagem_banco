import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cálculo de Custo de Viagem',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Carro> _carros = [];
  final List<Destino> _destinos = [];
  final List<Combustivel> _combustiveis = [];

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(CarroCadastroScreen(carros: _carros));
    _screens.add(DestinoCadastroScreen(destinos: _destinos));
    _screens.add(CombustivelCadastroScreen(combustiveis: _combustiveis));
    _screens.add(CalculoScreen(carros: _carros, destinos: _destinos, combustiveis: _combustiveis));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.car_repair, color: Colors.black),
            label: 'Carros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Colors.black),
            label: 'Destinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station, color: Colors.black),
            label: 'Combustíveis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate, color: Colors.black),
            label: 'Cálculo',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class Carro {
  String nome;
  double autonomia;

  Carro(this.nome, this.autonomia);
}

class Destino {
  String nome;
  double distancia;

  Destino(this.nome, this.distancia);
}

class Combustivel {
  String tipo;
  double preco;
  String data;

  Combustivel(this.tipo, this.preco, this.data);
}

class CarroCadastroScreen extends StatefulWidget {
  final List<Carro> carros;

  CarroCadastroScreen({required this.carros});

  @override
  _CarroCadastroScreenState createState() => _CarroCadastroScreenState();
}

class _CarroCadastroScreenState extends State<CarroCadastroScreen> {
  final _nomeController = TextEditingController();
  final _autonomiaController = TextEditingController();

  void _adicionarCarro() {
    String nome = _nomeController.text;
    double? autonomia = double.tryParse(_autonomiaController.text);

    if (nome.isNotEmpty && autonomia != null) {
      setState(() {
        widget.carros.add(Carro(nome, autonomia));
        _nomeController.clear();
        _autonomiaController.clear();
      });
    }
  }

  void _removerCarro(int index) {
    setState(() {
      widget.carros.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Carro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nomeController, decoration: InputDecoration(labelText: 'Nome do Carro')),
            TextField(controller: _autonomiaController, decoration: InputDecoration(labelText: 'Autonomia (km/lt)')),
            ElevatedButton(onPressed: _adicionarCarro, child: Text('Adicionar Carro')),
            Expanded(child: ListView.builder(
              itemCount: widget.carros.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.carros[index].nome),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.black),
                    onPressed: () => _removerCarro(index),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

class DestinoCadastroScreen extends StatefulWidget {
  final List<Destino> destinos;

  DestinoCadastroScreen({required this.destinos});

  @override
  _DestinoCadastroScreenState createState() => _DestinoCadastroScreenState();
}

class _DestinoCadastroScreenState extends State<DestinoCadastroScreen> {
  final _nomeController = TextEditingController();
  final _distanciaController = TextEditingController();

  void _adicionarDestino() {
    String nome = _nomeController.text;
    double? distancia = double.tryParse(_distanciaController.text);

    if (nome.isNotEmpty && distancia != null) {
      setState(() {
        widget.destinos.add(Destino(nome, distancia));
        _nomeController.clear();
        _distanciaController.clear();
      });
    }
  }

  void _removerDestino(int index) {
    setState(() {
      widget.destinos.removeAt(index);
    });
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
            Expanded(child: ListView.builder(
              itemCount: widget.destinos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.destinos[index].nome),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.black),
                    onPressed: () => _removerDestino(index),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

class CombustivelCadastroScreen extends StatefulWidget {
  final List<Combustivel> combustiveis;

  CombustivelCadastroScreen({required this.combustiveis});

  @override
  _CombustivelCadastroScreenState createState() => _CombustivelCadastroScreenState();
}

class _CombustivelCadastroScreenState extends State<CombustivelCadastroScreen> {
  final _tipoController = TextEditingController();
  final _precoController = TextEditingController();
  final _dataController = TextEditingController();

  void _adicionarCombustivel() {
    String tipo = _tipoController.text;
    double? preco = double.tryParse(_precoController.text);
    String data = _dataController.text;

    if (tipo.isNotEmpty && preco != null && data.isNotEmpty) {
      setState(() {
        widget.combustiveis.add(Combustivel(tipo, preco, data));
        _tipoController.clear();
        _precoController.clear();
        _dataController.clear();
      });
    }
  }

  void _removerCombustivel(int index) {
    setState(() {
      widget.combustiveis.removeAt(index);
    });
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
            SizedBox(height: 20),
            Expanded(child: ListView.builder(
              itemCount: widget.combustiveis.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text('${widget.combustiveis[index].tipo}: R\$${widget.combustiveis[index].preco} em ${widget.combustiveis[index].data}')),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.black),
                        onPressed: () => _removerCombustivel(index),
                      ),
                    ],
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

class CalculoScreen extends StatefulWidget {
  final List<Carro> carros;
  final List<Destino> destinos;
  final List<Combustivel> combustiveis;

  CalculoScreen({required this.carros, required this.destinos, required this.combustiveis});

  @override
  _CalculoScreenState createState() => _CalculoScreenState();
}

class _CalculoScreenState extends State<CalculoScreen> {
  Carro? _carroSelecionado;
  Destino? _destinoSelecionado;
  Combustivel? _combustivelSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calcular Custo da Viagem')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Carro>(
              hint: Text('Selecione um Carro'),
              value: _carroSelecionado,
              onChanged: (Carro? novoCarro) {
                setState(() {
                  _carroSelecionado = novoCarro;
                });
              },
              items: widget.carros.map((Carro carro) {
                return DropdownMenuItem<Carro>(
                  value: carro,
                  child: Text(carro.nome),
                );
              }).toList(),
            ),
            DropdownButton<Destino>(
              hint: Text('Selecione um Destino'),
              value: _destinoSelecionado,
              onChanged: (Destino? novoDestino) {
                setState(() {
                  _destinoSelecionado = novoDestino;
                });
              },
              items: widget.destinos.map((Destino destino) {
                return DropdownMenuItem<Destino>(
                  value: destino,
                  child: Text(destino.nome),
                );
              }).toList(),
            ),
            DropdownButton<Combustivel>(
              hint: Text('Selecione um Combustível'),
              value: _combustivelSelecionado,
              onChanged: (Combustivel? novoCombustivel) {
                setState(() {
                  _combustivelSelecionado = novoCombustivel;
                });
              },
              items: widget.combustiveis.map((Combustivel combustivel) {
                return DropdownMenuItem<Combustivel>(
                  value: combustivel,
                  child: Text('${combustivel.tipo}: R\$${combustivel.preco}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_carroSelecionado != null && _destinoSelecionado != null && _combustivelSelecionado != null) {
                  double custo = (_destinoSelecionado!.distancia / _carroSelecionado!.autonomia) * _combustivelSelecionado!.preco;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Custo da Viagem'),
                        content: Text('O custo da viagem é: R\$${custo.toStringAsFixed(2)}'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Fechar')),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, selecione todos os campos.')),
                  );
                }
              },
              child: Text('Calcular Custo'),
            ),
          ],
        ),
      ),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE combustiveis(id INTEGER PRIMARY KEY, tipo TEXT, preco REAL, data TEXT)');
     
      },
    );
  }

  Future<void> insertCombustivel(Combustivel combustivel) async {
    final db = await database;
    await db.insert('combustiveis', {
      'tipo': combustivel.tipo,
      'preco': combustivel.preco,
      'data': combustivel.data,
    });
  }
}
