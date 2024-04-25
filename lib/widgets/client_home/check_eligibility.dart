import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/widgets/client_home/client_home.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart'; // Importez le service Firebase

final Color aa = Colors.blue[800]!;

class CheckEligibility extends StatefulWidget {
  const CheckEligibility({Key? key});

  @override
  State<CheckEligibility> createState() => _CheckEligibilityState();
}

class _CheckEligibilityState extends State<CheckEligibility> {
  final TextEditingController _itemPriceController = TextEditingController();
  double _itemPrice = 0.0; // Variable pour stocker le prix de l'article

  @override
  Widget build(BuildContext context) {
    final Color customBlue800 = Colors.blue[800]!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ClientHome(),
              ),
            );
          },
        ),
        title: const Text(
          'Check Eligibility',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[800]!, Colors.blue[300]!],
                stops: const [0.2, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Enter Item Price',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _itemPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter price',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _itemPrice = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: ElevatedButton(
                      onPressed:
                          _checkEligibilityButtonPressed, // Appeler la fonction lors du clic sur le bouton
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue[800],
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: Text(
                        'Check Eligibility',
                        style: TextStyle(
                          color: customBlue800,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  const Text(
                    'Your eligibility will be based on the entered item price and your infos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour gérer le clic sur le bouton
  void _checkEligibilityButtonPressed() async {
    try {
      // Récupérer l'ID de l'utilisateur connecté
      String userId = FirebaseAuthService().getCurrentUserId();

      // Récupérer les données de l'utilisateur depuis Firestore
      Map<String, dynamic>? userData = await FirebaseAuthService().fetchUserProfile(userId);

      if (userData != null) {
        // Récupérer le salaire de l'utilisateur depuis les données récupérées
        double salary = userData['salary'];

        // Appeler la fonction pour vérifier l'éligibilité
        String eligibilityStatus = await FirebaseAuthService().checkEligibility(salary, _itemPrice);

        // Afficher ou traiter le statut d'éligibilité
        if (kDebugMode) {
          print("Eligibility Status: $eligibilityStatus");
        }
      } else {
        if (kDebugMode) {
          print("Error: User data not found.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking eligibility: $e");
      }
    }
  }
}
