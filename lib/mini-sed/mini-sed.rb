module MiniSed

  # Classe interne pour representer une transformation de flux par
  # l'une des commandes de MiniSed.
  #
  # La seule methode d'un objet de cette classe est each, pour
  # representer le flux transformer, i.e., enumerer les elements
  # resultants de la transformation du flux d'entree par la commande,
  # avec son motif et ses options.
  #
  class TransformateurDeFlux
    include Enumerable

    # Initialise un nouvel objet.
    #
    # @param [#each] flux le flux de donnees a traiter
    # @param [Regexp] motif motif recherche sur chaque ligne
    # @param [Hash] options les options specifiques a chaque commande
    # @option options [String] :chaine_de_remplacement (substitute)
    # @option options [Bool] :global remplacement global ou pas (substitute)
    #
    def initialize( flux, motif, options = {} )
      @flux = flux
      @motif = motif
      @options = options
    end

    # Iterateur par defaut, qui sera redefini pour chaque operation
    # specifique.
    #
    # La transformation par defaut est l'identite = transmet chaque
    # element tel quel, sans rien changer.
    #
    def each
      @flux.each do |ligne|
        yield(ligne)
      end
    end
  end

  def self.delete( flux, motif )
    ms = TransformateurDeFlux.new( flux, motif )

    # A COMPLETER: def ms.each ...

    ms
  end

  def self.print( flux, motif )
    ms = TransformateurDeFlux.new( flux, motif )

    # A COMPLETER: def ms.each ...

    ms
  end

  # Effectue l'operation de substitution sur un flux de donnees.
  #
  # @param [#each] flux le flux de donnees a traiter
  # @param [Regexp] motif le motif a chercher
  # @param [String] chaine la chaine de remplacement
  # @param [Bool] global substitution globale
  #                      (toute la ligne) ou non (1ere occurrence)
  #
  # @return [Enumerable] un flux avec les lignes transformees
  #
  def self.substitute( flux, motif, chaine, global )
    ms = TransformateurDeFlux.new( flux, motif,
                                   chaine_de_remplacement: chaine,
                                   global: global )

    def ms.each
      global = @options[:global]
      chaine = @options[:chaine_de_remplacement]
      motif = /#{@motif}/

      @flux.each do |ligne|
        if motif =~ ligne
          yield( global ? ligne.gsub!(motif, chaine) : ligne.sub!(motif, chaine) )
        else
          yield( ligne )
        end
      end
    end

    ms
  end



end
