# GitHub First Time PRs [首次贡献者 PR 列表](#中文)

> Find and track PRs from first-time contributors in GitHub repositories

---

## 中文

### 功能

获取仓库中**首次贡献者**的 OPEN PR 列表，帮助维护者：

- 关注新人贡献，及时回复
- 发现 0 评论的待处理 PR
- 评估社区活跃度和健康度

**首次贡献者定义**：在该仓库的所有 PR 都是 OPEN 状态（从未被合并或关闭）。

### 分类

- ✅ **已有讨论** - 有人工评论
- ⚠️ **需要关注** - 0 人工评论，等待回复

### 安装

```bash
# 从 GitHub 安装
git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && \
cp -r /tmp/daming-skills/skills/github-first-time-prs ~/.claude/skills/ && \
rm -rf /tmp/daming-skills
```

### 配置

首次使用时输入仓库地址（如 `sipeed/picoclaw`）。

或手动配置：

```bash
mkdir -p ~/.claude/skills/github-first-time-prs
echo '{"repo": "owner/repo"}' > ~/.claude/skills/github-first-time-prs/config.json
```

### 使用

```
看新人 PR
首次贡献者有哪些
需要关注的 PR
```

---

## English

### Features

Get list of OPEN PRs from **first-time contributors** in a GitHub repository.

**First-time contributor**: All their PRs in the repo are OPEN (never merged/closed).

Categories:
- ✅ **Has discussion** - Has human comments
- ⚠️ **Needs attention** - 0 human comments, waiting for reply

### Installation

```bash
# Install from GitHub
git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && \
cp -r /tmp/daming-skills/skills/github-first-time-prs ~/.claude/skills/ && \
rm -rf /tmp/daming-skills
```

### Configuration

You'll be prompted for repository (e.g., `sipeed/picoclaw`) on first use.

Or manually configure:

```bash
mkdir -p ~/.claude/skills/github-first-time-prs
echo '{"repo": "owner/repo"}' > ~/.claude/skills/github-first-time-prs/config.json
```

### Usage

```
Show first-time contributor PRs
New contributors PRs
PRs needing attention
```

---

**Author**: 大铭 (https://github.com/yinwm)
**Version**: 1.0.0
**Dependencies**: `gh` CLI
