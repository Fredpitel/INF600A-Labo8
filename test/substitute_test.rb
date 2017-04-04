require 'test_helper'
require 'mini-sed'

describe MiniSed do
  describe ".substitute" do
    describe "cas avec aucune ligne a traiter" do
      it "retourne [] lorsque recoit []" do
        MiniSed.substitute( [], nil, nil, false ).to_a
          .must_be_empty
      end
    end

    describe "cas avec plusieurs lignes" do
      let(:nb_lignes) { 10 }
      let(:plusieurs_lignes) { (1..nb_lignes).map { "abc\n" } }

      it "ne change rien lorsque le motif ne matche pas" do
        MiniSed.substitute( plusieurs_lignes, "X", "", true ).to_a
          .must_equal plusieurs_lignes
      end

      it "ne change rien lorsque le remplacement = le motif" do
        MiniSed.substitute( plusieurs_lignes, "abc", "abc", true ).to_a
          .must_equal plusieurs_lignes
      end

      it "vide les lignes lorsqu'on substitue par une chaine vide" do
        MiniSed.substitute( ["abc def\n", "abc def\n"], ".", "", true ).to_a
          .must_equal ["\n", "\n"]
      end

      describe "substitution globale ou non" do
        let(:juste_des_a) { ["aaadef\n", "123aaa\n"] }

        it "effectue un seul remplacementlorsque global est false" do
          MiniSed.substitute( juste_des_a, "a", "X", false ).to_a
            .must_equal ["Xaadef\n", "123Xaa\n"]
        end

        it "effectue le remplacement partout lorsque global est true" do
          MiniSed.substitute( juste_des_a, "a", "X", true ).to_a
            .must_equal ["XXXdef\n", "123XXX\n"]
        end
      end
    end
  end
end
