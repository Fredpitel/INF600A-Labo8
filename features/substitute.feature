@wip
Feature: Substitution de motif dans un flux de lignes
  De facon a traiter des fichiers de texte comme sed
  Je veux pouvoir effectuer des substitutions avec un motif

  Scenario: Le motif est un mot simple
    Given a file named "foo.txt" with:
    """
    foo bar
    bar
    baz
    fooooo
    """
    When j'execute `mini-sed substitute "foo" "bar" foo.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    bar bar
    bar
    baz
    barooo

    """

  Scenario: Le motif contient deux mots separes par un espace
    Given a file named "foo.txt" with:
    """
    foo bar
    bar
    foo
    fooooo
    """
    When j'execute `mini-sed substitute "foo bar" "" foo.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    
    bar
    foo
    fooooo

    """

  Scenario: Le motif est une expression reguliere simple et traite plusieurs fichiers dont des vides
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
    When j'execute `mini-sed substitute "[abc]*.[12]" "XX" vide.txt foo.txt vide.txt vide.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    XXxaax2
    bar
    foo
    XX
    abcabc33
    XXzz

    """

  Scenario: Le motif est une expression reguliere simple et plusieurs fichiers vides
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

    When j'execute `mini-sed substitute -g "[abc]*.[12]" "XX" vide.txt foo.txt vide.txt vide.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    XXxXX
    bar
    foo
    XX
    abcabc33
    XXzz

    """

  Scenario: Le motif est une expression reguliere simple et on traite stdin
    Given a file named "foo.txt" with:
    """
    aaax2xaax2
    foo
    abcabc32zz
    """

    When j'execute `mini-sed substitute -g "[abc]*.[12]" "XX"` en lui pipant le fichier "foo.txt"

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    XXxXX
    foo
    XXzz

    """
