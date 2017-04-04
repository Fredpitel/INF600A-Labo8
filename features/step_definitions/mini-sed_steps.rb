When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

When /^j'execute `([^`]*)`$/ do |cmd|
  step %(I run `#{cmd}`)
end

When /^j'execute `([^`]*)` en lui pipant le fichier "([^"]*)"$/ do |cmd, fichier|
  step %(I run `#{cmd}` interactively)
  step %(I pipe in the file "#{fichier}")
end

# Add more step definitions here
