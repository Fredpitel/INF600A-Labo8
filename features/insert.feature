Feature: Insertion d'une chaine dans un flux de lignes
  De facon a traiter des fichiers de texte comme sed
  Je veux pouvoir effectuer des insertions de chain avant les lignes qui matchent un motif

  Scenario: Le motif est un mot simple et on insere devant quelques lignes
    Given a file named "foo.txt" with:
    """
    foo bar
    bar
    baz
    fooooo
    """
    When j'execute `mini-sed insert "foo" "bar" foo.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    bar
    foo bar
    bar
    baz
    bar
    fooooo

    """

  Scenario: Le motif contient deux mots separes par un espace et on insere une ligne vide devant quelques lignes
    Given a file named "foo.txt" with:
    """
    foo bar
    bar
    foo
    fooooo
    """
    When j'execute `mini-sed insert "foo bar" "" foo.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """

    foo bar
    bar
    foo
    fooooo

    """

  Scenario: Le motif contient une expression reguliere simple et traite plusieurs fichiers dont des vides
    Given a file named "foo.txt" with:
    """
    aaax2xaax2
    bar
    foo
    abcabc12
    abcabc33
    abcabc32zz
    """

    And a file named "vide.txt" with:
    """
    """
    When j'execute `mini-sed insert "[abc]*.[12]" "XX" vide.txt foo.txt vide.txt vide.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    XX
    aaax2xaax2
    bar
    foo
    XX
    abcabc12
    abcabc33
    XX
    abcabc32zz

    """

