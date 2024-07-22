import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventRegistrationForm(),
    );
  }
}

class EventRegistrationForm extends StatefulWidget {
  @override
  _EventRegistrationFormState createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _employeeNumberController = TextEditingController();
  final _nameController = TextEditingController();
  String? _selectedDate;
  bool? _isAdult;
  String? _selectedOption;
  List<Map<String, dynamic>> _companions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _employeeNumberController,
                  decoration: InputDecoration(labelText: '社員番号 (6桁)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '社員番号を入力してください';
                    }
                    if (value.length != 6) {
                      return '社員番号は6桁でなければなりません';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: '氏名'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '氏名を入力してください';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: '参加日'),
                  items: ['8月21日', '8月22日'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDate = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '参加日を選択してください';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<bool>(
                  decoration: InputDecoration(labelText: '年齢'),
                  items: [true, false].map((bool value) {
                    return DropdownMenuItem<bool>(
                      value: value,
                      child: Text(value ? '20歳以上' : '20歳未満'),
                    );
                  }).toList(),
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isAdult = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '年齢を選択してください';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: '参加オプション'),
                  items: ['会社見学のみ', '会社見学と食事', '食事のみ'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '参加オプションを選択してください';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  '同伴者情報',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ..._companions.map((companion) {
                  return Column(
                    children: [
                      TextFormField(
                        initialValue: companion['name'],
                        decoration: InputDecoration(labelText: '同伴者氏名'),
                        onChanged: (value) {
                          companion['name'] = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '同伴者氏名を入力してください';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<bool>(
                        decoration: InputDecoration(labelText: '同伴者年齢'),
                        value: companion['isAdult'],
                        items: [true, false].map((bool value) {
                          return DropdownMenuItem<bool>(
                            value: value,
                            child: Text(value ? '20歳以上' : '20歳未満'),
                          );
                        }).toList(),
                        onChanged: (bool? newValue) {
                          setState(() {
                            companion['isAdult'] = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return '同伴者年齢を選択してください';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: '同伴者オプション'),
                        value: companion['option'],
                        items: ['会社見学のみ', '会社見学と食事', '食事のみ'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            companion['option'] = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '同伴者オプションを選択してください';
                          }
                          return null;
                        },
                      ),
                    ],
                  );
                }).toList(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _companions.add({
                            'name': '',
                            'isAdult': null,
                            'option': null,
                          });
                        });
                      },
                      child: Text('同伴者を追加'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // フォームが有効な場合の処理
                          _showConfirmationDialog(context);
                        }
                      },
                      child: Text('確認'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('確認画面'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('社員番号: ${_employeeNumberController.text}'),
                Text('氏名: ${_nameController.text}'),
                Text('参加日: $_selectedDate'),
                Text('年齢: ${_isAdult == true ? '20歳以上' : '20歳未満'}'),
                Text('参加オプション: $_selectedOption'),
                ..._companions.map((companion) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('同伴者氏名: ${companion['name']}'),
                      Text('同伴者年齢: ${companion['isAdult'] == true ? '20歳以上' : '20歳未満'}'),
                      Text('同伴者オプション: ${companion['option']}'),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('訂正'),
            ),
            TextButton(
              onPressed: () {
                // ここでサーバにデータを送信する処理を追加します
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('申込みが完了しました')),
                );
                Navigator.of(context).pop();
              },
              child: Text('確認'),
            ),
          ],
        );
      },
    );
  }
}