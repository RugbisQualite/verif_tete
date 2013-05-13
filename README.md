verif_tete
==========

subdiv_tete_de_vedette.pl

DESCRIPTION
Programme d’interrogation du webservice idref de l'Abes (via le package subdivision.pm)
Teste les têtes de vedette rameau. Vérifie si les termes réservés aux subdivisions ne sont pas employés en tête de vedette.
 

 UTILISATION

Nécessite les packages :  LWP::Simple, subdivision.pm
Accepte en entrée :
- les fichiers textes formatés de la manière suivante : numero-de-notice;PPN-de-l'autorité
  exemple : 000163061;027791629
- les fichiers Aleph Sequentiel d'extraction des zones 60X
  exemple : 000000014 606   L $$aThéorie quantique$$3PPN02731569X$$3PPN03020934X$$xManuels d'enseignement supérieur$$2rameau

Le nom du fichier doit être indiqué dans
my $fichier_de_base = "nom_du_fichier" ;

Sortie sur écran de la forme :
027247783 dans 000017100 : OK
027220346 dans 000017100 : OK
Erreur sur 027789896 dans 000008479
02722418X dans 000017106 : OK

Erreurs compilées dans "liste_erreurs.log" sous la forme
Erreur sur 027789896 dans 000008479

Rapport dans "rapport.log" sous la forme :
Recherches subdivisions employées en têtes de vedette :
Total = 320729
Erreurs = 76278
Pas de problèmes 244451


 LICENCE

GNU/GPL


