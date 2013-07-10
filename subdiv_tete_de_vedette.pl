#!/usr/bin/perl

use strict;
use warnings;
use subdivision;

# Attention à ne pas mettre de retour à la ligne Windows dans le fichier ISBN : uniquement UNIX

#  ~~~~~~~ VERSIONS~~~~~~~~
#  22.02.2013 : Création.
# Dernière modif : 22.02.2013
# 10.04.2013 : fonctionne. Sortie du rapport.
# 12.04.2013 : accpete en entrée les fichiers CSV et Aleph séquentiels
#  ~~~~~~~ VERSIONS~~~~~~~~

# romain.vanel@ujf-grenoble.fr
# rugbis@ujf-grenoble.fr

=head1 NAME
subdiv_tete_de_vedette.pl
=cut

=head1 DESCRIPTION
Programme d’interrogation du webservice idref de l'Abes (via le package subdivision.pm)
Teste les têtes de vedette rameau. Vérifie si les termes réservés aux subdivisions ne sont pas employés en tête de vedette.
 
=cut

=head1 UTILISATION

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


=cut

=head1 LICENCE

GNU/GPL

=cut

my $fichier_de_base = "xxxxxxxxx" ;


 my $cpt_total = 0;
 my $cpt_nok = 0 ;
 my $cpt_ok = 0;



#------------------------------------------------------------------------------
sub as2csv {

my ($ligne_as) = @_;
if (($ligne_as =~ /.*3PPN/)&&($ligne_as =~ /.*2rameau/)) {
  $ligne_as =~ s/\ /a/g;
  $ligne_as =~ s/^([0-9]........).*?\$3(PPN[0-9,X]+)\$.*/$1;$2/;
  $ligne_as =~ s/PPN//;

return $ligne_as;
}
else {
  return ;
 }

}


#------------------------------------------------------------------------------
sub verificateur {
  

my ($ligne_fichier_de_base_csv) = @_ ;

  $cpt_total++;
  my ($alp, $ppn_auto) = split (/;/, $ligne_fichier_de_base_csv);

#print $ppn_auto;
    my $subdiv = subdivision::autorite($ppn_auto);
  if ($subdiv) {
  $cpt_nok++;
  chomp $ppn_auto;
   print "Erreur sur $ppn_auto dans $alp : Ne peut pas être employé en tête de vedette\n";
   
   rapport($ppn_auto,$alp)  
     }
   else {
 $cpt_ok++;
     print "$ppn_auto dans $alp : OK\n"
     }
  ;

}

#------------------------------------------------------------------------------
sub rapport {
  my ($ppn_auto,$alp) = @_ ;

  open(LISTE, ">>liste_erreurs.log") || die "Erreur E/S:$!\n";
   print LISTE "Erreur sur $ppn_auto dans $alp\n";
  close LISTE;
}

#================================================================================

open(FICHIER_DE_BASE, $fichier_de_base) ||
  die "ficher $fichier_de_base introuvable : $!";
  
my @fichier_de_base = <FICHIER_DE_BASE>;
close FICHIER_DE_BASE ;

 if ($fichier_de_base[1] =~ /^[0-9]+\ 60.*\ L\ .*/) {
    foreach my $ligne_fichier_de_base (@fichier_de_base) {
    my $ligne_fichier_de_base_csv = as2csv($ligne_fichier_de_base) ;
      if ($ligne_fichier_de_base_csv) { 
        chomp $ligne_fichier_de_base_csv;
        verificateur($ligne_fichier_de_base_csv);
       } 
       else {
        }
    }
 }
   elsif ($fichier_de_base[1] =~ /.........;........./){
    foreach my $ligne_fichier_de_base (@fichier_de_base) {
    verificateur($ligne_fichier_de_base);
    } 
   }

   else {
    print "Format de fichier non reconnu.\n";
    exit;
    }
    ;


open(LOG, ">rapport.log") || die "Erreur E/S:$!\n";
print LOG "Recherches subdivisions employées en tetes de vedette :\n";
print LOG "Total = $cpt_total\n" ;
print LOG "Erreurs = $cpt_nok\n" ;
print LOG "Pas de problèmes = $cpt_ok\n" ;
close LOG;  
close LISTE;  
