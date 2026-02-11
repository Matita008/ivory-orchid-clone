#Script to install Python, create a virtual environment and install dependencies
#Any argument passed will be passed to the venv command

Param(
    [Parameter(Mandatory = $false)]
    [String]
    $args
)

Get-Command python *>$null
if (-Not($?)) {
    echo "Installing python"
    winget install --id=Python.Python.3.13 --source=winget
}

python -m pip -h *>$null
if (-Not($?)) {
    #I hate ps, see https://github.com/PowerShell/PowerShell/issues/25072#:~:text=PowerShell%20breaks%20universal%20scripting%20expectations%20for%20no%20good%20reason.
    Write-Error "Pip not found"
    Write-Error "Please install pip manually or reinstall python"
    echo "The installation has failed"
    exit 1
}

python -m venv -h *>$null
if (-Not($?)) {
    Write-Error "venv not found"
    Write-Error "Please install venv manually or reinstall python"
    echo "The installation has failed"
    exit 1
}

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location "$dir\..\backend"

if(-Not(Test-Path -path .venv)) {
    python -m venv .venv $args
}
.\.venv\Scripts\activate.ps1

#install requirements
pip install -r requirements.txt *>$null

Set-Location ..
deactivate

echo "Installation completed"
