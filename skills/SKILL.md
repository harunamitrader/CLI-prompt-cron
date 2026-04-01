# cli-prompt-cron スキル

## あなたの役割

あなたの仕事は `data/jobs/` 内の JSON ファイルを作成・編集・削除することだけです。
コマンドの実行、ログの記録、結果の保存はすべてデーモンが自動で行います。あなたが関与する必要はありません。
公開用サンプルが必要な場合は `examples/job.sample.json` を参照してください。

**やっていいこと:**
- `data/jobs/` 内の JSON ファイルの作成・編集・削除
- `data/jobs/` `data/logs/` `data/results/` の内容の読み取り
- デーモンの起動（`node start.js`）

**やってはいけないこと:**
- スクリプトファイル（.sh, .bat, .ps1, .py 等）の作成
- ラッパー、ヘルパー、補助ファイルの作成
- コマンドの最適化や独自の工夫
- `data/jobs/` 以外へのファイル書き込み

ユーザーの指示本文は `prompt` フィールドに入れてください。実際の CLI コマンドはデーモンが `targetCli` と `permissionProfile` から組み立てます。

---

## パスの解決

このファイル（SKILL.md）の親ディレクトリの親がプロジェクトルートです。
すべてのファイル操作は、そのプロジェクトルートからの絶対パスで行ってください。

```
<プロジェクトルート> = このSKILL.mdの場所から ../.. （親の親）
<プロジェクトルート>/data/jobs/    ← ジョブファイル（あなたが編集する唯一の場所）
<プロジェクトルート>/data/logs/    ← 実行ログ（読み取り専用）
<プロジェクトルート>/data/results/ ← 実行結果（読み取り専用）
```

---

## ジョブ追加

`<プロジェクトルート>/data/jobs/<名前>.json` を作成します。

```json
{
  "logId": "0001",
  "targetCli": "gemini",
  "permissionProfile": "safe",
  "prompt": "ユーザーが指定したプロンプト",
  "cron": "0 9 * * *",
  "timezone": "Asia/Tokyo",
  "active": true
}
```

| フィールド  | 型      | 必須 | 説明 |
|------------|---------|------|------|
| `logId` | string | ✓ | `0000`〜`9999` の4桁数字。既存ジョブと重複不可 |
| `targetCli` | string | ✓ | `gemini` / `claude` / `codex` |
| `permissionProfile` | string |      | `safe` / `edit` / `plan` / `full`。未指定時は `safe` |
| `prompt`   | string  | ✓    | ユーザーに送る本文 |
| `cron`     | string  | ✓    | cron 式（5フィールド形式） |
| `timezone` | string  |      | タイムゾーン（省略時は `Asia/Tokyo` を推奨） |
| `active`   | boolean |      | `false` で一時停止（デフォルト: `true`） |

### コマンドの組み立て

CLI コマンドは JSON に直接保存しません。`targetCli` と `permissionProfile` からデーモンが自動生成します。

| CLI | コマンド形式 |
|-----|-------------|
| Gemini CLI | `gemini ... -p 'プロンプト'` |
| Codex | `codex exec ... 'プロンプト'` |
| Claude Code | `claude --permission-mode ... -p 'プロンプト'` |

**例:** ユーザーが「毎朝9時にGeminiに『ニュースまとめて』と送って」と言ったら：

```json
{
  "logId": "0001",
  "targetCli": "gemini",
  "permissionProfile": "safe",
  "prompt": "ニュースまとめて",
  "cron": "0 9 * * *",
  "timezone": "Asia/Tokyo",
  "active": true
}
```

### 権限の確認

ユーザーのプロンプトに権限指定がない場合は、デフォルトで `safe` を使ってください。作成前の確認は不要です。

- `safe` = もっとも安全寄りの既定値
- Gemini CLI: `gemini -p 'プロンプト'`
- Codex: `codex exec --sandbox read-only 'プロンプト'`
- Claude Code: `claude --permission-mode default -p 'プロンプト'`

ユーザーが明示的に `edit` / `plan` / `full` を指定した場合だけ、その権限プロファイルに合わせてコマンドを組み立ててください。

```
権限指定がない場合の既定値:
- safe
```

### `logId` のルール

- すべてのジョブ JSON に `logId` が必要です
- `logId` は `0000`〜`9999` の4桁数字だけを使ってください
- 3桁以下、5桁以上、英字や記号を含む値は無効です
- 既存ジョブと同じ `logId` は使えません

---

## ジョブ停止

JSON ファイルの `active` を `false` に変更します。

## ジョブ再開

JSON ファイルの `active` を `true` に戻します。

## ジョブ削除

JSON ファイルを削除します。

## ジョブ一覧

`<プロジェクトルート>/data/jobs/` の内容を表示します。

## ログ確認

`<プロジェクトルート>/data/logs/YYYY-MM-DD.log` を読みます。

## 実行結果確認

`<プロジェクトルート>/data/results/` の内容を読みます。

## ダッシュボード起動

```bash
node <プロジェクトルート>/start.js
```

---

## cron 式チートシート

| cron 式 | 実行タイミング |
|---------|---------------|
| `0 9 * * *` | 毎朝 9:00 |
| `0 8 * * 1` | 毎週月曜 8:00 |
| `0 12 * * 1-5` | 平日 12:00 |
| `*/30 * * * *` | 30 分ごと |
| `* * * * *` | 毎分 |
| `0 9,18 * * *` | 毎日 9:00 と 18:00 |
