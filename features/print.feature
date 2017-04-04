Feature: Imprimer des lignes

  Scenario: Le motif est un mot simple
    Given a file named "foo.txt" with:
    """
    foo bar
    bar
    baz
    fooooo
    """

    When j'execute `mini-sed print "foo" foo.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    foo bar
    foo bar
    bar
    baz
    fooooo
    fooooo

    """

  Scenario: Le motif contient deux mots separes par un espace
    Given a file named "foo.txt" with:
    """
    foo bar
    bar
    foo
    fooooo
    """
    When j'execute `mini-sed print "foo bar" foo.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    foo bar
    foo bar
    bar
    foo
    fooooo

    """

  Scenario: Le motif contient une expression reguliere simple et plusieurs fichiers vides
    Given a file named "foo.txt" with:
    """
    aaax2x
    bar
    foo
    abcabc12
    abcabc33
    abcabc32
    """

    And a file named "vide.txt" with:
    """
    """

    When j'execute `mini-sed print "[abc]*.[12]" vide.txt foo.txt vide.txt vide.txt`

    Then the exit status should be 0
    And the stdout should contain exactly:
    """
    aaax2x
    aaax2x
    bar
    foo
    abcabc12
    abcabc12
    abcabc33
    abcabc32
    abcabc32

    """
