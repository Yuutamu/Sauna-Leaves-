# はじめに
### テントサウナのレンタルサービスとは？
- 一式購入するとなると30万近く費用を要するテントサウナをレンタルにてご利用いただけるサービスです。
- レンタルしてみて、気に入れば弊社定価からレンタル料金を差し引いた金額で購入が可能（→損しない料金プラン）

- テントサウナは楽しいので、みんなに利用して欲しい！楽しんでもらいたい！（→完全に趣味の延長のサービスです。レンタルしてくれる場合は、僕も一緒に連れてってほしいです(笑) 僕の特技は火打ち石から火を起こすことです！）

### サービスURL
（現在はβ版ということで、クローズドで運営しています。）
https://sauna-leaves.onrender.com/

# ざっくりと機能説明
- エンドユーザー向け機能
  - ユーザー認証
  - 商品閲覧、カート追加、購入
  - 決済機能（Stripeを利用）
  - メール送信機能

- 管理者画面（用途：運営スタッフ利用）
  - 商品登録、掲載
  - 在庫管理
  - 顧客ステータス管理（Stripeから怪しいユーザー検出された場合は、印を付けておく等）
  - 出荷/返送管理
  - 売上表示機能

# 技術スタック

### 言語、フレームワーク
- Ruby
- Ruby on Rails
- TailWind CSS

### データベース
- PostgreSQL
- Redis

### 決済機能
- [Stripe](https://stripe.com/docs/api)
 決済ページもstripe webhook を用いて実装

### コード 品質管理
- Rubocop

### 非同期処理
- Sidekiq
顧客への注文確認メールの送信を非同期にて処理しています。
Sidekiq 選定理由：他サービスよりもメンテナンスがされてるいること、1個のプロセスで動作させられるのでメモリ使用量が少なく経済的ということから。

### メール送信機能
- Action Mailer

### アイコン
- [Google icons](https://fonts.google.com/icons)
- [Heroicons](https://heroicons.com/)

### Docker
以下の方のdockerを利用して作成しております。（一般的なRailsアプリケーションのためのDocker）
https://github.com/nickjj/docker-rails-example

# 画面遷移図
### エンドユーザー向け画面
| トップ画面 | 
| ---- |
| ![Top画面](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/2987dae1-48ab-4f2c-bd39-a06d8315a67a) |
| - ログインの有無により、ヘッダーメニューのアイコンが変更 |
| - ファーストビューで目を引くようなテントサウナの写真を設置。 |
| - サービスの説明、オススメ商品、ご利用手順などユーザーにとってテンポの良いUI |

| 商品一覧 | 商品詳細 |
| ---- | ---- |
| ![商品一覧](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/97e86941-e678-447d-9aa2-3d9ee66d4963)| ![商品詳細](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/9862a88a-624d-48f6-920f-79982843756f) |
| 金額、登録順によりソート可能。商品をカード化することでUI/UXの向上 | 視認性重視のUI。残り在庫を表示。 |

| カートページ | 決済ページ |
| ---- | ---- |
| ![Cart_Page](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/a1bc44e1-f405-4058-b840-0ab09e8bfd87)| ![Payment_Page](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/163c3263-7bde-4e58-abb6-4c9a74c80ee1) |
| 敢えて、情報量を少なくすることで金額、数量等の間違えが無いようなUI設計 | Stripe webhook を用いて作成 |

| 注文完了 | 注文履歴一覧 |
| ---- | ---- |
| ![Thanks_Page](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/e7aa4e67-56b2-4be5-81f1-cd154549413b)| ![AllOrder_Page](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/61231f7a-1465-485e-a83b-8133f82bdf15) |
| 同時に、注文完了メールを非同期で送信 | 過去の注文履歴を日時と共に一覧表示 |

| 注文履歴詳細 | Sign Up |
| ---- | ---- |
| ![OrderDetail_Page](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/32def142-cbfa-4043-9834-967aad43ea16)| ![SignUp_Page](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/5d1ad1c4-5be5-4502-9ec2-02f90ac33b9e) |
| OrderStatus より、商品の発送状況等の確認が可能。今後、配送伝票を連携予定 | 新規会員登録 |

| SignIn | ユーザー情報編集 |
| ---- | ---- |
| ![SignIn_Page](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/351b02df-a5db-430f-b94e-6a8d13c16f49)| ![UserEdit_Page](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/992b66c5-dd2c-4d0d-b0b7-02353df24c68) |
| 既存ユーザーログイン | ユーザー情報編集 |

| 退会画面 |
| ---- |
| ![Withdraw_Page](https://github.com/Yuutamu/Sauna-Leaves-forShare/assets/143495920/d11bcd42-eee0-4a53-90de-29fbf89bce30) |
| 分かりやすいUIを意識。退会するとユーザーのステータスを更新 |


figmaはこちら
https://www.figma.com/design/BHzg3RYenNvqUUbCXc0Wze/SaunaLeaves_%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?node-id=0%3A1&t=RXCxmitysttMdm3Q-1

## 動かし方
注文するには、StripeのCLIをdocker上で立ち上げる必要があります。
（dockerfile でアクセス等を記載しておけば必要なし。）
