# 主成分分析
# PhyCA : Phylogenetic principal components analysis
# データの分散の大部分を捉えるコントラスト基礎要素を発見する
# 分散最大 -> method = 'max.var'
phyca <- PhyCA(BodySize,tree,ncores=2,ncomponents = 2)
phyca
#phylofactor object from function PhyCA
#--------------------------------------       
#  Method                    : max.var
#Number of species         : 100
#Number of factors         : 2
#Frac Explained Variance   : 0.344
#Largest non-remainder bin : 45
#Number of singletons      : 0
#Paraphyletic Remainder    : 51 species

#-------------------------------------------------------------
#  Factor Table:
#  Group1                       Group2  ExpVar
#Factor 1  4 member Monophyletic clade 96 member Monophyletic clade 0.22525
#Factor 2 45 member Monophyletic clade 51 member Paraphyletic clade 0.11907