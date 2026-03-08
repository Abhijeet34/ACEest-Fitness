import jenkins.model.*
import hudson.model.*
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import hudson.plugins.git.GitSCM
import hudson.plugins.git.UserRemoteConfig
import hudson.plugins.git.BranchSpec

// Get the Jenkins instance
def instance = Jenkins.getInstance()

// Define the job name
def jobName = "ACEest-CI"

// Check if the job already exists
if (instance.getItem(jobName) != null) {
    println "Job '${jobName}' already exists."
    return
}

// Create the workflow job
def job = instance.createProject(WorkflowJob, jobName)

// Define the SCM (Source Control Management) configuration
// We use the mounted volume /var/repo as the git repository
def scm = new GitSCM(
    [new UserRemoteConfig("file:///var/repo", null, null, null)],
    [new BranchSpec("*/main")],
    false,
    Collections.emptyList(),
    null,
    null,
    Collections.emptyList()
)

// Define the pipeline script path (Jenkinsfile)
def flowDefinition = new CpsScmFlowDefinition(scm, "Jenkinsfile")
flowDefinition.setLightweight(true) // Lightweight checkout

// Set the flow definition for the job
job.setDefinition(flowDefinition)

// Save the job configuration
job.save()

println "Job '${jobName}' created successfully."
