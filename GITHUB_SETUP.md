# Publishing to GitHub and Enabling CI

This guide explains how to push the Taiga DevLake plugin to GitHub and enable GitHub Actions for continuous integration.

## Prerequisites

- Git installed locally
- GitHub account
- GitHub CLI (optional but recommended): `brew install gh`

## Step 1: Initialize Git Repository

```bash
cd /Users/irfan.ahmad/arbisoft-src/taiga-devlake-plugin

# Initialize git (if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Taiga DevLake Plugin v1.0.0

- Complete plugin implementation with 22 source files
- Pre-built binary (bin/taiga.so)
- Comprehensive documentation
- GitHub Actions CI workflow
- Makefile for build automation
- API reference and installation guides"
```

## Step 2: Create GitHub Repository

### Option A: Using GitHub CLI (Recommended)

```bash
# Login to GitHub (if not already logged in)
gh auth login

# Create repository
gh repo create taiga-devlake-plugin \
  --public \
  --description "Apache DevLake plugin for Taiga project management integration" \
  --source=. \
  --remote=origin

# Push code
git push -u origin main
```

### Option B: Using GitHub Web Interface

1. Go to https://github.com/new
2. Repository name: `taiga-devlake-plugin`
3. Description: "Apache DevLake plugin for Taiga project management integration"
4. Visibility: Public
5. **Do NOT** initialize with README, .gitignore, or license (we have these)
6. Click "Create repository"

Then connect and push:

```bash
# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/taiga-devlake-plugin.git

# Push code
git branch -M main
git push -u origin main
```

## Step 3: Verify GitHub Actions

After pushing, GitHub Actions will automatically start:

1. Go to your repository on GitHub
2. Click the "Actions" tab
3. You should see a workflow run for your initial commit

### Expected Behavior

The CI workflow (`.github/workflows/ci.yml`) will:
- ✅ Checkout code
- ✅ Set up Go 1.21
- ✅ Download dependencies
- ⚠️ Build may fail (this is expected)

**Why the build might fail**: The plugin requires DevLake monorepo context to compile. This doesn't affect the usability of the pre-built binary.

### Viewing Workflow Results

```bash
# Using GitHub CLI
gh run list
gh run view <run-id>

# Or visit:
# https://github.com/YOUR_USERNAME/taiga-devlake-plugin/actions
```

## Step 4: Configure Repository Settings

### Enable Issues and Discussions

```bash
# Using GitHub CLI
gh repo edit --enable-issues --enable-discussions

# Or via web:
# Settings → General → Features → Check "Issues" and "Discussions"
```

### Add Topics

Add relevant topics to help people discover your plugin:

```bash
# Using GitHub CLI
gh repo edit --add-topic apache-devlake \
  --add-topic taiga \
  --add-topic plugin \
  --add-topic golang \
  --add-topic devops \
  --add-topic project-management

# Or via web:
# Main repository page → Click gear icon next to "About"
```

### Configure Branch Protection (Optional)

For collaborative development:

1. Go to Settings → Branches
2. Add branch protection rule for `main`:
   - Require pull request reviews
   - Require status checks to pass
   - Require branches to be up to date

## Step 5: Create First Release

### Tag the Release

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release v1.0.0 - Initial public release

Features:
- Complete Taiga API integration
- Project and user story collection
- DevLake domain layer transformation
- REST API for connection management
- Pre-built binary included

Tested with:
- DevLake v0.21.0+
- Go 1.21+
- Taiga API v6"

# Push the tag
git push origin v1.0.0
```

### Create GitHub Release

```bash
# Using GitHub CLI
gh release create v1.0.0 \
  --title "Taiga DevLake Plugin v1.0.0" \
  --notes-file CHANGELOG.md \
  bin/taiga.so

# Or manually via web:
# Go to Releases → Draft a new release → Choose tag v1.0.0
```

The release workflow (`.github/workflows/release.yml`) will automatically run when you create a tag.

## Step 6: Add README Badges

Update README.md with status badges:

```markdown
# Taiga DevLake Plugin

![Build Status](https://github.com/YOUR_USERNAME/taiga-devlake-plugin/workflows/CI/badge.svg)
![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)
![Go Version](https://img.shields.io/badge/go-1.21+-00ADD8.svg)
![DevLake](https://img.shields.io/badge/devlake-v0.21.0+-orange.svg)

...rest of README...
```

Commit and push:

```bash
git add README.md
git commit -m "Add status badges to README"
git push
```

## Step 7: Promote Your Plugin

### Apache DevLake Community

1. **Announce on DevLake Slack**: Share in #plugins or #general channel
2. **DevLake GitHub Discussions**: Post in https://github.com/apache/incubator-devlake/discussions
3. **Submit Plugin to DevLake Docs**: Create PR to add your plugin to the official plugin list

### Social Media

Share on:
- LinkedIn (tag Apache DevLake)
- Twitter/X with hashtag #ApacheDevLake #Taiga
- Dev.to or Hashnode blog post

### Sample Announcement

```
🎉 Announcing Taiga DevLake Plugin v1.0.0!

Integrate your Taiga project management data with Apache DevLake for unified DevOps analytics.

Features:
✅ Full Taiga API integration
✅ Automatic data collection
✅ DevLake domain layer transformation  
✅ REST API for easy configuration
✅ Pre-built binary included

Get it now: https://github.com/YOUR_USERNAME/taiga-devlake-plugin

#ApacheDevLake #Taiga #DevOps #OpenSource
```

## Monitoring and Maintenance

### Watch for Issues

```bash
# Get notifications for new issues
gh repo set-default
gh issue list --state open

# Or enable notifications on GitHub
```

### Regular Updates

1. **Monitor DevLake releases**: Update when new DevLake versions come out
2. **Check Taiga API changes**: Ensure compatibility with Taiga updates
3. **Review and merge PRs**: Engage with community contributions
4. **Update documentation**: Keep guides current

### Responding to Issues

Template response:

```markdown
Thank you for reporting this issue!

Since this plugin requires DevLake's internal packages, testing requires:
1. A full DevLake development environment
2. The plugin binary installed (`bin/taiga.so`)
3. A running Taiga instance to connect to

Could you provide:
- DevLake version
- Error logs from DevLake server
- Taiga API version

I'll investigate and provide a fix.
```

## Troubleshooting

### GitHub Actions Not Running

**Check**: Actions must be enabled in repository settings
```bash
gh repo edit --enable-actions
```

### Build Failures in CI

**Expected**: The build requires DevLake monorepo context
**Solution**: Document this in README and PLUGIN_STATUS.md (already done)

### Unable to Push

**Check**: Remote URL is correct
```bash
git remote -v
git remote set-url origin https://github.com/YOUR_USERNAME/taiga-devlake-plugin.git
```

### Release Workflow Not Triggering

**Check**: Tag format must match (v*.*.*)
```bash
# Correct format
git tag v1.0.0

# Incorrect formats
git tag 1.0.0  # Missing 'v'
git tag version-1.0.0  # Wrong prefix
```

## Next Steps

After publishing:

1. ✅ Verify GitHub Actions ran
2. ✅ Create v1.0.0 release
3. ✅ Add README badges
4. ✅ Enable issues and discussions
5. ✅ Announce to DevLake community
6. ✅ Write blog post or documentation
7. ✅ Monitor for issues and PRs

## Summary

Your repository is now:
- ✅ Under version control (Git)
- ✅ Published on GitHub
- ✅ CI/CD enabled (GitHub Actions)
- ✅ Ready for community contributions
- ✅ Discoverable by the DevLake community

The plugin is ready to help the DevLake community integrate Taiga data!

---

**Questions?** Open an issue or discussion on GitHub.
