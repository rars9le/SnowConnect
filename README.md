# SnowConnect
主にスノーボーダー・スキーヤー向けに制作した雪山で遊ぶ人とコミュニケーションを取ったり仲間を探す為のSNSです。<br>
ポートフォリオとして制作致しました。

![snowconect](https://user-images.githubusercontent.com/68137139/100540158-e0941000-327e-11eb-8e3c-98ec37b0e351.PNG)

## 制作背景
私はスノーボードが大好きで、毎年冬になると毎週のようにゲレンデに通っていますが、<br>
年を追うごとに感じていた悩みが「一緒に滑れる気の合う仲間が少ない」という事です。<br>
一言にスノーボードと言っても、遊び方やレベル・好きなゲレンデなどは人によってかなり差があり、気の合う仲間を見つけるのは難しいと感じます。<br>
しかし、ゲレンデで自分に近いレベルや遊び方の人を直接探してコミュニケーションを取るというのは、非常に困難なものです。<br>
そんな自分自身や周りの友達の悩みをITで解決できるサービスがあれば良いなと感じ、制作いたしました。

## URL
https://www.snowconnect.xyz/<br>
- 非ログイン状態の場合は閲覧、検索のみ可能です。ログインすると投稿やコメントが可能になります。
- ログイン画面の「かんたんログイン」をクリックすると、メールアドレスとパスワードを入力せずにログインできます。
- メールアドレス"admin@example.com"、パスワード"12345678"で【管理者】としてログインできます。
- 【管理者】は、他の一般ユーザーのアカウントや投稿、コメントを削除できる権限を持ちます。
- レスポンシブ対応しているので、スマホからでもご覧いただけます。

## 使用技術
- Ruby 2.6.3, Rails 6.0.3.2
- MySQL 8.0.22
- Nginx, Puma
- AWS（VPC, ECS, ECR, RDS, Route 53, ALB, ACM, S3）
- RSpec
- Rubocop
- Sass, Bootstrap
- Javascript(jQuery)
- Git, Github

## AWS構成図
![AWS構成図](https://user-images.githubusercontent.com/68137139/100541841-d7f50700-3289-11eb-8856-c9b8bedc6b55.png)

## 機能一覧
- ユーザー機能
  - deviseを使用
  - 新規登録、ログイン、ログアウト機能
  - マイページ、登録情報編集機能
- 投稿関係
  - 投稿一覧表示、投稿、投稿削除機能
  - 画像のアップロードはcarrierwaveを使用
- コメント関係
  - コメント表示、コメント投稿、コメント削除機能
- ページネーション機能
  - (kaminari)を使用
- いいね機能
  - 登録したいいねの一覧表示、人気順表示機能
- フォロー機能
  - フォロー、フォロワー一覧表示機能
- ユーザー検索機能
  - 複数の検索条件を指定可能
  - (Ransackを使用)
- 管理ユーザー機能
  - ユーザー一覧の表示、一般ユーザーのアカウントや投稿、コメントを削除可能
- Rspecによるテスト機能
  - 単体テスト機能
  - 統合テスト機能
