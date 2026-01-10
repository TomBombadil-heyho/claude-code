# Scripts

This directory contains utility scripts for managing the Claude Code repository.

## Available Scripts

### delete-non-main-branches.sh

A bash script to safely delete all remote branches except `main` and `master`.

**Usage:**
```bash
./scripts/delete-non-main-branches.sh [OPTIONS]
```

**Options:**
- `--dry-run` - Show what would be deleted without actually deleting any branches
- `--yes`, `-y` - Skip the confirmation prompt and delete immediately
- `--help`, `-h` - Show help message

**Examples:**

Preview what branches would be deleted:
```bash
bash scripts/delete-non-main-branches.sh --dry-run
```

Delete all non-main branches with confirmation:
```bash
bash scripts/delete-non-main-branches.sh
```

Delete all non-main branches without confirmation:
```bash
bash scripts/delete-non-main-branches.sh --yes
```

**Features:**
- Protected branches: Automatically preserves `main` and `master` branches
- Safe by default: Requires confirmation before deleting (unless `--yes` flag is used)
- Dry-run mode: Preview deletions before making changes
- Color-coded output: Easy to read success/failure messages
- Error handling: Reports which branches failed to delete

**Important Notes:**
- This script deletes branches from the remote repository named `origin`
- If your remote has a different name, you'll need to modify the script or rename your remote
- Make sure you have the necessary permissions to delete remote branches
- Consider setting up branch protection rules on GitHub to prevent accidental deletions of important branches

### auto-close-duplicates.ts

A TypeScript script for automatically closing duplicate issues.

### backfill-duplicate-comments.ts

A TypeScript script for backfilling comments on duplicate issues.

### comment-on-duplicates.sh

A shell script for commenting on duplicate issues.
