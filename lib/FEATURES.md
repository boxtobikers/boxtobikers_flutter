# boxtobikers

## Structuration par fonctionnalité (Feature-based first)

https://medium.com/@tallambaye108/comment-structurer-ses-dossiers-dans-flutter-67a1ea08fbef#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImM4OGQ4MDlmNGRiOTQzZGY1M2RhN2FjY2ZkNDc3NjRkMDViYTM5MWYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgyODk4MjI0MTU5MjgwMTM5ODMiLCJlbWFpbCI6ImJveHRvYmlrZXJzQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYmYiOjE3Mjk4NjgxNTUsIm5hbWUiOiJCb3hUb0Jpa2VycyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NLTWJVMk1ySmgxMHc5d1dCLUMtNDlFdWdSSFhpa1E4ZUdfejRGRXNqM21iZ2RFcFNnPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkJveFRvQmlrZXJzIiwiaWF0IjoxNzI5ODY4NDU1LCJleHAiOjE3Mjk4NzIwNTUsImp0aSI6ImMwZDU4OWE2ZjUxOWIyYWI5YTdmZTIzMzZmZDM0ZDNiMjVkNDgwYjEifQ.0jgks4xoF1m425d9DfWCRe6zTfxBGjEqy3MTL3MkZsC12n78EI3Mb7tq7uvPjuPfPwJr7DkalVuvek0MAi-eO-Kb054XONh6klWTuF9PV2SEL2UlWpsdC4qEsgspZBsFKe-KbJvRQLw0rPNuHk-r8DuXkq_vhLAhzw3dSWOH_wOafn05nAyIEq096QvYF5TRgdwq8g7Noezww4aXc1LM3Zt5cv1Jmoc7zN1RnKmeR1S7M8keXkgBLqTz3Yy_FGaiLrDdCE2ke0ofcDGvicjLk6I1N3P_jc8RALPjkTXDvQVyEQoaJZ4hDdAMJOqJjgYg6DZMRRSNVlRxfoDuW8HP2w

- Regrouper les fichiers par fonctionnalité.
- Chaque fonctionnalité a son propre dossier contenant les fichiers liés à cette fonctionnalité.


``
lib/
  features/
    home/
      domain/ 
        models/         contient les classes métier spécifiques aux APIs, Bdd, etc...
        repositories/   contient la logique spécifique aux APIs, Bdd, etc...
      ui/
        pages/          contient les écrans
        widgets/        contient les composants réutilisables
      business/
        models/         contient les classes métier spécifiques à la fonctionnalité
        services/       contient la logique métier
        utils/          contient les fonctions utilitaires spécifiques à la fonctionnalité
    signup/
      domain/
        models/
        repositories/
      ui/
        pages/
        widgets/
      business/
        models/
        services/
        utils/
  core/
    utils/
    constants/
    themes/
  main.dart
``


