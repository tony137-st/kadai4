#!/bin/bash

# 引数のチェック
if [ $# -ne 2 ]; then
    echo "エラー: 2つの引数を入力してください。（入力数: $#）"
    echo "使用方法: $0 <自然数1> <自然数2>"
    exit 1
fi

# 引数のエラーチェック
error_flag=0

for arg in "$1" "$2"; do
    if ! [[ $arg =~ ^[0-9]+$ ]]; then
        if [[ $arg =~ ^- ]]; then
            echo "エラー: 負の数は入力できません。（入力値: $arg）"
        elif [[ $arg =~ ^[0-9]+\.[0-9]+$ ]]; then
            echo "エラー: 少数は入力できません。（入力値: $arg）"
        else
            echo "エラー: 数値以外の文字列が入力されました。（入力値: $arg）"
        fi
        error_flag=1
    elif [ "$arg" -gt 999999999999 ]; then
        echo "警告: 入力値が極めて大きい可能性があります。（入力値: $arg）"
    elif [ "$arg" -eq 0 ]; then
        echo "エラー: 0は自然数ではありません。（入力値: $arg）"
        error_flag=1
    fi
done

# エラーが発生していた場合は終了
if [ $error_flag -eq 1 ]; then
    exit 1
fi

# 引数を変数に格納
num1=$1
num2=$2

# 最大公約数の算定（ユークリッドの互除法）
while [ $num2 -ne 0 ]; do
    temp=$num2
    num2=$((num1 % num2))
    num1=$temp
done

# 結果を出力
echo "最大公約数: $num1"
