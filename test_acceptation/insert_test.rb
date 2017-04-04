require 'test_helper'
require 'mini-sed'

describe MiniSed do
  describe "insert" do
    it "ajoute une ligne devant celles qui matchent avec un fichier explicite" do
      avec_fichier 'foo.txt', ["foo bar", "  bar", "baz", "fooooo"] do
        mini_sed( 'insert "foo" "bar" foo.txt' ).
          must_equal ["bar", "foo bar", "  bar", "baz", "bar", "fooooo"]
      end
    end

    it "ajoute une ligne devant celles qui matchent et ce avec plusieurs fichiers" do
      entree = ["aaax2xaax2", "foo", "abcabc12"]
      entree_modifiee = ["XX", "aaax2xaax2", "foo", "XX", "abcabc12"]

      avec_fichier 'foo.txt', entree do
        avec_fichier 'vide.txt', [] do
          mini_sed( 'insert "[abc]*.[12]" "XX" foo.txt vide.txt foo.txt vide.txt' ).
            must_equal entree_modifiee + entree_modifiee
        end
      end
    end

    it "ajoute une ligne directement dans le fichier en mode in-place en creant un backup" do
      lignes = ["aaax2xaax2", "bar", "foo", "abcabc12"]
      avec_fichier 'foo.txt', lignes do
        mini_sed( '--in-place=.bak insert "[abc]*.[12]" "XX" foo.txt' ).
          must_equal []

        contenu_fichier( 'foo.txt.bak' ).
          must_equal lignes

        contenu_fichier( 'foo.txt' ).
          must_equal ["XX", "aaax2xaax2", "bar", "foo", "XX", "abcabc12"]
      end
      FileUtils.rm_f 'foo.txt.bak'
    end

    it "ajoute une ligne directement dans le fichier en mode in-place sans creer un backup" do
      lignes = ["aaax2xaax2", "bar", "foo", "abcabc12"]

      avec_fichier 'foo.txt', lignes do
        mini_sed( '--in-place="" insert "[abc]*.[12]" "XX" foo.txt' ).
          must_equal []

        contenu_fichier( 'foo.txt' ).
          must_equal ["XX", "aaax2xaax2", "bar", "foo", "XX", "abcabc12"]
      end
    end
  end
end
