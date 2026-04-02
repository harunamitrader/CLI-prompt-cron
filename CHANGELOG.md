# Changelog

## [Unreleased]

## [1.7.0] - 2026-04-03

### Added
- **セッション候補の蓄積管理**: `fresh` 実行で作られた Codex session を sessionId 単位で保存し、過去 session を一覧から選べるように
- **セッション追送 API**: `POST /api/sessions/:sessionId/prompt` を追加し、既存 session に即時プロンプトを送信可能に
- **結果モーダルから追送**: sessionId を含む実行結果から、その session に追加プロンプトを送れる UI を追加
- **ダッシュボードから新規作成**: UI 上でジョブ名・送信先 CLI・権限・セッション・cron・プロンプトを入力して新規定期実行を作成可能に

### Changed
- **セッション表示ラベル**: `logId / job名 / 作成時刻 / sessionId末尾` の表示に変更し、同一 job の複数 session を区別しやすく改善
- **新規作成フォームの導線**: 常時表示から、ジョブ一覧下の `＋ 新規定期実行` ボタンで開く方式に変更
- **ライブログの並び順**: 新しいログが上に積まれる表示へ変更
- **ログ / 実行結果ペイン**: 表示高さに上限を設け、各ペイン内で独立スクロールできるように改善

### Fixed
- **daemon 起動エラー**: `readJobSessionUsage` 欠落により定期実行が止まる問題を修正
- **session 検出**: Codex の stderr に出る `session id:` を直接取得し、fresh 実行後の session 記録を安定化

## [1.6.0] - 2026-04-02

### Added
- **デフォルト作業ディレクトリ設定**: ダッシュボード上で全ジョブ共通の default CWD を変更できるようにし、親ワークスペースから CLI を起動可能に
- **ジョブ削除ボタン**: ダッシュボードから停止中ジョブを直接削除できるように
- **サンプルジョブファイル**: tracked なサンプルを `examples/job.sample.json` に追加

### Changed
- **`logId` を必須化**: `logId` は `0000`〜`9999` の4桁数字のみ許可し、重複時は保存不可に変更
- **ダッシュボード表示**: `logId` 未設定時は job 名にフォールバックせず `未設定` と表示
- **README / SKILL.md 更新**: `logId` ルール、default CWD 設定、サンプル job を反映

## [1.5.0] - 2026-04-01

### Added
- **送信先 CLI の明示設定**: ジョブごとに `targetCli` として `gemini` / `claude` / `codex` を保存し、ダッシュボードから切り替え可能に
- **権限プロファイルの統一**: `permissionProfile` を `safe` / `edit` / `plan` / `full` の4種類に統一し、ダッシュボードから選択可能に
- **logId 表示**: ジョブカードに `logId` を表示し、ログタグも `logId` 優先で出力できるように

### Changed
- **ジョブ JSON スキーマ**: `command` 保存中心から `targetCli` / `permissionProfile` / `prompt` 保存中心に変更。実際の CLI コマンドは実行時にデーモン側で組み立て
- **README / SKILL.md 更新**: 新しいジョブスキーマ、`safe` 既定、送信先 CLI と権限プロファイルの仕様に合わせて説明を更新
- **ダッシュボード表示改善**: 長いプロンプトの複数行表示、編集時の4行 textarea、ログ時刻とタグの色分け、実行結果の見やすい日時表示を追加

## [1.4.0] - 2026-03-29

### Added
- **ダッシュボードからジョブ編集**: ジョブ名・cron式・プロンプト・権限フラグをクリックしてインライン編集可能に。Enter で保存、Escape でキャンセル
- **ジョブ名リネーム**: 停止中かつ未実行のジョブはダッシュボードから名前変更可能。ファイル名・PIDファイルも連動してリネーム
- **デスクトップ通知**: ジョブ完了時にブラウザのデスクトップ通知で実行結果の内容をポップアップ表示（最大300文字）。クリックで結果詳細を表示
- 次回実行まで1分未満の場合、「あと○秒」と秒単位で表示

### Changed
- `PATCH /api/jobs/:name` を拡張: JSON ボディでフィールド単位の更新・リネームに対応（cron, command, timezone, active, name）
- テストプロンプトから notepad 起動を削除（Codex sandbox 制限のため不要）

## [1.3.4] - 2026-03-29

### Fixed
- 強制停止で Windows は `taskkill /T /F` を使いプロセスツリーごと終了。停止した PID を即時で PID ファイルから除去し、ログに `KILL` を追記

## [1.3.3] - 2026-03-29

### Fixed
- 「実行中」セクションが非表示のままになる問題を修正（デフォルトを表示にし、JS でも明示表示）

## [1.3.2] - 2026-03-29

### Fixed
- 「実行中」セクションを常時表示し、稼働中が無い場合も空状態を明示

## [1.3.1] - 2026-03-29

### Fixed
- 実行中モニターが表示されないことがある問題を修正（子プロセスの存否判定を緩和し、`running` カウントのみでも表示）
- ヘッダーにバージョンバッジを追加して、画面更新の確認を容易に

## [1.3.0] - 2026-03-29

### Added
- **ダッシュボードからジョブの停止・再開**: スケジュール一覧の各カードに「停止」「再開」ボタンを追加。ブラウザからワンクリックでジョブの有効/無効を切り替え可能
- **「実行中」セクション**: ダッシュボード上部に専用の実行中エリアを追加。経過時間をリアルタイム表示（1秒更新）。強制停止ボタンもここに集約
- **実行中ステータス表示**: プロセス実行中のジョブに「実行中」バッジを表示。複数同時実行時は `実行中 x3` のように個数表示
- **ジョブカードにコマンド表示**: プロンプトと権限フラグを別行で表示。ホバーで全文確認可能
- **`PATCH /api/jobs/:name`**: ジョブの `active` フィールドをトグルする API エンドポイントを追加
- **`DELETE /api/running/:name`**: 実行中プロセスを全件強制停止する API エンドポイントを追加
- **デーモン終了時の子プロセス強制停止**: コマンドプロンプトを閉じた際、実行中のジョブプロセスもすべて自動で kill
- **ジョブ実行タイムアウト**: デフォルト60分で自動 kill。環境変数 `JOB_TIMEOUT_MINUTES` で変更可能

## [1.2.1] - 2026-03-29

### Changed
- **SKILL.md 根本改修**: AI CLI が余計なファイル（スクリプト・ラッパー等）を作成しないよう、役割定義と行動制約を明示。ジョブ JSON の作成・編集・削除のみに限定

## [1.2.0] - 2026-03-29

### Added
- **デスクトップショートカット自動作成**: `npm install` 時にアイコン付きショートカットをデスクトップに自動生成（Windows / Mac / Linux 対応）
- **ヘッダー画像・アイコン**: `assets/header.jpg`（リポジトリバナー）、`assets/icon.jpg`（アプリアイコン）を追加
- **create-shortcut.bat**: Windows 向け手動ショートカット作成スクリプト
- **scripts/create-shortcut.js**: クロスプラットフォーム対応のショートカット作成スクリプト（postinstall で自動実行）

### Fixed
- **ICO 変換**: `ImageFormat::Icon` が 0 バイトファイルを生成する問題を修正。PNG-in-ICO コンテナ形式で正しく変換
- **ブラウザ起動**: `cmd /c start` が launch.bat と競合する問題を修正。`explorer` に変更
- **ui-server.js 起動エラー**: `__dirname` の定義順序が壊れていた問題を修正
- **package.json 消失**: リネーム時の `git add -A` で削除されていたのを復元
- **launch.bat**: Node.js 存在チェック追加、日本語メッセージの文字化け防止（ASCII のみに変更）、エラー時 pause 追加

## [1.1.0] - 2026-03-28

### Changed
- **プロジェクト名**: `cli-prompt-cron-ui` → `cli-prompt-cron` に統一（旧ヘッドレス版は廃止）
- **データディレクトリ**: `./data/` → プロジェクト内 `./data/` に移動。作業ディレクトリ制限のある環境でも動作可能に
- **SKILL.md パス解決**: 相対パス（`./data/`）から SKILL.md のファイル位置ベース（`<プロジェクトルート>/data/`）に変更。作業ディレクトリに依存しない
- **ターゲット CLI**: Gemini CLI・Codex をメインに。Claude Code は補助的な位置づけに変更
- **ダッシュボード UI**: ダーク系ターミナル風 → クリーム系モダンデザイン（Design B）に刷新
- **README 構成**: 「プロンプトでの導入・使い方」としてStep 1/2/3のフローに再構成。CLI共通のプロンプトに統一

### Added
- **launch.bat**: Windows 向けワンクリック起動バッチファイル（ポート競合自動解消付き）
- **cron 式の日本語変換**: ダッシュボードで `0 9 * * *` → `毎日 09:00` と表示
- **次回実行の相対表示**: `あと2時間`、`明日 09:00` など
- **ライブインジケーター**: ヘッダーに緑点滅の接続状態表示
- **index.html.backup**: 元のダークテーマデザインのバックアップ

## [1.0.1] - 2026-03-28

### Fixed
- **Windows cmd quoting**: `cmd /c` mangled inner double quotes in complex command strings (e.g. `--system-prompt "..." -p "..."`), causing the prompt to arrive as empty. Switched to `powershell -Command` on Windows, which handles quoted arguments correctly.
- **Codex non-interactive mode**: `codex "..."` requires a TTY and fails in cron. Updated SKILL.md to use `codex exec "..."` for non-interactive execution.
- **Claude system prompt confusion**: `--system-prompt "Non-interactive cron agent..."` caused Claude to answer about cron tools instead of the actual task. Revised to a neutral instruction.
- **README**: Fixed placeholder GitHub URL and git clone URL. Corrected result file format (`.txt` not JSON). Added `--system-prompt` to job example. Added Codex `exec` note.

### Added
- **Permission confirmation flow** in SKILL.md: When adding a job, if no permission flags are specified, the AI presents a numbered menu of options (no-permission, Write, Bash, WebSearch, etc.) before creating the job.
- **Automatic system prompt** in SKILL.md: All Claude Code jobs now automatically include `--system-prompt "Execute the task immediately. Do not ask for confirmation or clarification."` to suppress interactive confirmation requests.
- **Natural language setup and usage** instructions in README.

## [1.0.0] - 2026-03-28

### Added
- File-based cron daemon for AI CLIs (Claude Code, Gemini CLI, Codex)
- Browser dashboard at `http://localhost:3300` (vanilla HTML/CSS/JS, no build step)
- Real-time log streaming via Server-Sent Events (SSE)
- Execution results saved per-job to `./data/results/`
- Job management via `./data/jobs/*.json`
- Hot-reload with Chokidar (add / edit / delete jobs without restarting daemon)
- `start.js`: one-command launch — daemon + UI server + auto browser open
- Per-job timezone support
- Graceful shutdown on SIGINT / SIGTERM / SIGBREAK
- Skills for Claude Code, Gemini CLI, Codex (`skills/SKILL.md`)
- API endpoints: `GET /api/jobs`, `GET /api/results`, `GET /api/logs/stream`
