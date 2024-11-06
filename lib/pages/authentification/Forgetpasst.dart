import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réinitialiser le mot de passe'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      fillColor: Colors.red[50],
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Votre email',
                      label: Text('Email'),
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez remplir le champ";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final eventEmail = emailController.text.trim();
                      if (eventEmail.isNotEmpty) {
                        try {
                          // Utilisez `await` pour capturer les erreurs correctement
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: eventEmail);

                          // Si l'email est envoyé avec succès

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Email de réinitialisation envoyé avec succès !'),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          // Capture de l'exception spécifique
                          print('Erreur Firebase: ${e.code}'); // Debug
                          String errorMessage =
                              'Une erreur s\'est produite. Veuillez réessayer.';

                          if (e.code == 'user-not-found') {
                            errorMessage =
                                'Aucun utilisateur trouvé pour cet email. Veuillez vous inscrire d\'abord.';
                          } else if (e.code == 'invalid-email') {
                            errorMessage =
                                'L\'adresse email est invalide. Veuillez entrer une adresse correcte.';
                          } else if (e.code == 'too-many-requests') {
                            errorMessage =
                                'Trop de demandes récentes. Veuillez réessayer plus tard.';
                          }

                          // Afficher le message d'erreur pertinent
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                            ),
                          );
                        } catch (e) {
                          // Gestion d'autres erreurs inattendues
                          print('Erreur inattendue: $e'); // Debug
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Une erreur inattendue s\'est produite.'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text('Réinitialiser le mot de passe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
