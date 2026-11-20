// Integrante: Danilo Almeida Brito

import 'package:flutter/material.dart';

void main() {
  runApp(const AppLeituras());
}

class AppLeituras extends StatelessWidget {
  const AppLeituras({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaLivros(),
    );
  }
}

class TelaLivros extends StatefulWidget {
  const TelaLivros({super.key});

  @override
  State<TelaLivros> createState() => _TelaLivrosState();
}

class _TelaLivrosState extends State<TelaLivros> {
  final List<Map<String, String>> livros = [];

  Future<void> adicionar() async {
    final novo = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const TelaCadastro()),
    );

    if (!mounted || novo == null) return;

    setState(() {
      livros.add(novo);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livro adicionado!')),
    );
  }

  void remover(int index) {
    setState(() {
      livros.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livro removido!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danilo Almeida Brito')),
      body: livros.isEmpty
          ? const Center(child: Text('Nenhum livro cadastrado.'))
          : ListView.builder(
              itemCount: livros.length,
              itemBuilder: (context, index) {
                final livro = livros[index];

                return ListTile(
                  title: Text(livro['titulo']!),
                  subtitle: Text(livro['autor']! + ' - ' + livro['status']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => remover(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: adicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final titulo = TextEditingController();
  final autor = TextEditingController();
  String status = 'Quero ler';

  void cadastrar() {
    if (titulo.text.trim().isEmpty || autor.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha título e autor.')),
      );
      return;
    }

    Navigator.pop(context, <String, String>{
      'titulo': titulo.text.trim(),
      'autor': autor.text.trim(),
      'status': status,
    });
  }

  @override
  void dispose() {
    titulo.dispose();
    autor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar livro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titulo,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: autor,
              decoration: const InputDecoration(labelText: 'Autor'),
            ),
            DropdownButton<String>(
              value: status,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Quero ler', child: Text('Quero ler')),
                DropdownMenuItem(value: 'Lendo', child: Text('Lendo')),
                DropdownMenuItem(value: 'Concluído', child: Text('Concluído')),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  setState(() {
                    status = valor;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: cadastrar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
