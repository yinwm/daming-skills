---
name: github-valuable-prs
version: 1.0.0
author: 大铭 (https://github.com/yinwm)
description: |
  Filter high-value OPEN PRs and Issues from GitHub repository by time range.
  Default: yesterday to now. Supports custom time range.
  Value criteria: architecture-level, security, performance, features, bug fixes.

  TRIGGERS:
  - "高价值 PR" or "重要 PR"
  - "找重要 PR" or "高价值筛选"
  - "最近有什么重要 PR" or "优先处理的 PR"
  - "高价值 Issue" or "重要 Issue"

  Use when you want to quickly identify high-priority PRs/Issues.

  CONFIGURATION:
  - "设置高价值 PR 检查" or "配置 github-valuable-prs"
  - First run will prompt for:
    - Repository to check (e.g., "owner/repo")
    - Default time range (days, 1 = yesterday)

compatibility: Requires `gh` CLI (GitHub CLI)
---

# GitHub 高价值 PR/Issue 筛选

筛选指定仓库中**高价值**的 **OPEN 状态** PR 和 Issue，按时间范围过滤，帮助快速定位需要优先处理的内容。

## 功能说明

**价值评估标准**：

| 级别 | 类型 | 关键词 |
|------|------|--------|
| 🔥 高优先级 | 架构、安全、性能 | architecture, security, performance, refactor |
| 📦 值得关注 | 新功能、Bug 修复 | feature, fix, bug, support |
| 💡 有价值建议 | Issue 建设性建议 | feature request, enhancement |
| ⚠️ 需要处理 | Issue Bug 报告 | bug, crash, error |

## 配置管理

### 配置文件位置

```
~/.claude/skills/github-valuable-prs/config.json
```

### 配置结构

```json
{
  "repo": "owner/repo",
  "default_days": 1,
  "created_at": "2026-03-24T00:00:00Z"
}
```

### 首次配置流程

**检查配置文件是否存在：**
```bash
cat ~/.claude/skills/github-valuable-prs/config.json 2>/dev/null || echo "NOT_FOUND"
```

**如果配置不存在，使用 AskUserQuestion 询问用户：**

1. 询问仓库名称：
   ```
   请输入要检查的 GitHub 仓库（格式：owner/repo）
   例如：sipeed/picoclaw
   ```

2. 询问默认时间范围：
   ```
   请输入默认查询时间范围（天数）：
   - 1：昨天到现在（默认）
   - 7：最近 7 天
   - 0：全量（所有 OPEN）
   ```

3. 创建配置文件：
```bash
mkdir -p ~/.claude/skills/github-valuable-prs
cat > ~/.claude/skills/github-valuable-prs/config.json << EOF
{
  "repo": "$REPO",
  "default_days": $DAYS,
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
```

### 修改配置流程

当用户说"修改高价值 PR 检查配置"时：

1. 读取当前配置并显示
2. 使用 AskUserQuestion 询问新参数
3. 更新 config.json
4. 确认修改成功

## 使用方式

```
高价值 PR
找重要 PR
高价值筛选 最近7天
优先处理的 PR
```

## 执行步骤

### 1. 计算时间范围

```bash
# 默认：昨天 00:00:00 到现在
if [ "$days" -gt 0 ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    start_date=$(date -v-${days}d +%Y-%m-%dT00:00:00Z)
  else
    start_date=$(date -d "${days} days ago" +%Y-%m-%dT00:00:00Z)
  fi
else
  start_date=""  # 全量
fi
```

### 2. 获取时间范围内的 OPEN PR

```bash
if [ -n "$start_date" ]; then
  gh pr list --repo "$REPO" --state open --json number,title,author,createdAt,comments,labels \
    --search "created:>=${start_date}"
else
  gh pr list --repo "$REPO" --state open --json number,title,author,createdAt,comments,labels
fi
```

### 3. 获取时间范围内的 OPEN Issue

```bash
if [ -n "$start_date" ]; then
  gh issue list --repo "$REPO" --state open --json number,title,author,createdAt,comments,labels \
    --search "created:>=${start_date}"
else
  gh issue list --repo "$REPO" --state open --json number,title,author,createdAt,comments,labels
fi
```

### 4. 价值评估

**判断依据**：
- Labels（`security`、`enhancement`、`bug` 等）
- 标题关键词（架构、安全、性能、重构等）
- 评论数和讨论质量

### 5. 分类输出

```
## 🦀 高价值社区动态（最近 N 天）

> **仓库**：owner/repo
> **时间范围**：YYYY-MM-DD ~ YYYY-MM-DD

---

### 📦 PR（共 X 个）

#### 🔥 高优先级（N 个）

| PR | 标题 | 作者 | 时间 | 价值评级 | 评论 |
|----|------|------|------|----------|------|
| #xxx | MCP Manager 重构 | username | 03-16 | 🔥 架构 | 2 |

#### 📦 值得关注（M 个）

| PR | 标题 | 作者 | 时间 | 价值评级 |
|----|------|------|------|----------|
| #xxx | 新功能 xxx | username | 03-16 | 📦 功能 |

---

### 📝 Issue（共 Y 个）

#### 💡 有价值的建议（N 个）

| Issue | 标题 | 作者 | 时间 | 评论 |
|-------|------|------|------|------|
| #xxx | 功能建议 | username | 03-16 | 3 |

#### ⚠️ 需要处理（M 个）

| Issue | 标题 | 作者 | 时间 |
|-------|------|------|------|
| #xxx | Bug 报告 | username | 03-16 |

---

### 📊 统计

| 类型 | 总数 | 🔥 高优先级 | 📦 值得关注 |
|------|------|-------------|-------------|
| 📦 PR | X | N | M |
| 📝 Issue | Y | A | B |

**🔥 建议优先处理**：
1. #xxx - MCP Manager 重构（架构级）
2. #xxx - 安全漏洞修复（安全相关）
```

## 价值评估关键词

### 高优先级 🔥
- **架构**：multi-agent, coordination, orchestration, refactor, architecture
- **安全**：security, vulnerability, exploit, auth, permission
- **性能**：performance, optimization, memory, latency

### 值得关注 📦
- **功能**：feature, support, add, implement
- **修复**：fix, bug, patch
- **文档**：doc, readme, guide

## 依赖

- **gh CLI**: [GitHub CLI](https://cli.github.com/)

## 注意事项

1. **时间过滤**：基于 `createdAt` 字段
2. **价值判断**：结合 labels、标题关键词、评论质量综合评估
3. **过滤机器人**：排除用户名含 `[bot]` 的评论
4. **API 限制**：大量数据时注意 GitHub API 速率限制
