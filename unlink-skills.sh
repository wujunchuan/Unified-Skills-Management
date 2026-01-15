#!/bin/bash

# Unified Skills Unlinker
# This script removes symlinks created by link-skills.sh from various AI agents

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Central skills directory
SKILLS_DIR="$HOME/skills"

# Agent configurations: "agent_name:target_path"
# Must match the AGENTS array in link-skills.sh
AGENTS=(
    "gemini:$HOME/.gemini/antigravity/skills"
    "cursor:$HOME/.cursor/skills"
    "claude:$HOME/.claude/skills"
    "copilot:$HOME/.copilot/skills"
    "opencode:$HOME/.config/opencode/skill"
    "codex:$HOME/.codex/skills"
    "gemini-cli:$HOME/.gemini/skills"
    "windsurf:$HOME/.codeium/windsurf/skills"
)

echo -e "${BLUE}=== Unified Skills Unlinker ===${NC}\n"

# Check if skills directory exists
if [ ! -d "$SKILLS_DIR" ]; then
    echo -e "${YELLOW}Central skills directory not found: $SKILLS_DIR${NC}"
    echo -e "${YELLOW}Nothing to unlink.${NC}"
    exit 0
fi

# Function to unlink a skill from an agent
unlink_skill() {
    local skill_name=$1
    local agent_name=$2
    local target_dir=$3
    
    local target="$target_dir/$skill_name"
    
    # Check if target exists and is a symlink
    if [ -L "$target" ]; then
        # Verify it points to our central skills directory
        local link_target=$(readlink "$target")
        if [[ "$link_target" == "$SKILLS_DIR/$skill_name" ]]; then
            rm "$target"
            echo -e "${GREEN}✓${NC} Unlinked $skill_name from $agent_name"
            return 0
        else
            echo -e "${YELLOW}⚠${NC} $target is a symlink but doesn't point to $SKILLS_DIR/$skill_name (points to: $link_target)"
            return 1
        fi
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}⚠${NC} $target exists but is not a symlink. Skipping."
        return 1
    fi
    
    return 0
}

# Get all skills from central directory
skills=($(ls -d "$SKILLS_DIR"/*/ 2>/dev/null | xargs -n 1 basename))

if [ ${#skills[@]} -eq 0 ]; then
    echo -e "${YELLOW}No skills found in $SKILLS_DIR${NC}"
    exit 0
fi

echo -e "${BLUE}Found ${#skills[@]} skill(s):${NC} ${skills[*]}\n"

# Track statistics
total_unlinked=0
total_skipped=0
total_not_found=0

# Unlink each skill from each agent
for agent_config in "${AGENTS[@]}"; do
    IFS=':' read -r agent_name target_dir <<< "$agent_config"
    
    echo -e "${BLUE}Unlinking from $agent_name ($target_dir):${NC}"
    
    if [ ! -d "$target_dir" ]; then
        echo -e "${YELLOW}  Target directory doesn't exist. Nothing to unlink.${NC}"
        echo ""
        continue
    fi
    
    for skill in "${skills[@]}"; do
        if unlink_skill "$skill" "$agent_name" "$target_dir"; then
            ((total_unlinked++))
        else
            ((total_skipped++))
        fi
    done
    
    # Remove target directory if it's empty
    if [ -d "$target_dir" ] && [ -z "$(ls -A "$target_dir")" ]; then
        rmdir "$target_dir"
        echo -e "${GREEN}✓${NC} Removed empty directory: $target_dir"
    fi
    
    echo ""
done

echo -e "${GREEN}✓ Unlinking complete!${NC}"

# Show summary
echo -e "\n${BLUE}=== Summary ===${NC}"
echo -e "Central skills directory: ${GREEN}$SKILLS_DIR${NC}"
echo -e "Total skills: ${GREEN}${#skills[@]}${NC}"
echo -e "Total agents: ${GREEN}${#AGENTS[@]}${NC}"
echo -e "Symlinks removed: ${GREEN}$total_unlinked${NC}"
echo -e "Skipped (not symlinks or wrong target): ${YELLOW}$total_skipped${NC}"

echo -e "\n${BLUE}Note:${NC}"
echo -e "  • Only symlinks pointing to $SKILLS_DIR were removed"
echo -e "  • Regular directories and files were left untouched"
echo -e "  • The central skills directory ($SKILLS_DIR) was not modified"
echo -e "\n${BLUE}To re-link skills:${NC}"
echo -e "  bash $(dirname "$0")/link-skills.sh"
