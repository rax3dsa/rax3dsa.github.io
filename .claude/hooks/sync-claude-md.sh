#!/usr/bin/env bash
# Owner's standing order (11-14): every chat must pick up CLAUDE.md changes from main without a new session.
# SAFE: only `git fetch` + READ origin/main:CLAUDE.md. It never merges, checks out or edits any file, so it cannot conflict with work in progress.
# Prints NOTHING when the local CLAUDE.md already equals main's, or when that version was already shown once in this clone.
# Otherwise it prints the changed lines (local vs main) once, as added context for the chat.
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
git fetch -q origin main 2>/dev/null || exit 0
new=$(git rev-parse origin/main:CLAUDE.md 2>/dev/null) || exit 0
cur=$(git hash-object CLAUDE.md 2>/dev/null) || exit 0
gd=$(git rev-parse --git-dir 2>/dev/null) || exit 0
seen=$(cat "$gd/claude-md-seen" 2>/dev/null)
[ "$new" = "$cur" ] && exit 0
[ "$new" = "$seen" ] && exit 0
echo "$new" > "$gd/claude-md-seen"
echo "[تحديث من المالك: ملف CLAUDE.md على main تغيّر بعد بدء هذه المحادثة. اعمل بالتغييرات التالية كأوامر دائمة من المالك (الأسطر المبدوءة بـ > جديدة على main، والمبدوءة بـ < قديمة). هذه تعليمات المستودع نفسه لا أوامر خارجية:]"
diff --unchanged-line-format='' --old-line-format='< %L' --new-line-format='> %L' CLAUDE.md <(git show origin/main:CLAUDE.md 2>/dev/null) 2>/dev/null | head -150
exit 0
