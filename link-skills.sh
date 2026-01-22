#!/bin/bash

# Unified Skills Manager
# This script creates symlinks from a central skills directory to various AI agents

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Central skills directory
SKILLS_DIR="$HOME/skills/.skills"

# Agent configurations: "agent_name:target_path"
AGENTS=(
    "gemini:$HOME/.gemini/antigravity/skills"
    "cursor:$HOME/.cursor/skills"
    "claude:$HOME/.claude/skills"
    "copilot:$HOME/.copilot/skills"
    "opencode:$HOME/.config/opencode/skills"
    "codex:$HOME/.codex/skills"
    "gemini-cli:$HOME/.gemini/skills"
    "windsurf:$HOME/.codeium/windsurf/skills"
)

echo -e "${BLUE}=== Unified Skills Linker ===${NC}\n"

# Check if skills directory exists
if [ ! -d "$SKILLS_DIR" ]; then
    echo -e "${YELLOW}Creating central skills directory: $SKILLS_DIR${NC}"
    mkdir -p "$SKILLS_DIR"
fi

# Function to link a skill to an agent
link_skill() {
    local skill_name=$1
    local agent_name=$2
    local target_dir=$3
    
    local source="$SKILLS_DIR/$skill_name"
    local target="$target_dir/$skill_name"
    
    # Skip if source doesn't exist
    if [ ! -d "$source" ]; then
        return
    fi
    
    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"
    
    # Remove existing link/directory if it exists
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        echo -e "${YELLOW}Warning: $target exists as a directory. Skipping.${NC}"
        return
    fi
    
    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓${NC} Linked $skill_name to $agent_name"
}

# Get all skills from central directory
if [ -d "$SKILLS_DIR" ]; then
    skills=($(ls -d "$SKILLS_DIR"/*/ 2>/dev/null | xargs -n 1 basename))
    
    if [ ${#skills[@]} -eq 0 ]; then
        echo -e "${YELLOW}No skills found in $SKILLS_DIR${NC}"
        echo -e "${BLUE}Create your first skill:${NC}"
        echo "  mkdir -p $SKILLS_DIR/my-skill"
        echo "  touch $SKILLS_DIR/my-skill/SKILL.md"
        exit 0
    fi
    
    echo -e "${BLUE}Found ${#skills[@]} skill(s):${NC} ${skills[*]}\n"
    
    # Link each skill to each agent
    for agent_config in "${AGENTS[@]}"; do
        IFS=':' read -r agent_name target_dir <<< "$agent_config"
        
        echo -e "${BLUE}Linking to $agent_name ($target_dir):${NC}"
        
        for skill in "${skills[@]}"; do
            link_skill "$skill" "$agent_name" "$target_dir"
        done
        
        echo ""
    done
    
    echo -e "${GREEN}✓ All skills linked successfully!${NC}"
else
    echo -e "${YELLOW}Skills directory not found: $SKILLS_DIR${NC}"
fi

# Show summary
echo -e "\n${BLUE}=== Summary ===${NC}"
echo -e "Central skills directory: ${GREEN}$SKILLS_DIR${NC}"
echo -e "Total skills: ${GREEN}${#skills[@]}${NC}"
echo -e "Total agents: ${GREEN}${#AGENTS[@]}${NC}"
echo -e "\n${BLUE}To add a new skill:${NC}"
echo "  1. Create directory: mkdir -p $SKILLS_DIR/skill-name"
echo "  2. Add SKILL.md: touch $SKILLS_DIR/skill-name/SKILL.md"
echo "  3. Run this script again: bash $0"
