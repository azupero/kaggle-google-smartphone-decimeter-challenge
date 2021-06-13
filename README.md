# Google Smartphone Decimeter Challenge
## Overview
### Description
不意にポットホールなどの道路障害物にぶつかったことはありませんか？また、ナビゲーションアプリで、より正確な位置情報や車線レベルの精度が得られたらと思ったことはありませんか？これらの機能やその他の新しい機能は、スマートフォンの測位サービスによって実現されています。機械学習と高精度GNSSアルゴリズムにより、この精度が向上し、何十億人ものAndroid携帯電話ユーザーに、よりきめ細かな測位体験を提供できるようになると期待されています。

全地球測位衛星システム（GNSS）は、生の信号を提供し、GPSチップセットはそれを使って位置を計算します。現在の携帯電話では、3〜5メートルの位置精度しか得られません。これは多くの場合、便利ではありますが、"ビビり "の原因となります。多くのユースケースでは、その結果は、信頼できるほど細かくも安定してもいません。
Android GPSチームが主催するこのコンテストは、ION GNSS+ 2021 Conferenceで発表されます。彼らは、スマートフォンのGNSS測位精度の研究を進め、人々が身の回りの世界をよりよくナビゲートできるようにすることを目指しています。

このコンペティションでは、ホストチームが所有するAndroid携帯電話から収集したデータを使用して、可能であれば10cm、さらにはcm単位の分解能で位置を計算します。また、正確なグラウンドトゥルース、生のGPS測定値、近隣のGPSステーションからのアシスタンスデータを利用して、応募作品のトレーニングとテストを行います。
成功すれば、より正確な位置情報を得ることができ、より細かい人間の行動の地理空間情報と、より細かい粒度のモバイルインターネットとの橋渡しをすることができます。モバイルユーザーは、より良い車線レベルの座標を得て、ロケーションベースのゲームの経験を強化し、交通安全上の問題の位置をより具体的に把握することができます。さらには、行きたい場所に簡単に行けるようになったことに気づくかもしれません。
### Evaluation
提出されたデータは、50パーセンタイルと95パーセンタイルの距離誤差の平均値で採点されます。すべての電話機のすべての `millisSinceGpsEpoch` において、予測された緯度/経度とグランドトゥルースの緯度/経度との間の水平方向の距離（メートル）が計算されます。
これらの距離誤差は分布を形成し、そこから50パーセンタイル誤差と95パーセンタイル誤差が計算されます（つまり、95パーセンタイル誤差は、距離誤差の95%が小さくなる値（メートル単位）です）。次に、50パーセンタイルと95パーセンタイルの誤差を各電話機ごとに平均化します。最後に，テストセット内のすべての電話機について，これらの平均値を算出します．
## Data Description
### `ground_truth.csv`
タイムスタンプ毎の位置。`latDeg, lngDeg`の緯度経度の値を予測するのが本コンペのタスク。
|Name|Explanation|
|----|----|
|`millisSinceGpsEpoch`|1980/1/6深夜を基準としたtimestamp|
|`latDeg, lngDeg`|GNSSから受信したWGS84(世界測地系という世界共通の位置基準)の緯度経度情報。必要に応じて線形補間されているらしい。|
|`heightAboveWgs84EllipsoidM`|WGS楕円体からの高さを示す(m)。|
|`timeSinceFirstFixSeconds`|最初に位置情報を取得してからの経過時間。|
|`hDop`|水平方向の精度の希釈(よく分からない)。恐らく位置推定の誤差を示す。|
|`vDop`|垂直方向の精度の希釈。|
|`speedMps`|地上での速度(m/s)|
|`courseDegree`|真北を基準としたコースの角度|

### `[train/test]/[drive_id]/[phone_name]/supplemental/[phone_name][.20o/.21o/.nmea]`
GNSSログと等価な補足情報

### `baseline_locations_[train/test].csv`
シンプルな手法(どういう手法?)による位置推定

### `[train/test]/[drive_id]/[phone_name]/[phone_name]_derived.csv`
- GNSSの生の測定データ
- 補正された疑似距離（電話機から衛星までの幾何学的な距離に近い値）は、 correctedPrM = rawPrM + satClkBiasM - isrbM - ionoDelayM - tropoDelayM と計算できます。ベースラインの位置は、補正されたPrMと衛星の位置を用いて、標準的な重み付き最小二乗（WLS）ソルバーを使用して計算されます。このソルバーでは、電話機の位置（x、y、z）、クロックバイアス（t）、および固有の信号タイプごとのisrbMがエポックごとの状態として設定されます。

|name|Explanation|
|----|----|
|`collectionName`|2つ上の階層のフォルダ名|
|`phoneName`|1つ上の階層のフォルダ名|
|`millisSinceGpsEpoch`||
|`constellationType`|GNSSコンステレーションタイプ(?)。`metadata/constellation_type_mapping.csv`で提供されるマッピング文字列値を持つ整数値。|
|`svid`|衛星ID|
|`signalType`||
## log
### 2021-06-11
- join
- `nb001`
    - ground_truthを軽く開いてマッピングしてみた
- 精度の悪いdeviceを削除して補間する後処理だけでscoreが上がるらしい
    - [device EDA & Interpolate by removing device[en,ja]](https://www.kaggle.com/columbia2131/device-eda-interpolate-by-removing-device-en-ja)
    - indoorと同じく後処理の重要性が高いコンペか?
### 2021-06-12
- kaggle日記をREADMEに変更
    - データセットの説明を書き始めた
### 2021-06-13
- `nb002`
    - [device EDA & Interpolate by removing device[en,ja]](https://www.kaggle.com/columbia2131/device-eda-interpolate-by-removing-device-en-ja)
    - 上記を試してみた
    - `collectionName`間で同一deviceでもtruthとの誤差が異なっていた
        - ルートや速度といった実験環境の違いが影響しているかも？
- `nb003`
    - [Road detection and creating grid points](https://www.kaggle.com/kuto0633/road-detection-and-creating-grid-points/comments)
    - indoorの後処理でもあったSnap to Gridを本コンペで試したみた感じ
    - 完全にはグリッドを作りきれていないのでこれから工夫してみる必要がありそう
