#! /bin/bash
#此腳本程式用於自動設定 定時回報IP功能。
read -p "選擇你的郵件伺服器(1.gmail 2.yahoo 3.other):" mailserveroption
if [ ${mailserveroption} = "1" ]
then
    mailserver=smtp.gmail.com
elif [ ${mailserveroption} = "2" ]
then 
    mailserver=smtp.mail.yahoo.com
else
    echo "檢查你的郵件伺服器 port!!!"
    echo "如果port 不是 587,請再程式執行後敲以下指令設定"
    echo ">sudo su"
    echo ">nano /root/rootcrons/reportip.py"
    echo "第33行 -> smtp.connect(smtpserver,587)，587改成你的Mail server port。"
    read -p "你的郵件伺服器:" mailserver
fi
read -p "請輸入 發送 通知信箱 帳號（需允許低安全性應用程式存取權）:" mailuname
read -p "請輸入 發送 通知信箱 密碼:" mailpw
read -p "請輸入 接受 通知信箱 帳號:" remail

echo ">>更新中..."
sudo apt-get upadte
sudo apt-get install git -y
sudo chmod 777 /root

echo ">>下載程式中..."
git clone https://github.com/laixintao/Report-IP-hourly.git /root/rootcrons/

echo ">>修改程式中.."
sed -i "s/(smtpserver)/(smtpserver,587)/g" /root/rootcrons/reportip.py
sed -i "65c \            myip = self.visit(\"http://myip.com.tw\")" /root/rootcrons/reportip.py
sed -i "68c \                myip = self.visit(\"http://cmp.nkuht.edu.tw/info/ip.asp\")" /root/rootcrons/reportip.py
sed -i "71c \                    myip = self.visit(\"http://dir.twseo.org/ip-check.php\")" /root/rootcrons/reportip.py
sed -i "38a \    smtp.ehlo()" /root/rootcrons/reportip.py
sed -i '39a \    smtp.starttls()' /root/rootcrons/reportip.py
sed -i '40a \    smtp.ehlo()' /root/rootcrons/reportip.py
sed -i "s/smtp.sina.com/${mailserver}/g" /root/rootcrons/reportip.py
sed -i "s/reaspberrypi@sina.com/${mailuname}/g" /root/rootcrons/reportip.py
sed -i "s/123456/${mailpw}/g" /root/rootcrons/reportip.py
sed -i "s/receiver@sina.com/${mailuname}/g" /root/rootcrons/reportip.py
sed -i "s/master@sina.com/${remail}/g" /root/rootcrons/reportip.py

echo ">>修改設定檔中.."
sed -i "2c */5 * * * * /usr/bin/python /root/rootcrons/reportip.py" /root/rootcrons/rootcron
sudo crontab /root/rootcrons/rootcron
sudo /etc/init.d/cron restart

sudo chmod 700 /root
echo "完成！請檢查你的信箱！！！"
