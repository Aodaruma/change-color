# ChangeColor

様々な色空間や補間方法で、オブジェクトの色を変化させることができる AviUtl スクリプトです。

AviUtl script that allows to change color of a object with various color space and interpolation.


以下のスクリプトが備わっています。

## ChangeColor.anm

以下はパラメーターの説明です。

- **トラックバー/チェックボックス**
  - 強度(%)
    - このスクリプトの適用度合いを指定します。
  - AF(%)
    - ダイアログの`色配列`で入力された色に基づき、色の変化の割合を指定します。
  - 色空間
    - 色変化を行う色空間を指定します。
  - 補間方法
    - 特定の色空間上で、変数の変化の仕方を指定します。
      - `HSV`, `HSL`, `HCT`の場合、色相`Hue`を次の通りに変化させます。
          1. Nearest, 最寄りのルートで補間します。
          2. Farthest, 最も通いルートで補間します。
          3. Clockwise, 時計回りのルートで補間します。
          4. Counter-Clockwise, 反時計回りのルートで補間します。
  - showInfo
    - スクリプトやパラメーターの情報について表示します。

- **ダイアログ**
  - 色配列
    - 変化させる色を指定します。テーブルで、各要素は`0x000000 ~ 0xffffff`までの数です。
  - ｲｰｼﾞﾝｸﾞ
    - 変化させる色のイージングを指定します。整数またはテーブルが指定できます。
      - 整数を指定する場合は、$[-10, 41]$までの整数が指定できます。
      - テーブルでは、色空間で用いられる変数の数だけの要素が必要になります。それぞれの要素は整数で、上述の範囲に従います。

## 導入方法 / how to install

[こちらのリポジトリ](https://github.com/Aodaruma/Aodaruma-AviUtl-Script)を参照してください。

## バグ・意見 / how to report bugs

バグや意見等については、Twitter の DM に送るか、issue を立ち上げてください。

## 変更履歴 / change log

- v1.00 - 正式に配布開始。
