---
name: pr-review-checker
version: 1.0.0
author: 大铭 (https://github.com/yinwm)
description: |
  Intelligent PR review checklist for GitHub repositories. Checks which PRs need your review attention.
  Smart filtering: PRs you haven't commented yet need attention; PRs you commented with new updates need follow-up; PRs with no response can be ignored.

  TRIGGERS:
  - "有没有 PR 要处理" or "检查 PR"
  - "PR 状态" or "PR review"
  - "需要我 review 的 PR"
  - "PR review 清单" or "PR 待办"

  Use this skill when you want to know which PRs need your review attention.

  CONFIGURATION:
  - "设置 PR review 检查" or "配置 pr-review-checker"
  - First run will prompt for:
    - Repository to check (e.g., "owner/repo")
    - Your GitHub username

compatibility: Requires `gh` CLI (GitHub CLI) and `jq`
---

# PR Review Checker

智能检查需要你 review 的 GitHub PR，过滤出真正需要关注的 PR。

## 功能说明

自动检查指定仓库的 PR，按优先级分类：

| 分类 | 含义 | 优先级 |
|------|------|--------|
| 🆕 还没评论 | 你还没看过这个 PR | **高** - 需要去 review |
| 🔄 对方有新动作 | 你评论后，作者有新的 commit 或回复 | **中** - 需要跟进 |
| 😴 对方无动静 | 你评论后，作者没有新动作 | 低 - 可以忽略 |

## 配置管理

### 配置文件位置

```
~/.claude/skills/pr-review-checker/config.json
```

### 配置结构

```json
{
  "repo": "owner/repo",
  "my_github_id": "your-username",
  "created_at": "2026-03-24T00:00:00Z"
}
```

### 首次配置流程

**检查配置文件是否存在：**
```bash
cat ~/.claude/skills/pr-review-checker/config.json 2>/dev/null || echo "NOT_FOUND"
```

**如果配置不存在，使用 AskUserQuestion 询问用户：**

1. 询问仓库名称：
   ```
   请输入要检查的 GitHub 仓库（格式：owner/repo）
   例如：sipeed/picoclaw
   ```

2. 询问 GitHub 用户名：
   ```
   请输入你的 GitHub 用户名
   例如：yinwm
   ```

3. 创建配置文件：
```bash
mkdir -p ~/.claude/skills/pr-review-checker
cat > ~/.claude/skills/pr-review-checker/config.json << EOF
{
  "repo": "$REPO",
  "my_github_id": "$GITHUB_ID",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
```

### 修改配置流程

当用户说"修改 PR review 检查配置"或"设置 PR review 检查"时：

1. 读取当前配置并显示
2. 使用 AskUserQuestion 询问新参数
3. 更新 config.json
4. 确认修改成功

## 使用方式

### 方式一：直接运行脚本

```bash
bash ~/.claude/skills/pr-review-checker/check_prs.sh
```

### 方式二：通过 Skill 触发

用户说：
- "有没有 PR 要处理"
- "检查一下 PR 状态"
- "PR review 情况怎么样"

你应该：
1. 检查配置是否存在
2. 运行 check_prs.sh 脚本
3. 按输出结果分类呈现
4. 给出优先级建议

## 输出示例

```
正在检查 sipeed/picoclaw 的 PR 状态...

🆕 #1963 - Azure skills whitelisting
🆕 #1960 - feat: add Android build target
🔄 #1940 - feat(tools): restore team tool (新commit)
😴 #1920 - fix: typo (无新动作)

图例：
🆕 还没评论 - 需要去 review
🔄 对方有新动作 - 需要跟进
😴 对方无新动作 - 可以忽略
```

## 依赖

- **gh CLI**: GitHub CLI 工具
- **jq**: JSON 处理工具

安装依赖：
```bash
# macOS
brew install gh jq

# Linux
# gh: https://cli.github.com/
# jq: sudo apt-get install jq
```

## 注意事项

1. **认证**: 确保 `gh auth status` 显示已登录
2. **权限**: 确保对目标仓库有访问权限
3. **私有仓库**: 同样支持私有仓库，只要 gh 有权限
4. **脚本权限**: 首次使用可能需要 `chmod +x check_prs.sh`

## 工作原理

1. 使用 `gh pr list` 获取需要 review 的 PR（reviewDecision 为 REVIEW_REQUIRED 或 CHANGES_REQUESTED）
2. 对每个 PR 检查你的评论和 review 记录
3. 比较你最后一次动作的时间和对方的最新动作时间
4. 根据时间差判断是否需要关注
