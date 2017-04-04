Feature: Suppression de lignes dans un fichier qu'on modifie directement
  De facon a traiter des fichiers de texte comme sed
  Je veux pouvoir supprimer des lignes qui matchent un motif en modifiant directement les fichiers traites

  Scenario: Le motif contient une expression reguliere simple et traite un fichier en place en specifiant un backup
    Given a file named "foo.txt" with:
    """
    aaax2xaax2
    bar
    abcabc32zz

    """

    When j'execute `mini-sed --in-place=.bak delete "[abc]*.[12]" foo.txt`

    Then the exit status should be 0
    And the stdout should not contain anything

    And the file "foo.txt" should contain exactly:
    """
    bar

    """

    And the file "foo.txt.bak" should contain exactly:
    """
    aaax2xaax2
    bar
    abcabc32zz

    """
  Scenario: Le motif contient une expression reguliere simple et traite un fichier en place sans specifier un backup
    Given a file named "foo.txt" with:
    """
    aaax2xaax2
    bar
    abcabc32zz

    """

    When j'execute `mini-sed --in-place='' delete "[abc]*.[12]" foo.txt`
    And j'execute `ls`

    Then the exit status should be 0
    And the output should match /^\s*foo.txt\s*$/

    And the file "foo.txt" should contain exactly:
    """
    bar

    """

