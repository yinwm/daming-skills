---
name: pr-analyze
version: 0.2.0
author: 大铭 (https://github.com/yinwm)
description: |
  Comprehensive PR analysis workflow for GitHub repositories. Use when user provides a PR number or URL and asks for analysis.
  Automatically checks PR purpose, compatibility impact, duplicate PRs, related PRs, CI status, and runs code review.
  Outputs a structured report in Chinese with actionable suggestions. Reports are saved to a configurable directory.

  TRIGGERS:
  - "帮我分析 PR #xxx" or "分析这个 PR"
  - "PR 分析" or "analyze PR"
  - "审查这个 PR" (审查时自动包含分析)
  - "查看 PR 兼容性影响"
  - "这个 PR 干什么的"
  - User provides a GitHub PR URL

  Use this skill proactively when user mentions a PR and wants to understand its scope and impact.

  CONFIGURATION:
  - "设置 PR 报告存储路径" or "修改 PR 报告存储目录" - Change report storage directory
  - First run will prompt for storage directory if not configured
compatibility: Requires `gh` CLI (GitHub CLI)
---

# PR 分析

对 GitHub PR 进行全面分析，生成结构化中文报告，并保存到本地。

## 配置管理

### 配置文件位置

```
~/.claude/skills/pr-analyze/config.json
```

### 配置结构

```json
{
  "report_dir": "/path/to/your/pr-reports"
}
```

### 检查与初始化配置

**每次运行时执行：**

```bash
CONFIG_FILE="$HOME/.claude/skills/pr-analyze/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
  # 首次运行，询问用户
  echo "首次运行 pr-analyze，需要设置报告存储目录"
  # 使用 AskUserQuestion 询问用户
fi
```

**首次运行流程：**

1. 检查 `config.json` 是否存在
2. 如果不存在，使用 `AskUserQuestion` 询问用户：
   ```
   问题：PR 分析报告需要保存到本地，请选择存储目录：

   A) 使用默认目录：~/pr-reports
   B) 使用当前项目目录：./pr-reports
   C) 自定义路径（请输入完整路径）
   ```
3. 创建目录（如果不存在）
4. 写入配置文件

**修改配置流程：**

当用户说"修改 PR 报告存储目录"或"设置 PR 报告存储路径"时：
1. 显示当前配置
2. 使用 `AskUserQuestion` 询问新路径
3. 更新 `config.json`

## 报告文件命名

```
{report_dir}/{repo_slug}/pr-{number}-{YYYYMMDD}-{HHMMSS}.md
```

示例：
```
~/pr-reports/sipeed-picoclaw/pr-1900-20260323-071500.md
```

**命名规则：**
- `{repo_slug}`: owner/repo 转换为 owner-repo（避免路径中的斜杠）
- `{number}`: PR 编号
- `{YYYYMMDD}-{HHMMSS}`: 分析时间戳，支持多次分析同一 PR

## 输入

接受以下形式：
- PR 编号：`1900`（需要当前目录在 git 仓库中）
- PR URL：`https://github.com/owner/repo/pull/1900`
- 简写：`owner/repo#1900`

## 分析流程

### Step 1: 获取 PR 基本信息

```bash
gh pr view <PR> --repo <owner/repo> --json title,body,state,author,baseRefName,headRefName,files,additions,deletions,commits,number
gh pr diff <PR> --repo <owner/repo>
```

提取：
- 标题、描述、状态（OPEN/MERGED/CLOSED）
- 作者、目标分支、源分支
- 改动文件列表、增删行数
- 关联的 Issue（从 body 中提取 `Closes #xxx` 等）

### Step 2: PR 功能说明

用 1-2 句话概括 PR 的核心目的：
- 这个 PR 解决了什么问题？
- 主要改动是什么？

如果有关联 Issue，获取 Issue 信息：
```bash
gh issue view <ISSUE_NUM> --repo <owner/repo> --json title,body,state
```

### Step 3: 兼容性影响分析

评估以下维度：

| 维度 | 检查项 |
|------|--------|
| **前端** | UI 组件、样式、路由变化 |
| **API** | 接口签名、请求/响应格式变化 |
| **依赖** | package.json、requirements.txt 变化 |
| **数据库** | Schema 迁移、数据结构变化 |
| **配置** | 环境变量、配置文件变化 |

输出格式：
```
| 影响维度 | 评估 | 说明 |
|---------|------|------|
| 前端 | ✅/⚠️/❌ | ... |
| API | ✅/⚠️/❌ | ... |
```

### Step 4: 重复 PR 检查

根据 PR 内容提取关键词，搜索相关 PR：

```bash
gh pr list --repo <owner/repo> --state all --search "<keyword1>" --json number,title,state
gh pr list --repo <owner/repo> --state all --search "<keyword2>" --json number,title,state
```

关键词来源：
- PR 标题中的技术术语
- 涉及的库名（如 `rehype`, `react-markdown`）
- 功能描述关键词

结论：
- ✅ 无重复 PR
- ⚠️ 发现相似 PR（列出并说明差异）

### Step 5: 关联 Issue 与 PR 分析

**5.1 关联 Issue 分析**

从 PR body 中提取关联的 Issue（如 `Closes #xxx`, `Fixes #xxx`, `Resolves #xxx`）：

```bash
gh issue view <ISSUE_NUM> --repo <owner/repo> --json title,body,state,labels
```

分析：
- Issue 的标题和描述
- Issue 的当前状态
- Issue 的标签（如 bug, enhancement, breaking-change）
- PR 是否完整解决了 Issue 描述的问题

**5.2 关联 PR 分析**

查找与当前 PR 相关的其他 PR，分析关系类型：

| 关系类型 | 说明 |
|---------|------|
| **替代** | 此 PR 替代了另一个 PR |
| **互补** | 与另一个 PR 功能互补 |
| **依赖** | 依赖另一个 PR 先合并 |
| **冲突** | 与另一个 PR 存在冲突 |
| **无关** | 仅关键词相似 |

输出格式：
```
### 关联 Issue
- #123: 标题 (状态: open/closed) - 简要说明 PR 如何解决此 Issue

### 关联 PR
| PR | 状态 | 关系 | 说明 |
|----|------|------|------|
| #1510 | OPEN | 互补 | Matrix 渲染改进，类似问题但不同渠道 |
```

### Step 6: CI 状态检查

```bash
gh pr checks <PR> --repo <owner/repo> || gh pr view <PR> --repo <owner/repo> --json statusCheckRollup
```

检查：
- CI 是否通过（绿色 ✅ / 红色 ❌）
- 如果失败，列出失败的原因和步骤
- 是否有阻塞合并的问题

### Step 7: 代码审查

调用 `/review` skill 进行详细代码审查：

```
/review <PR>
```

收集审查结果：
- 阻塞问题（CRITICAL）
- 建议改进（INFORMATIONAL）
- 安全隐患
- 测试覆盖

### Step 8: 检查/设置配置

**检查配置文件是否存在：**
```bash
cat ~/.claude/skills/pr-analyze/config.json 2>/dev/null || echo "NOT_FOUND"
```

**如果配置不存在，使用 AskUserQuestion 询问用户：**

```
首次使用需要设置 PR 分析报告的存储目录。

A) 使用默认路径：~/.claude/skills/pr-analyze/reports
B) 使用当前项目目录：./pr-reports
C) 自定义路径（请在"Other"中输入完整路径）
```

**写入配置（示例）：**
```bash
mkdir -p ~/.claude/skills/pr-analyze
echo '{"report_dir": "/Users/xxx/pr-reports", "created_at": "2026-03-23T07:00:00Z"}' > ~/.claude/skills/pr-analyze/config.json
```

### Step 9: 生成并输出报告

**输出原则：报告内容必须同时输出到终端和保存到文件。**

1. **终端输出** - 用户可以直接在对话中看到完整报告
2. **文件保存** - 报告存档到配置的目录，便于后续查阅

**1. 准备目录和文件名：**
```bash
# 从 repo 信息生成 slug
REPO_SLUG=$(echo "$OWNER/$REPO" | tr '/' '-')
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="${REPORT_DIR}/${REPO_SLUG}/pr-${PR_NUMBER}-${TIMESTAMP}.md"

# 创建目录
mkdir -p "$(dirname "$REPORT_FILE")"
```

**2. 报告模板：**

```markdown
# PR #{number} 分析报告

> **仓库**: {owner}/{repo}
> **分支**: {head} → {base}
> **作者**: {author}
> **状态**: {state}
> **分析时间**: {timestamp}
> **报告文件**: {report_file_path}

---

## 1. PR 功能说明

{1-2 句话概括 PR 的核心目的}

**关联 Issue**: #{issue_num} - {issue_title}（如有）

---

## 2. 兼容性影响

| 影响维度 | 评估 | 说明 |
|---------|------|------|
| 前端 | ✅/⚠️/❌ | ... |
| API | ✅/⚠️/❌ | ... |
| 依赖 | ✅/⚠️/❌ | ... |
| 数据库 | ✅/⚠️/❌ | ... |
| 配置 | ✅/⚠️/❌ | ... |

---

## 3. 重复 PR 检查

✅ 无重复 PR

或

⚠️ 发现相似 PR：
- #{pr_num}: {title} - {说明为什么相似但不重复}

---

## 4. 关联 Issue 与 PR 分析

### 关联 Issue

- #{issue_num}: {title} (状态: {state}) - {PR 如何解决此 Issue}

（如无关联 Issue 则写"无关联 Issue"）

### 关联 PR

| PR | 状态 | 关系 | 说明 |
|----|------|------|------|
| #{num} | OPEN/MERGED/CLOSED | 替代/互补/依赖/冲突/无关 | ... |

（如无关联 PR 则写"无关联 PR"）

---

## 5. CI 状态

✅ CI 通过

或

❌ CI 失败：
- 失败步骤：{step_name}
- 失败原因：{reason}

---

## 6. 代码审查结果

> 由 `/review` skill 生成

- **阻塞问题（CRITICAL）**: N 个
- **建议改进（INFORMATIONAL）**: M 个
- **关键发现**:
  1. ...
  2. ...

---

## 7. 总结与建议

### 最终评估

{对 PR 的整体评价，是否建议合并}

### 建议改进项

1. ...
2. ...

### 可选扩展

{如果发现可以扩展到其他模块，在此建议}

---

*报告由 [大铭](https://github.com/yinwm) 的 `/pr-analyze` 生成 (v0.2.0)*
```

**3. 保存报告到文件：**
```bash
cat > "$REPORT_FILE" << 'EOF'
{报告内容}
EOF
```

**4. 输出报告到终端：**

**重要：报告必须同时输出到终端和文件，便于用户直接查看。**

使用 Claude 的文本输出直接打印完整报告内容（不是文件路径），格式与保存的文件一致。

**5. 输出确认：**
```
✅ 报告已保存到: {report_file_path}
```

---

## 配置修改

当用户请求修改报告存储目录时：

**触发短语：**
- "修改 PR 报告存储目录"
- "设置 PR 报告存储路径"
- "更改 pr-analyze 配置"

**流程：**
1. 读取当前配置并显示
2. 使用 AskUserQuestion 询问新路径
3. 更新 config.json
4. 确认修改成功

---

## 注意事项

1. **CI 检查失败时**：输出警告，但不阻止分析继续
2. **无关联 Issue 时**：跳过 Issue 分析步骤
3. **大型 PR 时**：diff 可能很大，重点关注核心文件
4. **私有仓库**：确保 `gh` 已认证且有访问权限
5. **报告目录权限**：确保有写入权限，否则提示用户
6. **同一 PR 多次分析**：使用时间戳区分，不会覆盖

---

## 扩展建议

在分析完成后，如果发现：
- 改动可以扩展到其他模块（如 skills-page.tsx），主动建议用户
- 存在安全风险，强调并给出修复建议
- 测试覆盖不足，提醒用户考虑添加测试
