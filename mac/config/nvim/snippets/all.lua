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
  expansion(",all", "New branch, MR, label, test on dev", [[
- Create a new branch starting from origin/master. Use a worktree.
- Add, Commit, Push, Create a merge requests according to our template. Keep the description short and concise. Then watch the MR pipeline, if it fails, fix the errors.
- When creating the MR use label: dev-zowie-engine1
- When the MR builds and the changes are deployed to dev zowie-engine1 test them on a chatbot: d23287a7f9e04fb394667c251812f334 and testing with zowie-cli chat.  Report back a table summarizing the tests you performed including interactionIds.]]),
  expansion(",ar", "As you recommend", "As you recommend"),
  expansion(",as_html", "As HTML report in ~/work/notes/", "Present as a single page HTML. Make the page clear, easy to follow and interactive where it would help comprehension. The page should be light-themed by default with an icon in the top-right corner that allows toggling between light and dark themes. Save the page under ~/work/notes/ and open it in my browser."),
  expansion(",ccol", "Chatbot: dc, environment, chatbot", [[
- dc (EU|US)
- environmentName
- environmentId
- chatbotName
- chatbotId]]),
  expansion(",cr", "Run /cr", "After the MR buils call the /cr skill on the GitLab URL."),
  expansion(",deploy", "Build, prod deploy, merge", [[Watch the MR below for successful build. Once it builds run "prod-check" and then, once ready "prod-eu1-deploy" and "prod-us1-deploy". After they pass, merge the MR.]]),
  expansion(",forkmerge", "react-fork-3 merge", [[
We routinely need to merge the master to the react-fork-3.

Since the last merge, we deployed some changes to master.
Checkout origin/react-fork-3 in a worktree.
Pull the current master to react-fork-3 and help me resolve conflicts.
Create a MR to origin/react-fork-3 and open it in my browser. When creating the MR, create it with squash disabled (squash: false). This is a merge MR — squashing collapses the merge commit and drops its second parent, so git loses the record that master was merged and the next sync re-conflicts from the old merge base. The project defaults squash to on, so you must set it explicitly.

Then monitor the pipeline for successful build. If it fails, fix the errors and try again.]]),
  expansion(",full", "New branch, MR, label, genai-review, test on dev", [[
- Create a new branch starting from origin/master. Use a worktree.
- Add, Commit, Push, Create a merge requests according to our template. Keep the description short and concise. Then watch the MR pipeline, if it fails, fix the errors.
- When creating the MR use label: dev-zowie-engine1
- After the MR is ready ask a separate CC session to run the /genai-review skill and read the reviewer's feedback
  - If there are no comments proceed to the test stage
  - If there are some comments, judge whether the reviewer's feedback should be fixed in this MR
  - If you make any changes in this step, rerun the /genai-review skill again in a separate session
  - The /genai-review skill should be ran at most 2 times
  - At the end shortly summarize the reviewer's feedback with info about what changes were appplied / rejected / are valid but should be posponed
- When the MR builds and the changes are deployed to dev zowie-engine1 test them on a chatbot: d23287a7f9e04fb394667c251812f334 and testing with zowie-cli chat. Report back a table summarizing the tests you performed including interactionIds.
- After you finish testing, remove the dev label from the MR.]]),
  expansion(",hot", "Hotfix, no approval", "[APPROVAL NOT NEEDED -- HOTFIX]"),
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
