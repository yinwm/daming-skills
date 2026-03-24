# GitHub Valuable PRs [高价值 PR/Issue 筛选](#中文)

> Filter high-value OPEN PRs and Issues by time range

---

## 中文

### 功能

筛选仓库中**高价值**的 OPEN PR 和 Issue，按时间范围过滤，快速定位需要优先处理的内容。

**价值评估**：
- 🔥 **高优先级** - 架构、安全、性能相关
- 📦 **值得关注** - 新功能、Bug 修复
- 💡 **有价值建议** - Issue 建设性建议
- ⚠️ **需要处理** - Issue Bug 报告

### 安装

```bash
# 从 GitHub 安装
git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && \
cp -r /tmp/daming-skills/skills/github-valuable-prs ~/.claude/skills/ && \
rm -rf /tmp/daming-skills
```

### 配置

首次使用时输入：
- 仓库地址（如 `sipeed/picoclaw`）
- 默认时间范围（1 = 昨天，7 = 最近7天，0 = 全量）

或手动配置：

```bash
mkdir -p ~/.claude/skills/github-valuable-prs
cat > ~/.claude/skills/github-valuable-prs/config.json << EOF
{
  "repo": "owner/repo",
  "default_days": 1
}
EOF
```

### 使用

```
高价值 PR
找重要 PR
高价值筛选 最近7天
优先处理的 PR
```

---

## English

### Features

Filter **high-value** OPEN PRs and Issues from GitHub repository by time range.

**Value criteria**:
- 🔥 **High priority** - Architecture, security, performance
- 📦 **Worth attention** - New features, bug fixes
- 💡 **Valuable suggestions** - Feature requests
- ⚠️ **Needs handling** - Bug reports

### Installation

```bash
# Install from GitHub
git clone https://github.com/yinwm/daming-skills.git /tmp/daming-skills && \
cp -r /tmp/daming-skills/skills/github-valuable-prs ~/.claude/skills/ && \
rm -rf /tmp/daming-skills
```

### Configuration

You'll be prompted on first use:
- Repository (e.g., `sipeed/picoclaw`)
- Default time range (1 = yesterday, 7 = last 7 days, 0 = all)

Or manually configure:

```bash
mkdir -p ~/.claude/skills/github-valuable-prs
cat > ~/.claude/skills/github-valuable-prs/config.json << EOF
{
  "repo": "owner/repo",
  "default_days": 1
}
EOF
```

### Usage

```
High-value PRs
Important PRs
Filter valuable last 7 days
Priority PRs
```

---

**Author**: 大铭 (https://github.com/yinwm)
**Version**: 1.0.0
**Dependencies**: `gh` CLI
