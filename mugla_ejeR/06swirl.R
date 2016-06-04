# library(swirlify)
# 
# # Create a new lesson and a new course
# new_lesson("001", "giRiş")
# 
# #require(linprog)
# # Start editing your new lesson
# file.edit(lp())
# 
# # Add some questions! These functions are specially designed to be used with
# # autocompletion on western English keyboards. Just type: `W` -> `Q` ->`Tab`
# # for a list of functions for adding types of questions.
# wq_message(output = "merhaba, bu materyal, R programlama dilini Türkçe 
#            bilen kullanıcalara tanıtmak için deneme amacıyla hazırlanmıştır. 
#            ekranda '...' gördüğünde, 'enter' tuşuna basarak ilerleyebilirsin")
# 
# wq_message(output = "R programlama dili, 2014 yılında, akademik makalelerde en çok kullanılan 3. yazılım olmuştur. Kaynak http://r4stats.com/articles/popularity/ . 
#            Birinciliği ele alacağı gün uzak olmasa gerek")
# 
# wq_message(output = "001 kodlu bu dersle R'in en temel işlemleri tanıtılacak")
# 
# wq_command(output="R'in en basit hali bir hesap makinesidir.
#            örneğin (3 + 5) in sonucu öğrenmek için lütfen 3 + 5 yaz ve enter tuşuna baş. ",
#            correct_answer= "3 + 5",
#            answer_tests = "omnitest(correctExpr='3 + 5')" ,
#            hint = "lütfen 3+5 yaz ve enter tuşuna baş")
# 
# wq_message(output = "farkettiysen 3+5 yazdığında R otomatik olarak [1] 8  sonucunu verdi ")
# 
# wq_command(output="devam edelim.lütfen (3 + 5)*(7 + 3)   yaz ve enter tuşuna baş. ",
#            correct_answer= "(3 + 5)*(7 + 3)",
#            answer_tests = "omnitest(correctExpr='(3 + 5)*(7 + 3)')" ,
#            hint = "dersin ilerleyebilmesi için lütfen istenilen eşitliği birebir gir. şimdi (3 + 5)*(7 + 3) yaz ve enter tuşuna baş")
# 
# wq_message(output = "gördüğün gibi, R doğru cevabı, yani 80 i hesapladı ")
# 
# wq_message(output = "hesap makinesi özelliğini, son bir karmaşık işlemle bitirelim ")
# 
# wq_command(output="25in karekökünü, 4un 3. kuvveti ile toplayıp, sinüs30 a bölelim, lütfen (sqrt(25)+(4^3))/sin(30) yaz ve enter tuşuna baş ",
#            correct_answer= "(sqrt(25)+(4^3))/sin(30)",
#            answer_tests = "omnitest(correctExpr='(sqrt(25)+(4^3))/sin(30)')" ,
#            hint = "dersin ilerleyebilmesi için lütfen istenilen eşitliği birebir gir.parantezlere dikkat et. şimdi (sqrt(25)+(4^3))/sin(30) yaz ve enter tuşuna baş")
# 
# wq_message(output = "R ile herhangi bir hesapmakinesinin yapabileceği her hesaplamayı yapabilirsin. Fakat R'i bu kadar popüler yapan özelliği bir hesapmakinesi olması değil. R bazı yabancı kaynaklarda 'R statistical computing envinroment' olarak isimlendirilir  ")
# 
# wq_message(output = "peki nedir environment? aslında günlük hayatta en çok kullanılan anlamı 'ÇEVRE', fakat bilgisayar dilinde 'ORTAM' olarak kullanılıyor")
# 
# wq_message(output = "eğer R studionun sağ üst köşesine bakarsanız, orda 'enviroment' sekmesini görebilirsiniz. Şu an muhtemelen boş. Artık R kullanmaya başladığınıza göre ortamı değiştirebiliriz")
# 
# wq_command(output="ilk olarak ortama sıradan bir sayı ekleyelim, örneğin , k. k sayısı, bir işlemin sonucu olarak ortama dahil olmuş olsun. örneğin, k <- 3+5 ",
#            correct_answer= "k <- 3+5",
#            answer_tests = "any_of_exprs('k <- 3+5', 'k <- 5+3')" ,
#            hint = "şimdi k <- 3+5 yaz ve enter tuşuna bas")
# 
# wq_message(output = "buradaki kilit operatör, '<-' k'nın ortama 3+5 olarak girdiğini gösteriyor" )
# 
# wq_command(output="şimdi ortama başka bir sayı daha ekleyelim. örneğin l <- 10  ",
#            correct_answer= "l <- 10",
#            answer_tests = "omnitest(correctExpr='l <- 10" ,
#            hint = "şimdi l <- 10 yaz ve enter tuşuna baş")
# 
# wq_message("artık ortamda iki tane eleman (element) var.biz bu elamanlarla işlemler yapabiliriz")
# 
# 
# wq_command(output=" k çarpı l nin 80 olduğunu gösterebilir misin? ",
#            correct_answer= "k*l",
#            answer_tests = "omnitest(correctExpr='k*l')" ,
#            hint = "k*l yaz ve enter tuşuna bas")
# 
# 
# 
# # Add your lesson to the MANİFEST so you can distribüte and test your new lesson
# add_to_manifest()
# 
# # After filling in the question templates make sure your lesson is formatted
# # correctly.
# test_lesson()
# 
# # Test your lesson ın swirl
# testit()
# 
# # Add a permissive license (because we love open source)
# add_license()
# 
# # If you're satisfied you can pack your new swirl course into a single file
# # and share it with the world!
# pack_course()



require(swirl)
select_language(language = "turkish" )
swirl()


