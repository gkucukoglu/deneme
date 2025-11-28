import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Uygulamanın ana bölümü
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Eğitimi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// --- VERI MODELLERI ---
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imageUrl; // Resim yolu (opsiyonel)

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.imageUrl, // Constructor'a eklendi
  });
}

// --- VERI ---
const Map<String, Map<String, QuizQuestion>> topicsData = {
  'OSI Modeli': {
    'Fiziksel Katman': QuizQuestion(
      question: 'Fiziksel katmanın temel görevi nedir?',
      options: ['Veriyi paketlere bölmek', 'Bitleri bir ortam üzerinden iletmek', 'Ağ yolunu bulmak', 'Veriyi şifrelemek'],
      correctAnswerIndex: 1,
      imageUrl: 'assets/images/fiziksel.png', // Örnek resim yolu
    ),
    'Veri Bağlantı Katmanı': QuizQuestion(
      question: 'MAC adresi hangi katmanda bulunur ve ne işe yarar?',
      options: ['Ağ Katmanı, yönlendirme için', 'Taşıma Katmanı, port numarası için', 'Veri Bağlantı Katmanı, yerel ağda cihaz kimliği için', 'Uygulama Katmanı, kullanıcı kimliği için'],
      correctAnswerIndex: 2,
    ),
    'Ağ Katmanı': QuizQuestion(
      question: 'IP adresi yönlendirmesi (routing) hangi katmanın sorumluluğundadır?',
      options: ['Fiziksel Katman', 'Veri Bağlantı Katmanı', 'Ağ Katmanı', 'Taşıma Katmanı'],
      correctAnswerIndex: 2,
    ),
     'Taşıma Katmanı': QuizQuestion(
      question: 'TCP ve UDP arasındaki temel fark nedir?',
      options: ['TCP daha hızlıdır, UDP daha güvenilirdir.', 'TCP bağlantı yönelimli ve güvenilirdir, UDP bağlantısız ve hızlıdır.', 'Her ikisi de aynı işi yapar.', 'UDP sadece video akışı için kullanılır.'],
      correctAnswerIndex: 1,
    ),
  },
  'TCP/IP Protokolleri': {
     'IP (İnternet Protokolü)': QuizQuestion(
      question: 'IP protokolünün temel amacı nedir?',
      options: ['Port numaralarını yönetmek', 'Veri bütünlüğünü sağlamak', 'Paketleri kaynak_cihazdan hedef_cihaza yönlendirmek', 'E-posta göndermek'],
      correctAnswerIndex: 2,
    ),
    'TCP (Taşıma Kontrol Protokolü)': QuizQuestion(
      question: 'TCPnin "güvenilir" bir protokol olarak adlandırılmasının sebebi nedir?',
      options: ['Çok hızlı olması', 'Veri kaybını kontrol edip düzeltebilmesi (el sıkışma ve onay mekanizmaları)', 'Şifreleme kullanması', 'Herkes tarafından kullanılması'],
      correctAnswerIndex: 1,
    ),
  },
  'Subnetting (Alt Ağlara Bölme)': {},
  'DNS Nedir?': {},
  'Firewall (Güvenlik Duvarı)': {},
  'Routing Protokolleri': {},
  'VPN (Sanal Özel Ağ)': {},
  'Ağ Topolojileri': {},
};
// --- VERI SONU ---


// Ana Sayfa
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = topicsData.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Network Konuları')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildGridView(context, topics);
          } else {
            return _buildListView(context, topics);
          }
        },
      ),
    );
  }

  ListView _buildListView(BuildContext context, List<String> topics) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (BuildContext context, int index) {
        final topic = topics[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text(topic),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _navigateToDetailPage(context, topic),
          ),
        );
      },
    );
  }

  GridView _buildGridView(BuildContext context, List<String> topics) {
     return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0, childAspectRatio: 3 / 1.2),
      itemCount: topics.length,
      itemBuilder: (BuildContext context, int index) {
        final topic = topics[index];
        return Card(
          child: InkWell(
            onTap: () => _navigateToDetailPage(context, topic),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(topic, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetailPage(BuildContext context, String topicTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(topicTitle: topicTitle)),
    );
  }
}


// Detay Sayfası
class DetailPage extends StatelessWidget {
  final String topicTitle;
  const DetailPage({super.key, required this.topicTitle});

  @override
  Widget build(BuildContext context) {
    final subtopicsMap = topicsData[topicTitle] ?? {};
    final subtopics = subtopicsMap.keys.toList();

    return Scaffold(
      appBar: AppBar(title: Text(topicTitle)),
      body: subtopics.isEmpty
          ? const Center(child: Text('Bu konu için quiz bulunmuyor.'))
          : ListView.builder(
              itemCount: subtopics.length,
              itemBuilder: (context, index) {
                final subtopic = subtopics[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(subtopic),
                    trailing: const Icon(Icons.quiz_outlined),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPage(
                            topicTitle: topicTitle,
                            startIndex: index,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// Quiz Sayfası
class QuizPage extends StatefulWidget {
  final String topicTitle;
  final int startIndex;

  const QuizPage({super.key, required this.topicTitle, required this.startIndex});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late int _currentQuestionIndex;
  late final List<QuizQuestion> _questions;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _currentQuestionIndex = widget.startIndex;
    final subtopicsMap = topicsData[widget.topicTitle] ?? {};
    _questions = subtopicsMap.values.toList();
  }

  void _handleAnswer(int selectedIndex) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
    });

    final isCorrect = selectedIndex == _questions[_currentQuestionIndex].correctAnswerIndex;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Doğru!' : 'Yanlış!'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _isAnswered = false;
        });
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text("Soru bulunamadı.")));
    }
    
    final currentQuestion = _questions[_currentQuestionIndex];
    final subtopicTitle = topicsData[widget.topicTitle]!.keys.elementAt(_currentQuestionIndex);

    return Scaffold(
      appBar: AppBar(title: Text(subtopicTitle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (currentQuestion.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        currentQuestion.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.image_not_supported, size: 50));
                        },
                      ),
                    ),
                  ),
                ),
              Text(
                'Soru ${ _currentQuestionIndex + 1}/${_questions.length}: ${currentQuestion.question}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              ...List.generate(currentQuestion.options.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: _isAnswered ? null : () => _handleAnswer(index),
                    style: ElevatedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(vertical: 16.0),
                       textStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                    child: Text(currentQuestion.options[index]),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
