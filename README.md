# my_phylofactor_practice
微生物の進化系統分類のパッケージ"phylofactor"の練習リポジトリ

# メモ
チュートリアルの内容をまとめただけ  

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

[参考](https://rdrr.io/github/reptalex/phylofactor/man/PhyloFactor.html)  
他にも色々引数を設定できる

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

## 視覚化
phytoolsというライブラリを使用する  
```R
library(phytools)
clr <- function(Matrix) apply(Matrix,MARGIN=2,FUN=function(x) log(x)-mean(log(x)))

par(mfrow=c(1,1))
phylo.heatmap(tree,clr(PF$Data))
```

## 要因ごとの違いの確認
summaryで取得
ilr : 回帰の従属変数の情報  

```R
par(mfrow=c(1,2))
plot(body.site,smry$ilr,main='Isometric log-ratio',ylab='ILR balance')
plot(body.site,smry$MeanRatio,main='Ratio of Geometric Means',ylab='Group1/Group2')
```

# 参考  
https://rdrr.io/github/reptalex/phylofactor/  
https://dfzljdn9uc3pi.cloudfront.net/2017/2969/1/PhyloFactor_tutorial.html
