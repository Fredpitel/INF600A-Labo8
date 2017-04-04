require 'test_helper'
require 'mini-sed'

describe MiniSed do
  describe ".print" do
    context "sur un flux vide represente par un Array vide" do
      it "retourne []" do
        MiniSed.print( [], nil )
          .to_a
          .must_be_empty
      end
    end

    context "sur un petit flux represente par un Array" do
      it "retourne les lignes qui matchent en double" do
        MiniSed.print( ["abc", "def", "aaa", "", "xxx"], "a" )
          .to_a
          .must_equal ["abc", "abc", "def", "aaa", "aaa", "", "xxx"]
      end
    end

    context "sur un flux represente par un gros Array" do
      let(:nb_lignes) { 100 }
      let(:les_lignes) { (1..nb_lignes).map { "abc\n" } }

      def en_double( lignes )
        lignes
          .reduce([]) { |resultats, ligne| resultats << ligne << ligne }
      end

      it "retourne les elements inchanges lorsque que rien ne matche" do
        MiniSed.print( les_lignes, "xxx" )
          .to_a
          .must_equal les_lignes
      end

      it "retourne tout en double lorsque tout matche" do
        MiniSed.print( les_lignes, "a" )
          .to_a
          .must_equal en_double(les_lignes)
      end
    end
  end
end
