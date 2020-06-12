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