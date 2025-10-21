import 'package:boxtobikers/generated/l10n.dart';
import 'package:flutter/material.dart';

class HistoryPages extends StatefulWidget {
  const HistoryPages({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryPagesState();
}

class _HistoryPagesState extends State<HistoryPages> {
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final double headerImageHeight = MediaQuery.of(context).size.height / 4;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SafeArea(
        child: Column(
          children: [
            // Section supérieure avec icône Flutter et titre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: headerImageHeight,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/btb_header_paris.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    left: 8.0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Zone de contenu scrollable
            Expanded(
              child: Center(
                child: Text(l10n.settingsGeneralTitle,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}