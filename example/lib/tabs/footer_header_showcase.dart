import 'package:example/examples/custom_header_footer.dart';
import 'package:flutter/material.dart';

/// This is not a usage example.
///
/// Look at lib/examples folder to see how to use this package.
class FooterHeaderShowcase extends StatelessWidget {
  const FooterHeaderShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCustomHeaderFooterExample(context),
        ],
      ),
    );
  }

  Widget _buildCustomHeaderFooterExample(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: const [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "This view shows specific footer and header for every two"
                      "content. Other contents use story header and footer.",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 100,
              child: CustomHeaderFooter(),
            ),
          ],
        ),
      ),
    );
  }
}
