# Unified Skills Management

这是一个统一管理 AI Agent Skills 的中心仓库，通过软链接分发到各个 Agent。

## 支持的 AI Agents

| Agent                    | Skills 路径                               |
| ------------------------ | ----------------------------------------- |
| **Gemini (Antigravity)** | `~/.gemini/antigravity/skills/<name>/`    |
| **Cursor**               | `~/.cursor/skills/<name>/`                |
| **Claude Code**          | `~/.claude/skills/<name>/`                |
| **GitHub Copilot**       | `~/.copilot/skills/<name>/`               |
| **OpenCode**             | `~/.config/opencode/skill/<name>/`        |
| **Codex**                | `~/.codex/skills/<name>/`                 |
| **Gemini CLI**           | `~/.gemini/skills/<name>/`                |
| **Windsurf**             | `~/.codeium/windsurf/skills/<name>/`      |

## 快速开始

### 1. 初始化软链接

```bash
# 给脚本添加执行权限
chmod +x ~/skills/link-skills.sh
chmod +x ~/skills/unlink-skills.sh

# 运行链接脚本（将 skills 链接到所有 8 个 AI agents）
~/skills/link-skills.sh
```

### 2. 创建新的 Skill

```bash
# 创建 skill 目录
mkdir -p ~/skills/my-new-skill

# 创建 SKILL.md（必需）
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

# 重新运行链接脚本
~/skills/link-skills.sh
```

### 3. 添加复杂的 Skill（带脚本和资源）

```bash
# 创建完整的 skill 结构
mkdir -p ~/skills/advanced-skill/{scripts,examples,resources}

# 创建 SKILL.md
touch ~/skills/advanced-skill/SKILL.md

# 添加辅助脚本
touch ~/skills/advanced-skill/scripts/helper.sh

# 添加示例文件
touch ~/skills/advanced-skill/examples/example.md

# 链接到所有 agents
~/skills/link-skills.sh
```

## 目录结构

```
~/skills/
├── README.md                    # 本文档
├── link-skills.sh              # 自动链接脚本
├── unlink-skills.sh            # 自动解除链接脚本
├── code-review/                # 示例 skill
│   ├── SKILL.md               # 必需：主要说明文件
│   ├── scripts/               # 可选：辅助脚本
│   ├── examples/              # 可选：示例代码
│   └── resources/             # 可选：其他资源
└── deployment/
    └── SKILL.md
```

## SKILL.md 格式规范

每个 skill 必须包含一个 `SKILL.md` 文件，格式如下：

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

## 管理技巧

### 版本控制

```bash
cd ~/skills
git init
git add .
git commit -m "Initial skills setup"

# 推送到远程仓库
git remote add origin <your-repo-url>
git push -u origin main
```

### 更新 Skills

修改任何 skill 后，所有 Agent 会自动看到更新（因为是软链接）：

```bash
# 编辑 skill
vim ~/skills/code-review/SKILL.md

# 无需重新链接，所有 Agent 立即生效
```

### 检查链接状态

```bash
# 查看 Gemini 的 skills
ls -la ~/.gemini/antigravity/skills/

# 查看所有软链接
find ~/.gemini/antigravity/skills/ -type l -ls
```

### 移除 Skill

```bash
# 方法 1: 从中心目录删除
rm -rf ~/skills/unwanted-skill

# 重新运行链接脚本清理死链接
~/skills/link-skills.sh

# 方法 2: 使用 unlink 脚本移除所有软链接
~/skills/unlink-skills.sh
```

## 与 vercel-labs/add-skill 集成

虽然 `add-skill` 不直接支持 Gemini，但你可以这样使用：

```bash
# 使用 add-skill 安装到临时位置
npx add-skill <skill-name> --path /tmp/temp-skill

# 移动到统一管理目录
mv /tmp/temp-skill ~/skills/<skill-name>

# 链接到所有 agents
~/skills/link-skills.sh
```

## 故障排除

### 软链接失效

如果移动了 `~/skills` 目录，需要重新创建链接：

```bash
# 使用 unlink 脚本安全地移除所有旧链接
~/skills/unlink-skills.sh

# 重新链接
~/skills/link-skills.sh
```

### 权限问题

```bash
# 确保 skills 目录可读
chmod -R 755 ~/skills
```

## 贡献

欢迎添加更多有用的 skills！每个 skill 应该：

- 有清晰的 `SKILL.md` 文档
- 遵循统一的格式规范
- 包含实用的示例
- 适用于多个 AI agents

## 参考资源

- [Gemini Skills Documentation](https://antigravity.google/docs/skills)
- [vercel-labs/add-skill](https://github.com/vercel-labs/add-skill)
