require 'test_helper'
require 'mini-sed'

describe MiniSed do
  describe "substitute" do
    it "change seulement la 1ere occurrence sans l'option -g" do
      avec_fichier 'foo.txt', ["0abc!", "==", "abcdef9abc"] do
        mini_sed( 'substitute "abc" "XX" <foo.txt' ).
          must_equal ["0XX!", "==", "XXdef9abc"]
      end
    end

    it "change toutes les occurrences, modifie le fichier et cree une copie" do
      entree = ["0abc!", "==", "abcdef9abc"]
      cmd = '--in-place=.bak substitute -g "abc" "XX" foo.txt'
      sortie = ["0XX!", "==", "XXdef9XX"]

      avec_fichier 'foo.txt', entree do
        stdout = mini_sed( cmd )

        stdout.must_equal []
        contenu_fichier( 'foo.txt' ).must_equal sortie
        contenu_fichier( 'foo.txt.bak' ).must_equal entree
      end

      FileUtils.rm_f 'foo.txt.bak'
    end

    it "change toutes les occurrences, modifie le fichier sans creer de copie" do
      entree = ["0abc!", "==", "abcdef9abc"]
      cmd = '--in-place="" substitute -g "abc" "XX" foo.txt'
      sortie = ["0XX!", "==", "XXdef9XX"]
      ls_avant = %x{ls -1} # Liste des fichiers dans le repertoire.

      avec_fichier 'foo.txt', entree do
        stdout = mini_sed( cmd )

        stdout.must_equal []
        contenu_fichier( 'foo.txt' ).must_equal sortie
      end

      %x{ls -1}.must_equal ls_avant # La liste n'a pas change!
    end

    it "substitue seulement la premiere occurrence sans l'option -g" do
      avec_fichier 'foo.txt', ["aaax2xaax2", "==", "abcabc32zz22"] do
        avec_fichier 'vide.txt', [] do
          mini_sed( 'substitute "[abc]*.[12]" "XX" <foo.txt' ).
            must_equal ["XXxaax2", "==", "XXzz22"]
        end
      end
    end

    it "modifie toutes les occurrences avec l'option -g" do
      avec_fichier 'foo.txt', ["aaax2xaax2", "==", "abcabc32zz22"] do
        mini_sed( 'substitute -g "[abc]*.[12]" "XX" <foo.txt' ).
          must_equal ["XXxXX", "==", "XXzXX2"]
      end
    end

    it "modifie chaque ligne qui matche et ce avec plusieurs fichiers" do
      entree = [ "aaax2xaax2", "bar", "==", "abcabc12", "abcabc33", "abcabc32zz"]
      entree_modifiee = [ "XXxaax2", "bar", "==", "XX", "abcabc33", "XXzz"]

      avec_fichier 'foo.txt', entree do
        avec_fichier 'vide.txt', [] do
          mini_sed( 'substitute "[abc]*.[12]" "XX" foo.txt vide.txt foo.txt vide.txt' ).
            must_equal entree_modifiee + entree_modifiee
        end
      end
    end
  end
end
