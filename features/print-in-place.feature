Feature: Impression de lignes dans un fichier qu'on modifie directement
  De facon a traiter des fichiers de texte comme sed
  Je veux pouvoir imprimer des lignes qui matchent un motif en modifiant directement les fichiers traites

  Scenario: Le motif contient une expression reguliere simple et traite un fichier en place en specifiant un backup
    Given a file named "foo.txt" with:
    """
    aaax2xaax2
    bar
    abcabc32zz

    """

    When j'execute `mini-sed --in-place=.bak print "[abc]*.[12]" foo.txt`

    Then the exit status should be 0
    And the stdout should not contain anything

    And the file "foo.txt" should contain exactly:
    """
    aaax2xaax2
    aaax2xaax2
    bar
    abcabc32zz
    abcabc32zz

    """

    And the file "foo.txt.bak" should contain exactly:
    """
    aaax2xaax2
    bar
    abcabc32zz

    """

  Scenario: Le motif contient une expression reguliere simple et traite un fichier en place sans backup
    Given a file named "foo.txt" with:
    """
    aaax2xaax2
    bar
    abcabc32zz

    """

    When j'execute `mini-sed --in-place='' print "[abc]*.[12]" foo.txt`

    Then the exit status should be 0
    And the stdout should not contain anything

    And the file "foo.txt" should contain exactly:
    """
    aaax2xaax2
    aaax2xaax2
    bar
    abcabc32zz
    abcabc32zz

    """
