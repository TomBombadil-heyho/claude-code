#!/bin/bash

# Script to safely delete all remote branches except main/master
# Usage: ./delete-non-main-branches.sh [--dry-run] [--yes]

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default options
DRY_RUN=false
AUTO_CONFIRM=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --yes|-y)
            AUTO_CONFIRM=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Show what would be deleted without actually deleting"
            echo "  --yes, -y    Skip confirmation prompt"
            echo "  --help, -h   Show this help message"
            echo ""
            echo "This script deletes all remote branches except main and master."
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

echo -e "${BLUE}=== Branch Cleanup Script ===${NC}"
echo ""

# Get list of remote branches, excluding main, master, and HEAD
BRANCHES_TO_DELETE=$(git branch -r | grep -v "HEAD" | grep -v "/main$" | grep -v "/master$" | awk '{print $1}' | sed 's/origin\///')

# Check if there are any branches to delete
if [ -z "$BRANCHES_TO_DELETE" ]; then
    echo -e "${GREEN}No branches to delete. Only main/master branches exist.${NC}"
    exit 0
fi

# Count branches
BRANCH_COUNT=$(echo "$BRANCHES_TO_DELETE" | wc -l)

echo -e "${YELLOW}Found ${BRANCH_COUNT} branch(es) to delete:${NC}"
echo ""
echo "$BRANCHES_TO_DELETE" | sed 's/^/  - /'
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${BLUE}[DRY RUN] No branches will be deleted${NC}"
    exit 0
fi

# Ask for confirmation unless --yes flag is set
if [ "$AUTO_CONFIRM" = false ]; then
    echo -e "${YELLOW}Are you sure you want to delete these branches? (y/N)${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Aborted. No branches were deleted.${NC}"
        exit 0
    fi
fi

echo ""
echo -e "${BLUE}Deleting branches...${NC}"
echo ""

# Delete each branch
DELETED_COUNT=0
FAILED_COUNT=0

while IFS= read -r branch; do
    if [ -n "$branch" ]; then
        echo -n "Deleting $branch... "
        if git push origin --delete "$branch" > /dev/null 2>&1; then
            echo -e "${GREEN}✓${NC}"
            ((DELETED_COUNT++))
        else
            echo -e "${RED}✗${NC}"
            ((FAILED_COUNT++))
        fi
    fi
done <<< "$BRANCHES_TO_DELETE"

echo ""
echo -e "${GREEN}=== Summary ===${NC}"
echo -e "Successfully deleted: ${GREEN}${DELETED_COUNT}${NC}"
if [ $FAILED_COUNT -gt 0 ]; then
    echo -e "Failed to delete: ${RED}${FAILED_COUNT}${NC}"
fi

if [ $FAILED_COUNT -gt 0 ]; then
    exit 1
fi

echo ""
echo -e "${GREEN}Branch cleanup completed successfully!${NC}"
