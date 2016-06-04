## Hesapmakinesi olarak R
1+1
1-1

eleman1=1+1

eleman1

eleman1 <- 1 + 1

eleman1

1 + 2 / 3 - 2 * 6.5

1 * (2 / (1 + 1))


1 * 2 / 1 + 1


vektor1 = 1:9
vektor1


1.2:9


vektor2 = c(1, 3, 2, -8.1)
vektor2


vektor3 = 1:9
vektor3

vektor4 = 9:1
vektor4

vektor3 + vektor4

#hata
vektor11

vektor5 = 1:3

vektor3 + vektor5

vektor3[1:3]+vektor5

matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3)

#col sutun demek
matrix(1:8, ncol = 2)
matrix(1:9, ncol = 3)

#row satir demek
matrix(vektor3, nrow = 3)

matrix(1:20,nrow=5)

matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), ncol = 9)

matrix1 = matrix(vektor3, nrow = 3)

matrix1
matrix1 + 2

matrix1 + matrix1

# * normal carpma islemi
matrix1*2

# %*% matris carpma islemi
matrix1%*%matrix1

matrix1 * matrix1

matrix1^2

#^ us almak
2^4
matrix1^3

#t matrisin tersi
t(matrix1)


matrix1[1, 3]

matrix1[2, ]

matrix1[,-2]


matrix1[1, 1] = 15
matrix1

matrix1[ ,2 ] = 1
matrix1

matrix1[ ,2:3 ] = 2

#matris olusturma
test1=matrix(c(1:50),ncol=5,byrow=T)
test2=test1[1:7,c(3,5)]
test2

test1[5,-c(1:4)]

vektor5
matrix1[ ,2] = vektor5
matrix1

matrix1=matrix(1:9,ncol=3)
matrix1
matrix1 > 5
matrix1[matrix1 > 5]
