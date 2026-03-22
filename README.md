このリポジトリでは、GitHub Actionsを使用して、GnuCOBOL OSS Consortium PatchのインストールされたDockerイメージのリリースを行います。

# リリース手順

## build-config.jsonの編集

リリースするバージョンに合わせて、build-config.jsonを編集します。
* gnucobol_osscons_patch_version: Dockerイメージにインストールする[GnuCOBOL OSS Consortium Patch](https://github.com/opensourcecobol/gnucobol-osscons-patch)のバージョン
* version_string_prefix: リリースするDockerイメージタグのプレフィックス
  * 例えば20260322を指定すると、以下の2つのタグを持つDockerイメージがビルドされ、Docker Hubにプッシュされます。
    * opensourcecobol/gnucobol-osscons-patch:20260322
    * opensourcecobol/gnucobol-osscons-patch:latest

## ワークフローの手動実行

[公式ドキュメント](https://docs.github.com/ja/actions/how-tos/manage-workflow-runs/manually-run-a-workflow)を参考にして、ワークフローを手動で実行します。

* ワークフロー名: `Build and Push Docker Image`
* ブランチ: `main`
* 入力パラメータ: `push_to_dockerhub`に`true`を指定

これによりDockerイメージがビルドされ、Docker HubにDockerイメージがプッシュされます。
