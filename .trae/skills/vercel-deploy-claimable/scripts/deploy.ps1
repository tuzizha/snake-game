# Vercel Deployment Script (PowerShell version)
# Usage: .\deploy.ps1 [project-path]

$ErrorActionPreference = "Stop"

$DEPLOY_ENDPOINT = "https://claude-skills-deploy.vercel.com/api/deploy"

# Parse arguments
$INPUT_PATH = if ($args.Count -gt 0) { $args[0] } else { "." }

# Create temp directory for packaging
$TEMP_DIR = Join-Path $env:TEMP "vercel-deploy-$(Get-Random)"
New-Item -ItemType Directory -Path $TEMP_DIR -Force | Out-Null
$TARBALL = Join-Path $TEMP_DIR "project.tgz"

try {
    Write-Host "Preparing deployment..." -ForegroundColor Yellow

    # Check if input is a .tgz file or a directory
    if (Test-Path $INPUT_PATH -PathType Leaf) {
        if ($INPUT_PATH -match "\.tgz$") {
            # Input is already a tarball, use it directly
            Write-Host "Using provided tarball..." -ForegroundColor Yellow
            $TARBALL = $INPUT_PATH
        } else {
            throw "Error: Input must be a directory or a .tgz file"
        }
    } elseif (Test-Path $INPUT_PATH -PathType Container) {
        # Input is a directory, need to tar it
        $PROJECT_PATH = (Resolve-Path $INPUT_PATH).Path

        # Detect framework from package.json
        $FRAMEWORK = "null"
        $pkgJsonPath = Join-Path $PROJECT_PATH "package.json"
        if (Test-Path $pkgJsonPath) {
            $content = Get-Content $pkgJsonPath -Raw
            if ($content -match "`"next`"") { $FRAMEWORK = "nextjs" }
            elseif ($content -match "`"react-scripts`"") { $FRAMEWORK = "create-react-app" }
            elseif ($content -match "`"gatsby`"") { $FRAMEWORK = "gatsby" }
            elseif ($content -match "`"vite`"") { $FRAMEWORK = "vite" }
            elseif ($content -match "`"nuxt`"") { $FRAMEWORK = "nuxtjs" }
        }

        # Check if this is a static HTML project (no package.json)
        if (-not (Test-Path $pkgJsonPath)) {
            # Find HTML files in root
            $htmlFiles = Get-ChildItem -Path $PROJECT_PATH -Filter "*.html" -File
            if ($htmlFiles.Count -eq 1) {
                $htmlFile = $htmlFiles[0]
                if ($htmlFile.Name -ne "index.html") {
                    Write-Host "Renaming $($htmlFile.Name) to index.html..." -ForegroundColor Yellow
                    Rename-Item -Path $htmlFile.FullName -NewName "index.html"
                }
            }
        }

        # Create tarball of the project
        Write-Host "Creating deployment package..." -ForegroundColor Yellow
        tar -czf $TARBALL -C $PROJECT_PATH --exclude='node_modules' --exclude='.git' .
    } else {
        throw "Error: Input must be a directory or a .tgz file"
    }

    if ($FRAMEWORK -ne "null") {
        Write-Host "Detected framework: $FRAMEWORK" -ForegroundColor Green
    }

    # Deploy using curl
    Write-Host "Deploying..." -ForegroundColor Yellow
    
    $curlArgs = @(
        "-s",
        "-X", "POST",
        $DEPLOY_ENDPOINT,
        "-F", "file=@$TARBALL",
        "-F", "framework=$FRAMEWORK"
    )
    
    $responseJson = & curl.exe @curlArgs 2>&1
    $response = $responseJson | ConvertFrom-Json

    # Check for error in response
    if ($response.error) {
        throw "Error: $($response.error)"
    }

    # Extract URLs from response
    $PREVIEW_URL = $response.previewUrl
    $CLAIM_URL = $response.claimUrl

    if (-not $PREVIEW_URL) {
        throw "Error: Could not extract preview URL from response"
    }

    Write-Host ""
    Write-Host "Deployment successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Preview URL: $PREVIEW_URL" -ForegroundColor Cyan
    Write-Host "Claim URL:   $CLAIM_URL" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "View your site at the Preview URL." -ForegroundColor White
    Write-Host "To transfer this deployment to your Vercel account, visit the Claim URL." -ForegroundColor White

} finally {
    # Cleanup temp directory
    if (Test-Path $TEMP_DIR) {
        Remove-Item -Path $TEMP_DIR -Recurse -Force
    }
}
