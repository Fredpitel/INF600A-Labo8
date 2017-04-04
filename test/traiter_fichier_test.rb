require 'test_helper'
require 'mini-sed'

describe MiniSed do
  describe ".traiter_fichier" do
    let(:contenu) {  ["abc\n", "def\n"] }
    let(:resultats_stdout) { [] }

    describe "sur stdin" do
      it "genere une erreur lorsqu'on tente de traiter en place" do
        lambda { MiniSed.traiter_fichier( :stdin, '' ) { |_| } }.must_raise DBC::Failure
      end

      it "emet sur stdout lorsqu'ne traite pas en place" do
        $stdout.stub :puts, ->(l) { resultats_stdout << l } do
          MiniSed.traiter_fichier( :stdin ) { |_| contenu }
        end

        resultats_stdout.must_equal contenu
      end
    end

    describe "sur fichier autre que stdin" do
      let(:nom_fichier) { 'foo.txt' }

      it "emet sur stdout lorsqu'on ne traite pas en place" do
        avec_fichier nom_fichier, contenu, :conserver do
          $stdout.stub :puts, ->(l) { resultats_stdout << l } do
            MiniSed.traiter_fichier( nom_fichier ) { |flux| contenu + contenu }
          end
        end

        resultats_stdout.must_equal contenu + contenu
        contenu_fichier(nom_fichier).must_equal (contenu).map(&:chomp)
      end

      it "modifie le fichier lorsqu'on le traite en place sans rien emettre sur stdout" do
        avec_fichier nom_fichier, contenu, :conserver do
          $stdout.stub :puts, ->(l) { resultats_stdout << l } do
            MiniSed.traiter_fichier( nom_fichier, '' ) { |flux| contenu + contenu }
          end
        end

        resultats_stdout.must_be_empty
        contenu_fichier(nom_fichier).must_equal (contenu + contenu).map(&:chomp)

        FileUtils.rm_f nom_fichier
      end

      it "modifie le fichier lorsqu'on traite en place et fait une copie de sauvegarde sans rien emettre sur stdout" do
        avec_fichier nom_fichier, contenu, :conserver do
          $stdout.stub :puts, ->(l) { resultats_stdout << l } do
            MiniSed.traiter_fichier( nom_fichier, 'foo' ) { |flux| contenu + contenu }
          end
        end

        resultats_stdout.must_be_empty
        contenu_fichier(nom_fichier).must_equal (contenu + contenu).map(&:chomp)
        contenu_fichier(nom_fichier + 'foo').must_equal (contenu).map(&:chomp)

        FileUtils.rm_f nom_fichier
        FileUtils.rm_f nom_fichier + 'foo'
      end
    end
  end
end
