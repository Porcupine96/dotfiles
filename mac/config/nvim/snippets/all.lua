-- Autosnippets: they expand the moment the keyword is typed, as Raycast does,
-- in every filetype. A keyword typed straight after a letter or digit
-- (`f(x,test)`) is left alone, so commas in code do not trigger them.

local function expansion(trig, name, text)
  return s(
    { trig = trig, name = name, snippetType = "autosnippet" },
    t(vim.split(text, "\n", { plain = true }))
  )
end

return {
  expansion(",acp", "Add, Commit, Push, Create MR (simple)", "Add, Commit, Push, Create a merge requests according to our template. Keep the description short and concise. Then watch the MR pipeline, if it fails, fix the errors."),
  expansion(",ar", "As you recommend", "As you recommend"),
  expansion(",cr", "Run /cr", "After the MR buils call the /cr skill on the GitLab URL."),
  expansion(",forkmerge", "react-fork-3 merge", [[
We routinely need to merge the master to the react-fork-3.

Since the last merge, we deployed some changes to master.
Checkout origin/react-fork-3 in a worktree.
Pull the current master to react-fork-3 and help me resolve conflicts.
Create a MR to origin/react-fork-3 and open it in my browser. When creating the MR, create it with squash disabled (squash: false). This is a merge MR — squashing collapses the merge commit and drops its second parent, so git loses the record that master was merged and the next sync re-conflicts from the old merge base. The project defaults squash to on, so you must set it explicitly.

Then monitor the pipeline for successful build. If it fails, fix the errors and try again.]]),
  expansion(",lab", "Label dev-zowie-engine1", "When creating the MR use label: dev-zowie-engine1"),
  expansion(",mem", "mermaid", "Use mermeid diagrams to facilitate comprehension."),
  expansion(",nb", "Create a new branch starting from origin/master.", "Create a new branch starting from origin/master."),
  expansion(",retag", "prod-retag failed", "I see that the prod-retag failed because another MR has been merged. Pull the origin master to the MR's branch, resolve the conflicts if any and monitor the MR for successful build."),
  expansion(",rs", "Read the following Slack thread:", "Read the following Slack thread: "),
  expansion(",shee", "shee", "save as CSV in /tmp and call shee -o on it"),
  expansion(",slack", "Slack Review Request", "Prepare a message to #ai-agent-backend-code-review channel based on my recent messages from this channel."),
  expansion(",test", "Test on dev", "When the MR builds and the changes are deployed to dev zowie-engine1 test them on a chatbot: d23287a7f9e04fb394667c251812f334 and testing with zowie-cli chat.  Report back a table summarizing the tests you performed including interactionIds."),
  expansion(",wt", "Use a worktree", "Use a worktree."),
  expansion(",pfail", "The pipeline failed", "The pipeline failed, check the error, retry and if needed fix. Monitor the pipeline for successful build.")
}
