# my_phylofactor_practice
微生物の進化系統分類のパッケージ"phylofactor"の練習リポジトリ

# メモ
チュートリアルの基本事項のみまとめ  

## 準備
```R
library(phylofactor)
data("FTmicrobiome")
```
データセットFTmicrobiomeは、二人から採取した糞便および舌の身体部位からの細菌  

## 各データのインポート
```R
# OTUデータ
OTUTable <- FTmicrobiome$OTUTable
# 採取地データ？(独立変数)
body.site <- FTmicrobiome$X
# 系統樹データ
tree <- FTmicrobiome$tree
# 分類データ
taxonomy <- FTmicrobiome$taxonomy
```

## 回帰分析  
OTUTableデータと独立変数(今回は採取地？)を回帰分析する。  
nfactorsには、使用する独立変数の数の数を入力すう。(前から何番目か？)  
中身の計算としては、最も分散を最大化するエッジを選択する。  
```R
PF <- PhyloFactor(OTUTable,tree,body.site,nfactors=3)
```
|  Arguments  |  Details  |
| ---- | ---- |
|  Data  |  上記の例ではOTUTableが該当  |
|  tree  |  系統樹データ。上記の例では、treeが該当  |
|   X    | 独立変数。上記の例では,body.siteが該当|
|  nfactors | 生成するクレードの数。今回の例であれば3つのクレードに分割する| 
| choice | 'var'もしくは'F'を指定|

choiceを変更することで、分割するエッジを変更できる。  
'var'はclr変換データの残差分散を最小化し、 'F'は分散分析からのF統計を最大化する。  

[参考](https://rdrr.io/github/reptalex/phylofactor/man/PhyloFactor.html)  
他にも色々引数を設定できる

### 重回帰分析
glm関数を用いると重回帰分析も可能
詳細は参考2を参照  

## 回帰分析の結果  
分割の重要度  
```
PF$factors
```
回帰の結果を見る(係数や切片など)  
```
PF$glms[[1]]
```
標準偏差やp値などの統計情報の確認  
```R
summary(aov(PF$glms[[1]]))  
```
その他、結果の要約  
```R
smry <- pf.summary(PF,taxonomy,factor=1)
pf.tidy(smry)
```

|  Arguments  |  Details  |
| ---- | ---- |
|  PF  |  PhyloFactorオブジェクト  |
|  taxonomy  |  分類データ  |
|   factor    | summaryに表示したいFactorの数| 

[参考](https://rdrr.io/github/reptalex/phylofactor/man/pf.summary.html)  

## 視覚化
phytoolsというライブラリを使用する  
```R
library(phytools)
clr <- function(Matrix) apply(Matrix,MARGIN=2,FUN=function(x) log(x)-mean(log(x)))

par(mfrow=c(1,1))
phylo.heatmap(tree,clr(PF$Data))
```

## factorごとの差異の確認
summaryで取得したデータを使用  
ilr : 回帰の従属変数を変換した情報(?)。日本語訳では等長対数比変換（ilr; isometric logratio transfor- maton）???  
[参考](https://rdrr.io/github/reptalex/phylofactor/man/ilrvec.html)  
MeanRatio : 各グループにおける分類群の幾何平均の比率  

以下は、body.site(今回は、faceとtongue)ごとの差異を箱ひげグラフでプロット　　
```R
par(mfrow=c(1,2))
plot(body.site,smry$ilr,main='Isometric log-ratio',ylab='ILR balance')
plot(body.site,smry$MeanRatio,main='Ratio of Geometric Means',ylab='Group1/Group2')
```

## 差異の原因となる細菌を表示
```R
smry$TaxaSplit %>%
      lapply(.,FUN=function(x) unique(x$TaxaIDs))
```
この関数によって表示される結果から、両Factorの細菌の差異や数の違いがわかる  

## 結果の図示
詳細は参考2を参照  
- 系統樹へのマッピング  
getFactoredEdges関数を用いることで、どのエッジで分割されているかを色をつけて系統樹に示せる  
- ILRの分割を座標に表示  
```R
pf.ordination(PF)
```
- Binの図示
BINprojection関数を用いることでビンの分類構成を図示せる

## 予測
pf.predict関数を利用する  
```R
prediction <- pf.predict(PF,factors=3)
par(mfrow=c(2,1))
phylo.heatmap(tree,clr(PF$Data))
phylo.heatmap(tree,clr(prediction))
```
pf.predictの詳細  
|  Arguments  |  Details  |
| ---- | ---- |
|  PF  |  PhyloFactorオブジェクト  |
|  factors  |  何個に分割するか？  |

# Reference  
1, https://rdrr.io/github/reptalex/phylofactor/  
2, https://dfzljdn9uc3pi.cloudfront.net/2017/2969/1/PhyloFactor_tutorial.html
