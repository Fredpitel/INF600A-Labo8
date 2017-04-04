@wip
Feature: Substitution de motif dans un fichier qu'on modifie directement
  De facon a traiter des fichiers de texte comme sed
  Je veux pouvoir effectuer des substitutions avec un motif en modifiant directement les fichiers traites

  Scenario: Le motif contient une expression reguliere simple et traite un fichier en place en specifiant un backup
    Given a file named "foo.txt" with:
    """
    aaax2xaax2
    bar
    fooabc2z
    abcabc32zz
    """

    When j'execute `mini-sed --in-place=.bak substitute -g "[abc]*.[12]" "XX" foo.txt`

    Then the exit status should be 0
    And the stdout should not contain anything

    And the file "foo.txt" should contain exactly:
    """
    XXxXX
    bar
    fooXXz
    XXzz
    """

    And the file "foo.txt.bak" should contain exactly:
    """
    aaax2xaax2
    bar
    fooabc2z
    abcabc32zz
    """

  Scenario: Le motif contient une expression reguliere simple et traite un fichier en place sans specifier un backup
    Given a file named "foo.txt" with:
    """
    aaax2xaax2
    bar
    abcabc33
    abcabc32zz
    """

    When j'execute `mini-sed -i '' substitute -g "[abc]*.[12]" "XX" foo.txt`
    And j'execute `ls`

    Then the exit status should be 0
    And the output should match /^\s*foo.txt\s*$/

    And the file "foo.txt" should contain exactly:
    """
    XXxXX
    bar
    abcabc33
    XXzz
    """

