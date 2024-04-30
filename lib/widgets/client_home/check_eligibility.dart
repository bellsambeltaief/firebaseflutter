import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/widgets/client_home/cheques.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart'; // Importez le service Firebase

final Color aa = Colors.blue[800]!;

class CheckEligibility extends StatefulWidget {
  const CheckEligibility({
    super.key,
  });

  @override
  State<CheckEligibility> createState() => _CheckEligibilityState();
}

class _CheckEligibilityState extends State<CheckEligibility> {
  final TextEditingController _itemPriceController = TextEditingController();
  double _itemPrice = 0.0; // Variable pour stocker le prix de l'article

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue[900],
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Check Eligibility',
            style: TextStyle(
              color: Colors.blue[900],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Enter Item Price',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFileds(
                controller: _itemPriceController,
                label: "Enter Price",
                obscure: false,
                minlength: 1,
                input: const TextInputType.numberWithOptions(decimal: true),
                validate: (value) {
                  setState(() {
                    _itemPrice = double.tryParse(value!) ?? 0.0;
                  });
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Button(
                  label: "Check Eligbility",
                  onTap: _checkEligibilityButtonPressed,
                ),
              ),
              const Spacer(flex: 1),
              const Text(
                'Your eligibility will be based on the entered item price and your infos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour gérer le clic sur le bouton

  void _checkEligibilityButtonPressed() async {
    try {
      double enteredPrice = double.tryParse(_itemPriceController.text) ?? 0.0;

      if (enteredPrice < 1.0) {
        // Show an error message if the entered price is less than 1
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item price must be greater than or equal to 1."),
            duration: Duration(seconds: 3),
          ),
        );
        return; // Exit the function early if the price is invalid
      }
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

        // Vérifier si l'utilisateur est éligible
        if (eligibilityStatus == 'Eligible') {
          // Rediriger l'utilisateur vers le widget UploadCheques
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Cheques(userId: userId),
            ),
          );
        } else {
          // Afficher le statut d'éligibilité dans un SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(eligibilityStatus),
              duration: const Duration(seconds: 3), // Durée d'affichage du SnackBar
            ),
          );
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
