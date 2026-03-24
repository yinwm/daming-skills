# Daming Skills [大铭的技能集](https://github.com/yinwm/daming-skills)

> 高质量 Claude Code skills，提升开发效率

**安装 pr-analyze**: 运行 `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/pr-analyze ~/.claude/skills/ && rm -rf /tmp/daming-skills`

**安装 pr-review-checker**: 运行 `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/pr-review-checker ~/.claude/skills/ && rm -rf /tmp/daming-skills`

**安装 github-first-time-prs**: 运行 `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/github-first-time-prs ~/.claude/skills/ && rm -rf /tmp/daming-skills`

**安装 github-valuable-prs**: 运行 `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/github-valuable-prs ~/.claude/skills/ && rm -rf /tmp/daming-skills`

**Install pr-analyze**: Run `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/pr-analyze ~/.claude/skills/ && rm -rf /tmp/daming-skills`

**Install pr-review-checker**: Run `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/pr-review-checker ~/.claude/skills/ && rm -rf /tmp/daming-skills`

**Install github-first-time-prs**: Run `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/github-first-time-prs ~/.claude/skills/ && rm -rf /tmp/daming-skills`

**Install github-valuable-prs**: Run `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/github-valuable-prs ~/.claude/skills/ && rm -rf /tmp/daming-skills`

---

[English](#english) | [中文](#中文)

---

## 中文

### 简介

这是大铭（@yinwm）的个人 Claude Code skills 集合，每个 skill 都经过实际使用验证，专注于解决实际问题。

### 可用 Skills

| Skill | 描述 | 状态 | Claude Code / Openclaw 安装 |
|-------|------|------|---------------------------|
| [pr-analyze](./skills/pr-analyze/) | 全面分析 GitHub PR，包括兼容性影响、重复检查、关联 Issue 分析等 | ✅ | `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/pr-analyze ~/.claude/skills/ && rm -rf /tmp/daming-skills` |
| [pr-review-checker](./skills/pr-review-checker/) | 智能检查需要你 review 的 PR，过滤出真正需要关注的项目 | ✅ | `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/pr-review-checker ~/.claude/skills/ && rm -rf /tmp/daming-skills` |
| [github-first-time-prs](./skills/github-first-time-prs/) | 获取首次贡献者的 OPEN PR 列表，关注新人贡献 | ✅ | `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/github-first-time-prs ~/.claude/skills/ && rm -rf /tmp/daming-skills` |
| [github-valuable-prs](./skills/github-valuable-prs/) | 筛选高价值 PR 和 Issue，快速定位优先处理内容 | ✅ | `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/github-valuable-prs ~/.claude/skills/ && rm -rf /tmp/daming-skills` |
| *(更多 skills 敬请期待...)* | | | |

### 快速开始

#### 安装单个 Skill

```bash
# 复制 skill 到你的 Claude Code skills 目录
cp -r skills/pr-analyze ~/.claude/skills/
cp -r skills/pr-review-checker ~/.claude/skills/
cp -r skills/github-first-time-prs ~/.claude/skills/
cp -r skills/github-valuable-prs ~/.claude/skills/

# 如需配置（首次使用时会自动提示配置）
```

#### 安装所有 Skills

```bash
# 克隆仓库
git clone https://github.com/yinwm/daming-skills.git
cd daming-skills

# 复制所有 skills
cp -r skills/* ~/.claude/skills/
```

### 配置

某些 skills 可能需要配置：

- **pr-analyze**: 需要设置报告存储目录
- **pr-review-checker**: 需要设置仓库和 GitHub 用户名
- **github-first-time-prs**: 需要设置检查的仓库
- **github-valuable-prs**: 需要设置仓库和默认时间范围

详见各 skill 目录下的文档。

### 依赖

- **pr-analyze**: 依赖 `gh` CLI（GitHub CLI）和 `/review` skill
- **pr-review-checker**: 依赖 `gh` CLI 和 `jq`
- **github-first-time-prs**: 依赖 `gh` CLI
- **github-valuable-prs**: 依赖 `gh` CLI
- 其他 skills 可能有自己的依赖，请查看具体文档

### 贡献

欢迎提 Issue 和 PR！

### 许可证

MIT License - 详见 [LICENSE](./LICENSE)

---

## English

### Introduction

A collection of high-quality Claude Code skills by Daming (@yinwm). Each skill is battle-tested and focused on solving real-world problems.

### Available Skills

| Skill | Description | Status | Claude Code / Openclaw Install |
|-------|-------------|--------|------------------------------|
| [pr-analyze](./skills/pr-analyze/) | Comprehensive GitHub PR analysis including compatibility impact, duplicate checks, and related issue analysis | ✅ | `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/pr-analyze ~/.claude/skills/ && rm -rf /tmp/daming-skills` |
| [pr-review-checker](./skills/pr-review-checker/) | Intelligent PR review checklist that filters PRs needing your attention | ✅ | `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/pr-review-checker ~/.claude/skills/ && rm -rf /tmp/daming-skills` |
| [github-first-time-prs](./skills/github-first-time-prs/) | Get list of OPEN PRs from first-time contributors, help new contributors | ✅ | `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/github-first-time-prs ~/.claude/skills/ && rm -rf /tmp/daming-skills` |
| [github-valuable-prs](./skills/github-valuable-prs/) | Filter high-value PRs and Issues, quickly find priority items | ✅ | `git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && cp -r /tmp/daming-skills/skills/github-valuable-prs ~/.claude/skills/ && rm -rf /tmp/daming-skills` |
| *(More coming soon...)* | | | |

### Quick Start

#### Install a Single Skill

```bash
# Copy skill to your Claude Code skills directory
cp -r skills/pr-analyze ~/.claude/skills/
cp -r skills/pr-review-checker ~/.claude/skills/
cp -r skills/github-first-time-prs ~/.claude/skills/
cp -r skills/github-valuable-prs ~/.claude/skills/

# Configuration if needed (you'll be prompted on first use)
```

#### Install All Skills

```bash
# Clone repository
git clone https://github.com/yinwm/daming-skills.git
cd daming-skills

# Copy all skills
cp -r skills/* ~/.claude/skills/
```

### Configuration

Some skills require configuration:

- **pr-analyze**: Requires setting report storage directory
- **pr-review-checker**: Requires setting repository and GitHub username
- **github-first-time-prs**: Requires setting repository to check
- **github-valuable-prs**: Requires setting repository and default time range

See individual skill documentation for details.

### Dependencies

- **pr-analyze**: Requires `gh` CLI (GitHub CLI) and `/review` skill
- **pr-review-checker**: Requires `gh` CLI and `jq`
- **github-first-time-prs**: Requires `gh` CLI
- **github-valuable-prs**: Requires `gh` CLI
- Other skills may have their own dependencies

### Contributing

Issues and PRs are welcome!

### License

MIT License - see [LICENSE](./LICENSE)
