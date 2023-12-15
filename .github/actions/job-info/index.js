const core = require('@actions/core');
const github = require('@actions/github');

async function run() {
  try {
    const token = core.getInput('github_token');
    const repository = core.getInput('repository') || github.context.repo.repo;
    const owner = github.context.repo.owner;
    const runId = core.getInput('run_id') || github.context.runId;
    const jobName = core.getInput('job_name');
    const perPage = core.getInput('per_page') || 30;

    const octokit = github.getOctokit(token);

    const response = await octokit.rest.actions.listJobsForWorkflowRun({
      owner,
      repo: repository,
      run_id: runId,
      per_page: parseInt(perPage)
    });

    // Log the jobs array
    core.info("Jobs data:");
    core.info(JSON.stringify(response.data.jobs, null, 2));

    const jobs = response.data.jobs;
    core.setOutput('jobs', jobs);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
