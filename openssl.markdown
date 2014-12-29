
## 生成钥匙对

    # 生成 RSA 密钥
    openssl genrsa  -out rsa1024.pri  1024
    
    # 从密钥中提取公钥
    openssl rsa  -pubout  -in rsa1024.pri  -out rsa1024.pub

## 使用钥匙对

    # 公钥加密
    openssl rsautl -encrypt  -inkey rsa1024.pub -pubin  -in origin.txt  -out en_pub_1024
    # 私钥解密
    openssl rsautl -decrypt  -inkey rsa1024.pri         -in en_pub_1024  -out de_pri_1024
    
    # 私钥加密
    openssl rsautl -encrypt  -inkey rsa1024.pri  -in origin.txt  -out en_pri_1024
    # 私钥解密
    openssl rsautl -decrypt  -inkey rsa1024.pub  -in en_pri_1024  -out de_pub_1024

http://blog.iamzsx.me/show.html?id=155002


openssl req -x509 -out public.der -outform der -new -newkey rsa:1024 -keyout private.pem -days 3650

openssl x509 -inform DER -in public.der -out private.cer

openssl pkcs12 -export -in private.cer -inkey private.pem -out abc.pfx
