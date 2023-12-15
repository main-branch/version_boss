const core = require('@actions/core');
const github = require('@actions/github');

function workflowSucceeded(jobs) {
  // return true if all jobs that are completed have a successful conclusion
  return jobs.filter(job => job.status === 'completed').every(job => job.conclusion === 'success');
}

async function run() {
  try {
    const token = core.getInput('github_token');
    const repository = core.getInput('repository') || github.context.repo.repo;
    const owner = github.context.repo.owner;
    const runId = core.getInput('run_id') || github.context.runId;
    const perPage = core.getInput('per_page') || 30;

    const octokit = github.getOctokit(token);

    const jobs = await octokit.rest.actions.listJobsForWorkflowRun({
      owner,
      repo: repository,
      run_id: runId,
      per_page: parseInt(perPage)
    }).data.jobs;

    // // Log the github context
    // core.info("\nGithub context:");
    // core.info(JSON.stringify(github.context, null, 2));

    // // Log the jobs array
    // core.info("\n\nJobs data:");
    // core.info(JSON.stringify(jobs, null, 2));

    // Create a slack message using a heredoc string template to report the workflow status
    const workflow_status = workflowSucceeded(jobs) ? 'SUCCESS :sunny:' : 'FAILURE :rain_cloud:';

    const pull_request = github.context.payload.pull_request;
    const serverUrl = process.env.GITHUB_SERVER_URL;
    const run_url = `${serverUrl}/${owner}/${repository}/actions/runs/${runId}`;
    const title = `[${pull_request.title}](${run_url})`;

    // ref should be a link to the pull request and the link text should be the repository owner/name and the pull request number
    const ref = `[${owner}/${repository}#${pull_request.number}](${pull_request.html_url})`;

    const message = `${workflowStatus} ${title} (${ref})`;
    core.info(`\n\nMessage: ${message}`);

    core.setOutput('jobs', jobs);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
