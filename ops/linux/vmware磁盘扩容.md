## 磁盘扩展方式
### 1.虚拟机扩展磁盘
选中虚拟机，设置中配置     
![image](https://github.com/user-attachments/assets/ceac9b6a-2380-4ebe-a62e-f86f8d803a09)


### 2.分区扩容
```
fdisk /dev/sda
d #删除分区
2 #分区号
n #创建分区
p #分区类型
2 #分区号
回车 #分区的起始扇区
回车  
w #保存
```
### 3.更新内核分区信息
```
partprobe
```
### 4.扩展物理卷
```
pvresize /dev/sda2
```
### 5.扩展逻辑卷
```
lvextend -l +100%FREE /dev/centos/root
```
### 6.扩展文件系统
```
xfs_growfs /
```

## 新增磁盘
### 1.虚拟机新增磁盘
### 2.创建分区
```
fdisk /dev/sdb
```
### 3.创建物理卷（PV）
```
pvcreate /dev/sdb1
```
### 4.扩展卷组（VG）
```
vgextend centos /dev/sdb1
```
### 5.扩展逻辑卷（LV）
```
lvextend -l +100%FREE /dev/centos/root
```
### 6.扩展文件系统
```
xfs_growfs /dev/centos/root
```

## 新增磁盘挂载
### 1.虚拟机新增磁盘
### 2.创建分区
```
fdisk /dev/sdb
```
### 3.创建物理卷（PV）
```
pvcreate /dev/sdb1
```
### 4.新增卷组（VG）
```
vgcreate data /dev/sdb1
```
### 5.新增逻辑卷（LV）
```
lvcreate -l +100%FREE -n 1 data
```
### 6.格式化
```
mkfs.xfs /dev/data/1
```

