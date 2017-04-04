gem 'minitest', '=5.4.3'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'

class Object
  def _describe( test )
    puts "--- On saute les tests pour \"#{test}\" ---"
  end

  def _it( test )
    puts "--- On saute le test \"#{test}\" ---"
  end

  alias_method :context, :describe
end

#
# Cree un fichier temporaire avec le contenu indique.  Execute ensuite
# le bloc recu, puis supprime le fichier temporaire.
#
# @param [String] nom_fichier
# @param [Array<String>] contenu lignes contenues dans le fichier
# @return [void]
# @yield [void]
#
def avec_fichier( nom_fichier, lignes = [], conserver = nil )
  # On cree le fichier.
  File.open( nom_fichier, "w" ) do |fich|
    lignes.each do |ligne|
      fich.puts  ligne
    end
  end

  # On execute le bloc.
  yield

  # On supprime le fichier sauf si indique autrement, auquel cas on
  # retourne son contenu.
  if conserver
    contenu_fichier( nom_fichier )
  else
    FileUtils.rm_f nom_fichier
  end
end

#
# Retourne le contenu d'un fichier sous forme d'une liste de lignes,
# sans les sauts de lignes.
#
# @param [String] nom_fichier
# @return [Array<String>] ou les "\n" finaux ont ete supprimes
#
def contenu_fichier( nom_fichier )
  IO.readlines(nom_fichier).map(&:chomp)
end
