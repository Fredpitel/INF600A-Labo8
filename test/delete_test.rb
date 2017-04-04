require 'test_helper'
require 'mini-sed'

describe MiniSed do
  describe ".delete" do
    let(:lignes) { ["abc", "def", "aB", "abab"] }

    context "sur un Array" do
      it "retourne rien si aucune ligne" do
        MiniSed.delete( [], "ab" )
          .to_a
          .must_be_empty
      end

      it "supprime uniquement les lignes qui matchent" do
        MiniSed.delete( lignes, "ab" )
          .to_a
          .must_equal ["def", "aB"]
      end

      it "supprime toutes les lignes lorsque le motif matche partout" do
        MiniSed.delete( lignes, "." )
          .to_a
          .must_be_empty
      end

      it "supprime rien lorsque le motif ne matche pas" do
        MiniSed.delete( lignes, "X" )
          .to_a
          .must_equal lignes
      end
    end

    context "sur un vrai fichier" do
      it "traite le flux de lignes du fichier en supprimant les lignes qui matchent" do
        nom_fichier = 'foo.txt'

        avec_fichier nom_fichier, lignes do
          MiniSed.delete( File.new(nom_fichier), "ab" )
            .to_a
            .must_equal ["def\n", "aB\n"]
        end
      end
    end
  end
end
