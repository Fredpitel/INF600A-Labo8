require 'test_helper'
require 'mini-sed'

# VOIR LE FICHIER test_acceptation/test_helper.rb pour les definitions
# des methodes avec_fichier et mini_sed.
#
# Cette derniere appelle, au niveau du shell, l'executable
# bin/mini-sed avec les arguments indiques puis retourne un tableau
# (Array) des lignes produites sur $stdout... sans les sauts de ligne!
#

describe MiniSed do
  describe ".delete" do
    it "supprime les lignes qui matchent avec un fichier explicite" do
      avec_fichier 'foo.txt', ["foo bar", "  bar", "baz", "fooooo"] do
        mini_sed( 'delete "foo" foo.txt' )
          .must_equal ["  bar", "baz"]
      end
    end

    it "supprime les lignes qui matchent et ce avec plusieurs fichiers" do
      entree = ["aaax2xaax2", "foo", "abcaaabc12"]

      avec_fichier 'foo.txt', entree do
        avec_fichier 'vide.txt', [] do
          mini_sed( 'delete "aa" foo.txt vide.txt foo.txt vide.txt' )
            .must_equal ["foo", "foo"]
        end
      end
    end

    it "supprime une ligne directement dans le fichier en mode in-place en creant un backup" do
      lignes = ["aaax2xaax2", "bar", "foo", "aaabcabc12"]

      avec_fichier 'foo.txt', lignes do
        mini_sed( '--in-place=.bak delete "aa" foo.txt' )
          .must_equal []

        contenu_fichier( 'foo.txt.bak' )
          .must_equal lignes

        contenu_fichier( 'foo.txt' )
          .must_equal ["bar", "foo"]
      end

      FileUtils.rm_f 'foo.txt.bak'
    end

    it "supprime une ligne directement dans le fichier en mode in-place sans creer un backup" do
      lignes = ["aaax2xaax2", "bar", "foo", "abcaaabc12"]

      avec_fichier 'foo.txt', lignes do
        mini_sed( '--in-place="" delete "aa" foo.txt' )
          .must_be_empty

        contenu_fichier( 'foo.txt' )
          .must_equal ["bar", "foo"]
      end
    end
  end
end
