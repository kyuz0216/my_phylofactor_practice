library(phylofactor)
# ????
set.seed(1)
# 木を作成
tree <- rtree(5)
# 図にプロットする
# tree : 表示する木
# main : タイトル
plot.phylo(tree,main='Phylogeny - tip labels t1-t5 and tip indexes 1-5')
# label : データの値を図に表示：図の黄色部分
tiplabels(1:5,cex=1,adj = -2)
# エッジ部分の番号を表示：図の緑部分
edgelabels()
# どの辺がグループわけを行なっているか？
# 図より今回は、
getPhyloGroups(tree)[[6]]

# FTmicrobiomeというデータセットのPF(Phylofactorオブジェクト?)
# pfにはFactors、Group、binsが含まれている
pf <- FTmicrobiome$PF
pf$factors[1:2,1:2]
# Group1                        Group2
# Factor 1 40 member Monophyletic clade 250 member Monophyletic clade
# Factor 2 16 member Monophyletic clade 234 member Paraphyletic clade
# 要約
# Factor１では、４０種と２５０種に分離している。
# 残りの２５０種類が再び分類されて１６種と２３４種類に分類した。

