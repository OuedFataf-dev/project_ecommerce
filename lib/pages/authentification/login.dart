import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  //const login({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );
    return emailRegExp.hasMatch(email);
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> inscrireUtilisateur() async {
    if (!_formKey.currentState!.validate()) {
      return; // Ne pas continuer si le formulaire n'est pas valide
    }

    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    // Afficher un Snackbar pour indiquer que l'inscription est en cours
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Envoi en cours...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Crée un nouvel utilisateur avec l'email et le mot de passe
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupère l'ID de l'utilisateur créé
      String userId = userCredential.user!.uid;

      // Crée une référence à la collection "users"
      final collectionRef = FirebaseFirestore.instance.collection('users');

      // Crée un document avec les données de l'utilisateur
      await collectionRef.doc(userId).set({
        'name': name,
        'email': email,
        'createDATE': DateTime.now(),
        'userId': userId,
      });

      // Afficher un Snackbar pour indiquer le succès de l'inscription
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inscription réussie !'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Attendre 2 secondes avant de rediriger
      await Future.delayed(Duration(seconds: 2));

      // Rediriger vers la page de connexion après une inscription réussie
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUp()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Gérer les erreurs d'authentification
      print('Erreur d\'inscription : ${e.message}');

      if (mounted) {
        // Afficher un Snackbar pour indiquer une erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${e.message}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Gérer d'autres erreurs
      print('Erreur : $e');

      if (mounted) {
        // Afficher un Snackbar pour indiquer une erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Hero(
                      tag: 'hero',
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 100.0,
                        child: Image.asset('assets/images/about.png'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            hintText: 'name',
                            label: Text('votre name'),
                            errorStyle:
                                TextStyle(fontSize: 14, color: Colors.red)),
                        validator: (value) {
                          if (value == 0 || value!.isEmpty) {
                            return 'veuillez remplis les champ';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          hintText: 'email',
                          label: Text('votre email'),
                          errorStyle:
                              TextStyle(fontSize: 14, color: Colors.red),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplir le champ';
                          }
                          if (!isValidEmail(value)) {
                            return 'Adresse e-mail invalide';
                          }
                          return null; // Pas d'erreur
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        obscureText: !_isPasswordVisible,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            prefixIcon: Icon(Icons.password),
                            hintText: 'password',
                            label: Text('votre Mot de passe'),
                            errorStyle:
                                TextStyle(fontSize: 14, color: Colors.red)),
                        validator: (value) {
                          if (value == 0 || value!.isEmpty) {
                            return 'veuillez remplis les champ';
                          }
                        },
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 200,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child: Text("s'inscrire"),
                          onPressed: inscrireUtilisateur,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SignUp()), // Correction ici
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Vous avez un compte ? ',
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Se connecter',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
