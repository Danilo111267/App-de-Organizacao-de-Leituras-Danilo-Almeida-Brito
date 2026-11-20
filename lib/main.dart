// Integrante: Danilo Almeida Brito

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final preferencias = SharedPreferencesAsync();
  List<Map<String, String>> livros = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    try {
      final texto = await preferencias.getString('livros');
      final lista = texto == null ? [] : jsonDecode(texto) as List;

      if (!mounted) return;

      setState(() {
        livros = lista
            .map((item) => Map<String, String>.from(item as Map))
            .toList();
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        carregando = false;
      });
      aviso('Erro ao carregar livros.');
    }
  }

  Future<void> salvar() async {
    await preferencias.setString('livros', jsonEncode(livros));
  }

  void aviso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> adicionar() async {
    final novo = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const TelaCadastro()),
    );

    if (!mounted || novo == null) return;

    setState(() {
      livros.add(novo);
    });

    try {
      await salvar();
      if (mounted) aviso('Livro adicionado!');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        livros.remove(novo);
      });
      aviso('Erro ao salvar livro.');
    }
  }

  Future<void> remover(int index) async {
    final livro = livros[index];

    setState(() {
      livros.removeAt(index);
    });

    try {
      await salvar();
      if (mounted) aviso('Livro removido!');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        livros.insert(index, livro);
      });
      aviso('Erro ao remover livro.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danilo Almeida Brito')),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : livros.isEmpty
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
        onPressed: carregando ? null : adicionar,
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
