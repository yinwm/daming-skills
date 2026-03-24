# PR Review Checker [PR 审查检查器](#中文)

> Intelligent PR review checklist - know which PRs need your attention

---

## 中文

### 功能

智能检查需要你 review 的 GitHub PR，自动过滤出真正需要关注的：

- 🆕 **还没评论** - 你还没看过，需要去 review
- 🔄 **对方有新动作** - 你评论后作者有新 commit 或回复，需要跟进
- 😴 **对方无动静** - 你评论过但作者没反应，可以忽略

### 使用场景

作为 PR reviewer，每天快速了解"今天有哪些 PR 要处理"：

```
你: "有没有 PR 要处理？"
→ 运行 pr-review-checker
→ 输出: 🆕 #1963, 🔄 #1940...
→ 你知道今天要干啥了
```

### 安装

```bash
# 复制 skill 到 Claude Code skills 目录
cp -r pr-review-checker ~/.claude/skills/

# 或从仓库根目录安装
cp -r skills/pr-review-checker ~/.claude/skills/
```

### 配置

首次使用时会提示配置：

1. **要检查的仓库**（如 `sipeed/picoclaw`）
2. **你的 GitHub 用户名**（如 `yinwm`）

或手动创建配置：

```bash
mkdir -p ~/.claude/skills/pr-review-checker
cp config.example.json ~/.claude/skills/pr-review-checker/config.json
# 编辑 config.json，填写 repo 和 my_github_id
```

### 依赖

- **gh CLI**: [GitHub CLI](https://cli.github.com/)
- **jq**: JSON 处理工具（`brew install jq`）

### 使用示例

```
检查 PR 状态
有没有 PR 要处理
PR review 清单
```

### 与 pr-analyze 的区别

| pr-review-checker | pr-analyze |
|-------------------|------------|
| 批量检查多个 PR | 深度分析单个 PR |
| "我有哪些活要干？" | "这个 PR 干什么的？" |
| 输出待办清单 | 输出详细分析报告 |

---

## English

### Features

Intelligent PR review checklist that filters PRs needing your attention:

- 🆕 **Not commented** - You haven't reviewed yet
- 🔄 **New updates** - Author has new commits/replies after your comment
- 😴 **No response** - Author hasn't responded, can ignore

### Use Case

As a PR reviewer, quickly see "what PRs need my attention today":

```
You: "Any PRs to handle?"
→ Run pr-review-checker
→ Output: 🆕 #1963, 🔄 #1940...
→ You know what to do
```

### Installation

```bash
# Copy skill to Claude Code skills directory
cp -r pr-review-checker ~/.claude/skills/

# Or from repository root
cp -r skills/pr-review-checker ~/.claude/skills/
```

### Configuration

You'll be prompted on first use:

1. **Repository to check** (e.g., `sipeed/picoclaw`)
2. **Your GitHub username** (e.g., `yinwm`)

Or manually create config:

```bash
mkdir -p ~/.claude/skills/pr-review-checker
cp config.example.json ~/.claude/skills/pr-review-checker/config.json
# Edit config.json, fill in repo and my_github_id
```

### Dependencies

- **gh CLI**: [GitHub CLI](https://cli.github.com/)
- **jq**: JSON processor (`brew install jq`)

### Usage Examples

```
Check PR status
Any PRs to handle?
PR review checklist
```

### Difference from pr-analyze

| pr-review-checker | pr-analyze |
|-------------------|------------|
| Batch check multiple PRs | Deep dive into single PR |
| "What's on my plate?" | "What's this PR about?" |
| Outputs action list | Outputs detailed analysis |

---

**Author**: 大铭 (https://github.com/yinwm)
**Version**: 1.0.0
