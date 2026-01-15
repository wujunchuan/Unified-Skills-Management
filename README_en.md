# Unified Skills Management

This is a centralized repository for managing AI Agent Skills, distributed to various agents via symlinks.

## Supported AI Agents

| Agent                    | Skills Path                               |
| ------------------------ | ----------------------------------------- |
| **Gemini (Antigravity)** | `~/.gemini/antigravity/skills/<name>/`    |
| **Cursor**               | `~/.cursor/skills/<name>/`                |
| **Claude Code**          | `~/.claude/skills/<name>/`                |
| **GitHub Copilot**       | `~/.copilot/skills/<name>/`               |
| **OpenCode**             | `~/.config/opencode/skill/<name>/`        |
| **Codex**                | `~/.codex/skills/<name>/`                 |
| **Gemini CLI**           | `~/.gemini/skills/<name>/`                |
| **Windsurf**             | `~/.codeium/windsurf/skills/<name>/`      |

## Quick Start

### 1. Initialize Symlinks

```bash
# Add execute permissions to scripts
chmod +x ~/skills/link-skills.sh
chmod +x ~/skills/unlink-skills.sh

# Run the link script (links skills to all 8 AI agents)
~/skills/link-skills.sh
```

### 2. Create a New Skill

```bash
# Create skill directory
mkdir -p ~/skills/my-new-skill

# Create SKILL.md (required)
cat > ~/skills/my-new-skill/SKILL.md << 'EOF'
---
name: My New Skill
description: A brief description of what this skill does
---

# My New Skill

## Purpose
Describe what this skill helps the AI agent accomplish.

## Instructions
Provide detailed step-by-step instructions for the AI agent.

## Examples
Include usage examples if applicable.
EOF

# Re-run the link script
~/skills/link-skills.sh
```

### 3. Add Advanced Skills (with Scripts and Resources)

```bash
# Create complete skill structure
mkdir -p ~/skills/advanced-skill/{scripts,examples,resources}

# Create SKILL.md
touch ~/skills/advanced-skill/SKILL.md

# Add helper scripts
touch ~/skills/advanced-skill/scripts/helper.sh

# Add example files
touch ~/skills/advanced-skill/examples/example.md

# Link to all agents
~/skills/link-skills.sh
```

## Directory Structure

```
~/skills/
├── README.md                    # This document
├── link-skills.sh              # Auto-link script
├── unlink-skills.sh            # Auto-unlink script
├── code-review/                # Example skill
│   ├── SKILL.md               # Required: Main documentation
│   ├── scripts/               # Optional: Helper scripts
│   ├── examples/              # Optional: Example code
│   └── resources/             # Optional: Other resources
└── deployment/
    └── SKILL.md
```

## SKILL.md Format Specification

Each skill must include a `SKILL.md` file with the following format:

```markdown
---
name: Skill Name
description: Brief description of the skill
---

# Detailed Instructions

Your detailed instructions for the AI agent go here.

## Sections

You can organize with headers, code blocks, lists, etc.
```

## Management Tips

### Version Control

```bash
cd ~/skills
git init
git add .
git commit -m "Initial skills setup"

# Push to remote repository
git remote add origin <your-repo-url>
git push -u origin main
```

### Update Skills

After modifying any skill, all agents will automatically see the updates (because they're symlinks):

```bash
# Edit skill
vim ~/skills/code-review/SKILL.md

# No need to re-link, changes take effect immediately for all agents
```

### Check Link Status

```bash
# View Gemini's skills
ls -la ~/.gemini/antigravity/skills/

# View all symlinks
find ~/.gemini/antigravity/skills/ -type l -ls
```

### Remove Skills

```bash
# Method 1: Delete from central directory
rm -rf ~/skills/unwanted-skill

# Re-run link script to clean up dead links
~/skills/link-skills.sh

# Method 2: Use unlink script to remove all symlinks
~/skills/unlink-skills.sh
```

## Integration with vercel-labs/add-skill

While `add-skill` doesn't directly support Gemini, you can use it like this:

```bash
# Use add-skill to install to temporary location
npx add-skill <skill-name> --path /tmp/temp-skill

# Move to unified management directory
mv /tmp/temp-skill ~/skills/<skill-name>

# Link to all agents
~/skills/link-skills.sh
```

## Troubleshooting

### Broken Symlinks

If you've moved the `~/skills` directory, you need to recreate the links:

```bash
# Use unlink script to safely remove all old links
~/skills/unlink-skills.sh

# Re-link
~/skills/link-skills.sh
```

### Permission Issues

```bash
# Ensure skills directory is readable
chmod -R 755 ~/skills
```

## Contributing

Welcome to add more useful skills! Each skill should:

- Have clear `SKILL.md` documentation
- Follow unified format specifications
- Include practical examples
- Be applicable to multiple AI agents

## References

- [Gemini Skills Documentation](https://antigravity.google/docs/skills)
- [vercel-labs/add-skill](https://github.com/vercel-labs/add-skill)
