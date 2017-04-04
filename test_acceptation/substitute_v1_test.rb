require 'test_helper'
require 'mini-sed'

describe MiniSed do
  describe "substitute -- premiere version" do
    it "change seulement la 1ere occurrence sans l'option -g" do
      # Setup.
      nom_fichier = 'foo.txt'
      contenu = "123abc456\nfoo\nabcdef999abc\n"
      File.open( nom_fichier, "w" ) do |fich|
        fich.print contenu
      end

      # Exercise
      cmd = 'substitute "abc" "XX" <foo.txt'
      obtenu = %x{bundle exec bin/mini-sed #{cmd}}

      # Verify.
      obtenu.must_equal "123XX456\nfoo\nXXdef999abc\n"

      # Tear down.
      FileUtils.rm_f nom_fichier
    end

    it "change seulement la 1ere occurrence sans l'option -g" do
      # Setup.
      nom_fichier = 'foo.txt'
      contenu = ["123abc456", "foo", "abcdef999abc"]
      File.open( nom_fichier, "w" ) do |fich|
        contenu.each { |ligne| fich.puts ligne }
      end

      # Exercise
      cmd = 'substitute "abc" "XX" <foo.txt'
      obtenu = %x{bundle exec bin/mini-sed #{cmd}}.split("\n")

      # Verify.
      obtenu.must_equal ["123XX456", "foo", "XXdef999abc"]

      # Tear down.
      FileUtils.rm_f nom_fichier
    end

    it "substitue seulement la premiere occurrence sans l'option -g" do
      # Setup.
      nom_fichier = 'foo.txt'
      contenu = ["aaax2xaax2", "foo", "abcabc32zz22"]
      File.open( nom_fichier, "w" ) do |fich|
        contenu.each { |ligne| fich.puts  ligne }
      end

      # Exercise
      cmd = 'substitute "[abc]*.[12]" "XX" <foo.txt'
      obtenu = %x{bundle exec bin/mini-sed #{cmd}}.split("\n")

      # Verify.
      obtenu.must_equal ["XXxaax2", "foo", "XXzz22"]

      # Tear down.
      FileUtils.rm_f nom_fichier
    end

    it "modifie chaque ligne qui matche et ce avec plusieurs fichiers" do
      # Setup.
      nom_fichier1 = 'foo.txt'
      contenu = ["aaax2xaax2", "foo", "abcabc32zz22"]
      File.open( nom_fichier1, "w" ) do |fich|
        contenu.each { |ligne| fich.puts  ligne }
      end
      nom_fichier2 = 'vide.txt'
      contenu = []
      File.open( nom_fichier2, "w" ) do |fich|
        contenu.each { |ligne| fich.puts  ligne }
      end

      # Exercise
      cmd = 'substitute "[abc]*.[12]" "XX" foo.txt foo.txt'
      obtenu = %x{bundle exec bin/mini-sed #{cmd}}.split("\n")

      # Verify.
      obtenu.must_equal ["XXxaax2", "foo", "XXzz22", "XXxaax2", "foo", "XXzz22"]

      # Tear down.
      FileUtils.rm_f nom_fichier1
      FileUtils.rm_f nom_fichier2
    end
  end
end
