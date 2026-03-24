# PR Analyze [PR 分析器](#中文)

> Comprehensive PR analysis workflow for GitHub repositories

---

## 中文

### 功能

对 GitHub PR 进行全面分析，生成结构化中文报告：

- PR 功能说明
- 兼容性影响分析（前端、API、依赖、数据库、配置）
- 重复 PR 检查
- 关联 Issue 与 PR 分析
- CI 状态检查
- 自动代码审查（调用 `/review` skill）

### 安装

```bash
# 复制 skill 到 Claude Code skills 目录
cp -r pr-analyze ~/.claude/skills/

# 或从仓库根目录安装
cp -r skills/pr-analyze ~/.claude/skills/
```

### 配置

首次使用时会提示配置报告存储目录，或手动创建配置文件：

```bash
# 创建配置目录
mkdir -p ~/.claude/skills/pr-analyze

# 复制示例配置
cp config.example.json ~/.claude/skills/pr-analyze/config.json

# 编辑配置，修改 report_dir 为你想要的路径
```

### 依赖

- **gh CLI**: [GitHub CLI](https://cli.github.com/)
- **/review skill**: 用于代码审查

### 使用示例

```
分析 PR #1900
分析这个 PR: https://github.com/owner/repo/pull/1900
查看 PR 兼容性影响
```

### 报告示例

报告会保存到配置的目录，命名格式：

```
{report_dir}/{repo_slug}/pr-{number}-{YYYYMMDD}-{HHMMSS}.md
```

例如：

```
~/pr-reports/sipeed-picoclaw/pr-1900-20260323-071500.md
```

---

## English

### Features

Comprehensive GitHub PR analysis with structured Chinese reports:

- PR purpose summary
- Compatibility impact analysis (frontend, API, dependencies, database, config)
- Duplicate PR detection
- Related issues and PRs analysis
- CI status checks
- Automated code review (via `/review` skill)

### Installation

```bash
# Copy skill to Claude Code skills directory
cp -r pr-analyze ~/.claude/skills/

# Or from repository root
cp -r skills/pr-analyze ~/.claude/skills/
```

### Configuration

You'll be prompted on first use, or manually create config:

```bash
# Create config directory
mkdir -p ~/.claude/skills/pr-analyze

# Copy example config
cp config.example.json ~/.claude/skills/pr-analyze/config.json

# Edit config, set report_dir to your preferred path
```

### Dependencies

- **gh CLI**: [GitHub CLI](https://cli.github.com/)
- **/review skill**: For code review

### Usage Examples

```
Analyze PR #1900
Analyze this PR: https://github.com/owner/repo/pull/1900
Check PR compatibility impact
```

### Report Example

Reports are saved to configured directory with naming:

```
{report_dir}/{repo_slug}/pr-{number}-{YYYYMMDD}-{HHMMSS}.md
```

Example:

```
~/pr-reports/sipeed-picoclaw/pr-1900-20260323-071500.md
```

---

**Author**: 大铭 (https://github.com/yinwm)
**Version**: 0.2.0
