---
name: github-first-time-prs
version: 1.0.0
author: 大铭 (https://github.com/yinwm)
description: |
  Get list of OPEN PRs from first-time contributors in a GitHub repository.
  First-time contributor: All their PRs in the repo are OPEN (never merged/closed).
  Categorized into: PRs with discussion, PRs needing attention (0 human comments).

  TRIGGERS:
  - "新人 PR" or "首次贡献者"
  - "看新人 PR" or "新人有哪些 PR"
  - "需要关注的 PR" or "待回复的 PR"
  - "社区贡献" or "新贡献者"

  Use when you want to review PRs from new contributors or check community health.

  CONFIGURATION:
  - "设置新人 PR 检查" or "配置 github-first-time-prs"
  - First run will prompt for:
    - Repository to check (e.g., "owner/repo")

compatibility: Requires `gh` CLI (GitHub CLI)
---

# GitHub 首次贡献者 PR 列表

获取指定仓库中**首次贡献者**的 **OPEN 状态** PR 列表，帮助维护者关注新人、及时回复。

## 功能说明

**首次贡献者定义**：在该仓库的所有 PR 都是 OPEN 状态（从未被合并或关闭）。

自动分类：
- ✅ **已有讨论的 PR** - 有人工评论，显示评论人和时间
- ⚠️ **需要关注的 PR** - 0 人工评论，等待回复

## 配置管理

### 配置文件位置

```
~/.claude/skills/github-first-time-prs/config.json
```

### 配置结构

```json
{
  "repo": "owner/repo",
  "created_at": "2026-03-24T00:00:00Z"
}
```

### 首次配置流程

**检查配置文件是否存在：**
```bash
cat ~/.claude/skills/github-first-time-prs/config.json 2>/dev/null || echo "NOT_FOUND"
```

**如果配置不存在，使用 AskUserQuestion 询问用户：**

1. 询问仓库名称：
   ```
   请输入要检查的 GitHub 仓库（格式：owner/repo）
   例如：sipeed/picoclaw
   ```

2. 创建配置文件：
```bash
mkdir -p ~/.claude/skills/github-first-time-prs
cat > ~/.claude/skills/github-first-time-prs/config.json << EOF
{
  "repo": "$REPO",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
```

### 修改配置流程

当用户说"修改新人 PR 检查配置"或"设置仓库"时：

1. 读取当前配置并显示
2. 使用 AskUserQuestion 询问新仓库
3. 更新 config.json
4. 确认修改成功

## 使用方式

```
看新人 PR
首次贡献者有哪些
需要关注的 PR（0 评论）
```

## 执行步骤

### 1. 获取首次贡献者的 OPEN PR

```bash
# 获取所有 OPEN PR 的作者列表（去重）
gh pr list --repo "$REPO" --state open --json author --jq '.[].author.login' | sort -u

# 对每个作者检查是否是首次贡献者
for author in $authors; do
  open_count=$(gh pr list --repo "$REPO" --author "$author" --state open --json number --jq 'length')
  total_count=$(gh pr list --repo "$REPO" --author "$author" --state all --json number --jq 'length')

  # 首次贡献者：所有 PR 都是 OPEN 状态
  if [ "$open_count" -eq "$total_count" ] && [ "$open_count" -gt 0 ]; then
    # 这是一个首次贡献者
  fi
done
```

### 2. 获取评论详情

```bash
gh pr view <pr-number> --repo "$REPO" --json comments
```

### 3. 过滤人工评论

**重要**：过滤掉机器人评论（用户名包含 `[bot]`），只保留真实人工评论。

### 4. 分类输出

```
## 首次贡献者 OPEN PR 列表（共 X 个）

### ✅ 已有讨论的 PR（N 个）

| PR | 标题 | 作者 | 创建时间 | 评论数 | 首条人工评论 | 评论人 |
|----|------|------|----------|--------|--------------|--------|
| #xxx | ... | ... | YYYY-MM-DD | N | YYYY-MM-DD | username |

---

### ⚠️ 需要关注的 PR（0 人工评论，M 个）

| PR | 标题 | 作者 | 创建时间 |
|----|------|------|----------|
| #xxx | ... | ... | YYYY-MM-DD |

---

**统计**：
- ✅ 已有人工讨论：N 个
- ⚠️ 等待回复：M 个
- 📅 最早未回复 PR：#xxx（YYYY-MM-DD，已等待 X 天）
```

## 依赖

- **gh CLI**: [GitHub CLI](https://cli.github.com/)

## 注意事项

1. **过滤机器人评论**：只统计真实人工评论，排除 `[bot]` 用户
2. **首次贡献者定义**：在该仓库的所有 PR 都是 OPEN 状态
3. **API 限制**：大量 PR 时注意 GitHub API 速率限制
