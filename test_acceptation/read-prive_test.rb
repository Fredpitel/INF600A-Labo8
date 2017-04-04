require 'test_helper'
require 'mini-sed'

describe MiniSed do
  describe "read" do
    it "lit contenu du fichier" do
      lignes_a_inserer = ["123", "456"]
      entree = ["aaax2xaax2", "foo", "abcabc12"]
      resultat = ["aaax2xaax2", "123", "456", "foo", "abcabc12"]

      avec_fichier 'lignes.txt', lignes_a_inserer do
        avec_fichier 'foo.txt', entree do
          mini_sed( 'read foo lignes.txt foo.txt' ).
            must_equal resultat
        end
      end
    end
  end
end
