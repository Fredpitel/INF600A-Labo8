require 'test_helper'
require 'mini-sed'

describe MiniSed do
  describe ".insert" do
    describe "cas avec aucune ligne a traiter" do
      it "retourne [] lorsque recoit []" do
        MiniSed.insert( [], nil, nil ).to_a
          .must_be_empty
      end
    end

    describe "cas simple avec quelques lignes" do
      let(:lignes) { ["aabc\n", "def\n", "aa aa\n"] }

      it "insere uniquement devant les lignes qui matchent" do
        MiniSed.insert( lignes, "a", "xxx" ).to_a
          .must_equal ["xxx\n", "aabc\n", "def\n", "xxx\n", "aa aa\n"]
      end

      it "insere devant chaque ligne lorsque chaque ligne matche" do
        MiniSed.insert( lignes, ".", "xxx" ).to_a
          .must_equal ["xxx\n", "aabc\n", "xxx\n", "def\n", "xxx\n", "aa aa\n"]
      end

      it "insere nulle part lorsque ce ne matche pas" do
        MiniSed.insert( lignes, "xxx", "xxx" ).to_a
          .must_equal lignes
      end
    end

    describe "cas avec plusieurs lignes" do
      let(:nb) { 7 }
      let(:plusieurs_lignes) { (1..nb).map { "abc\n" } }
      let(:resultat_attendu) { (1..nb).map { ["def\n", "abc\n"] }.flatten }

      it "retourne les lignes recues lorsque le motif ne matche pas" do
        MiniSed.insert( plusieurs_lignes, "X", "abc" ).to_a
          .must_equal plusieurs_lignes
      end

      it "ajoute les lignes appropriees devant chaque ligne lorsqu'elles matchent toutes" do
        MiniSed.insert( plusieurs_lignes, ".*", "def" ).to_a
          .must_equal resultat_attendu
      end
    end
  end
end
