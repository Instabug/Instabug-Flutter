# Make sure PR has a description.
if github.pr_body.length < 3 && git.lines_of_code > 10
  fail "Please provide a summary of the changes in the pull request description."
end