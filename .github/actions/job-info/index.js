const core = require('@actions/core');
const github = require('@actions/github');

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

    // Log the github context
    core.info("\nGithub context:");
    core.info(JSON.stringify(github.context, null, 2));

    // Log the jobs array
    core.info("\n\nJobs data:");
    core.info(JSON.stringify(jobs, null, 2));

    core.setOutput('jobs', jobs);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
