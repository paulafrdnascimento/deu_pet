import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PetRegistration extends StatefulWidget {
  @override
  _PetRegistrationState createState() => _PetRegistrationState();
}

class _PetRegistrationState extends State<PetRegistration> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _specialNeedsController = TextEditingController();
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _speciesController =
      TextEditingController(); // Adicionado

  String? _selectedSex;
  String? _selectedSize;
  String? _selectedTemperament;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _clearFields() {
    _nameController.clear();
    _ageController.clear();
    _healthController.clear();
    _locationController.clear();
    _specialNeedsController.clear();
    _historyController.clear();
    _speciesController.clear();
    setState(() {
      _image = null;
      _selectedSex = null;
      _selectedSize = null;
      _selectedTemperament = null;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Stack(
            children: [
              Container(
                width: 221,
                height: 86,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Animal cadastrado com sucesso!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF787879),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                top: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String? _validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório!';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório!';
    }
    if (int.tryParse(value) == null) {
      return 'A idade deve ser um número.';
    }
    return null;
  }

  void _registerPet() {
    if (_formKey.currentState!.validate()) {
      _showSuccessDialog();
      _clearFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor, preencha todos os campos corretamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _image == null
                        ? Icon(Icons.add_a_photo,
                            size: 50, color: Colors.grey[600])
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              TextFormField(
                // Campo de Espécie/Raça
                controller: _speciesController,
                decoration: InputDecoration(
                  labelText: 'Espécie/Raça',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Idade',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateAge,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSex,
                      decoration: InputDecoration(
                        labelText: 'Sexo',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Macho', 'Fêmea']
                          .map((sex) => DropdownMenuItem(
                                value: sex,
                                child: Text(sex),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSex = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSize,
                      decoration: InputDecoration(
                        labelText: 'Porte',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Pequeno', 'Médio', 'Grande']
                          .map((size) => DropdownMenuItem(
                                value: size,
                                child: Text(size),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSize = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedTemperament,
                      decoration: InputDecoration(
                        labelText: 'Temperamento',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Calmo', 'Agitado', 'Brincalhão', 'Tímido']
                          .map((temperament) => DropdownMenuItem(
                                value: temperament,
                                child: Text(temperament),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTemperament = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Campo obrigatório' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _healthController,
                decoration: InputDecoration(
                  labelText: 'Estado de Saúde',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Localização',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _specialNeedsController,
                decoration: InputDecoration(
                  labelText: 'Possui necessidades especiais?',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _historyController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'História',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequiredField,
              ),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _registerPet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF50BB88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Cadastrar Pet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
