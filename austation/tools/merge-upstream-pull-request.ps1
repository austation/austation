$baseBranchName = "upstream-merge-"
$basePullUrl = "https://api.github.com/repos/BeeStation/BeeStation-Hornet/pulls"
$baseRepoUrl = "https://github.com/BeeStation/BeeStation-Hornet.git"

if($args.Count -ne 2 -Or $args.Count -ne 3) {
    Write-Host "Error: incorrent number of arguments have been given, the first argument needs to be a pull request ID, the second argument needs to be the commit message for the mirror commit. Optionally accepts a third arg of the working directory to set."
    exit 2
}

if($args.Count -eq 3) {
    Set-Location $($args[2])
}

if(!(Test-Path -Path ".\.git")) {
    Write-Host "Error: this script must be run from the root of a git repository"
    exit 1
}

try
{
    jq --help | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException]
{
    Write-Host "Error: This script requires jq, please ensure jq is installed and exists in the current PATH"
    exit 3
}

if(!(git remote | Select-String "upstream")) {
    git remote add upstream $baseRepoUrl
}

git fetch --all
git checkout master
git reset --hard origin/master
git clean -f

git for-each-ref --format='%(refname:short)' refs/heads/ | Select-String -NotMatch "master" | %{git branch -D $_}

git checkout -b $baseBranchName$($args[0])

$mergeSha = (Invoke-WebRequest -UseBasicParsing "$basePullUrl/$($args[0])").Content | jq '.merge_commit_sha' -r

$commits = (Invoke-WebRequest -UseBasicParsing "$basePullUrl/$($args[0])/commits").Content | jq '.[].sha' -r

Write-Host "Cherry picking onto branch..."
$cherryPickOutput = git -c core.editor=true cherry-pick -m 1 "$mergeSha" 2>&1
Write-Host $cherryPickOutput

if($cherryPickOutput | Select-String "error: mainline was specified but commit") {
    Write-Host "Commit was a squash, retrying..."
    if($commits.Contains($mergeSha)) {
        Write-Host "Cherry-picking: $mergeSha"
        git -c core.editor=true cherry-pick "$mergeSha"
        git add -A .
        git -c core.editor=true cherry-pick --continue
    } else {
        foreach($commit in $commits) {
            echo "Cherry-picking: $commit"
            git -c core.editor=true cherry-pick "$commit"
            git add -A .
            git -c core.editor=true cherry-pick --continue
        }
    }
} else {
    Write-Host "Adding files to branch:"
    git add -A .
}

Write-Host "Committing changes"
git -c core.editor=true commit --allow-empty -m "$($args[1])"

Write-Host "Pushing changes"
git push -f -u origin "$baseBranchName$($args[0])"