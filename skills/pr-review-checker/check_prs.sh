#!/bin/bash

# PR Review Checker Script
# 检查需要 review 的 PR，并按逻辑分类
#
# 配置文件位置: ~/.claude/skills/pr-review-checker/config.json

set -e

# 配置文件路径
CONFIG_FILE="$HOME/.claude/skills/pr-review-checker/config.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查配置文件
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 配置文件不存在: $CONFIG_FILE"
    echo ""
    echo "请先运行 /pr-review-checker 进行首次配置"
    exit 1
fi

# 从配置文件读取参数
REPO=$(jq -r '.repo // empty' "$CONFIG_FILE" 2>/dev/null)
MY_GITHUB_ID=$(jq -r '.my_github_id // empty' "$CONFIG_FILE" 2>/dev/null)

# 验证配置
if [ -z "$REPO" ] || [ "$REPO" = "null" ]; then
    echo "❌ 配置文件中缺少 'repo' 字段"
    exit 1
fi

if [ -z "$MY_GITHUB_ID" ] || [ "$MY_GITHUB_ID" = "null" ]; then
    echo "❌ 配置文件中缺少 'my_github_id' 字段"
    exit 1
fi

echo "正在检查 $REPO 的 PR 状态..."
echo ""

# 获取 PR 列表
gh pr list --repo "$REPO" --state open --json number,title,reviewDecision --limit 100 2>/dev/null | \
  jq -r '.[] | select(.reviewDecision == "REVIEW_REQUIRED" or .reviewDecision == "CHANGES_REQUESTED") | .number' | \
  head -15 | while read -r pr_number; do

  # 获取 PR 详情
  pr_data=$(gh pr view "$pr_number" --repo "$REPO" --json title,reviewDecision,reviews,comments,commits,updatedAt 2>/dev/null)

  title=$(echo "$pr_data" | jq -r '.title')
  review_decision=$(echo "$pr_data" | jq -r '.reviewDecision')

  # 检查我的评论/Review
  my_comments=$(echo "$pr_data" | jq -r '.comments[] | select(.author.login == "'"$MY_GITHUB_ID"'") | .createdAt' | sort -r | head -1)
  my_reviews=$(echo "$pr_data" | jq -r '.reviews[] | select(.author.login == "'"$MY_GITHUB_ID"'") | .submittedAt' | sort -r | head -1)

  # 取最新的时间
  if [[ -n "$my_comments" && -n "$my_reviews" ]]; then
      if [[ "$my_comments" > "$my_reviews" ]]; then
          my_last_action="$my_comments"
      else
          my_last_action="$my_reviews"
      fi
  elif [[ -n "$my_comments" ]]; then
      my_last_action="$my_comments"
  elif [[ -n "$my_reviews" ]]; then
      my_last_action="$my_reviews"
  else
      my_last_action=""
  fi

  if [[ -z "$my_last_action" ]]; then
      echo "🆕 #$pr_number - $title"
  else
      # 检查对方是否有新动作
      last_commit=$(echo "$pr_data" | jq -r '.commits[-1].committedDate // empty')

      has_new=false
      action_type=""

      if [[ -n "$last_commit" && "$last_commit" > "$my_last_action" ]]; then
          has_new=true
          action_type="新commit"
      fi

      # 检查其他人的评论
      other_comments=$(echo "$pr_data" | jq -r '.comments[] | select(.author.login != "'"$MY_GITHUB_ID"'") | .createdAt' | sort -r | head -1)
      if [[ -n "$other_comments" && "$other_comments" > "$my_last_action" ]]; then
          has_new=true
          if [[ -n "$action_type" ]]; then
              action_type="$action_type+新评论"
          else
              action_type="新评论"
          fi
      fi

      if [[ "$has_new" == true ]]; then
          echo "🔄 #$pr_number - $title ($action_type)"
      else
          echo "😴 #$pr_number - $title (无新动作)"
      fi
  fi
done

echo ""
echo "图例："
echo "🆕 还没评论 - 需要去 review"
echo "🔄 对方有新动作 - 需要跟进"
echo "😴 对方无新动作 - 可以忽略"
