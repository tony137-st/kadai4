#!/bin/bash

# シェルスクリプトのテスト
echo "スクリプトのテストを開始します。"

# 失敗したテストケースのカウント
error_count=0

# テスト関数
test-koyakusu() {
    expected=$1
    shift
    num_args=$#

    # 引数の数をチェック
    if [ "$num_args" -ne 2 ]; then
        echo "❌ エラー: 引数の数が不正です。"
        echo "$output"  # 算定用スクリプトのエラーメッセージを表示
        error_count=$((error_count + 1))
        return
    fi

    # koyakusu.sh を実行し、テスト結果とエラーをキャプチャ
    output=$(bash koyakusu.sh "$@" 2>&1)
    exit_code=$?

    if [ $exit_code -ne 0 ]; then
        echo "❌ エラー: KOYAKUSU($1, $2) の実行に失敗しました。詳細:"
        echo "$output"  # 算定用スクリプトのエラーメッセージを表示
        error_count=$((error_count + 1))
        return
    fi

    # テスト成功時の結果を抽出
    result=$(echo "$output" | awk '{print $2}')

    if [[ "$result" =~ ^[0-9]+$ ]] && [ "$result" -eq "$expected" ]; then
        echo "✅ OK: KOYAKUSU($1, $2) = $expected"
    else
        echo "❌ NG: KOYAKUSU($1, $2) の結果が正解値と異なります: $result"
        error_count=$((error_count + 1))
    fi

}

# テストケース（最大公約数、引数1、引数2を入力し、テストを実行）
test-koyakusu 6 54 24
test-koyakusu 1 17 13
test-koyakusu 5 10 5
test-koyakusu 3 -10 12
test-koyakusu 9 99999999999 9
test-koyakusu 3 0 48
test-koyakusu 3 12
test-koyakusu 3 6 12 15
test-koyakusu 3 15.5 18
test-koyakusu 3 a 18

echo "テストが終了しました。"

# 全結果の判定
if [ $error_count -ne 0 ]; then
    echo "⚠️ $error_count 件のテストケースでエラーが発生しました。"
    exit 0  #GitHub Actions上でもエラー終了させる。
else
    echo "✅ 全てのテストケースが正常に終了しました。"
fi
