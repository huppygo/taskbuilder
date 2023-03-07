# 使用官方 CentOS 7 基础镜像
FROM centos:7

# 设置阿里云镜像源和 EPEL 源
RUN yum install -y wget && \
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
    yum makecache

# 导入 MySQL 公钥
RUN rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

# 安装必要的软件包和依赖
RUN yum -y update && \
    yum -y install perl libaio numactl net-tools vim

# 下载 MySQL 5.7 的 Yum Repository 配置文件
RUN wget https://repo.mysql.com/yum/mysql-5.7-community/docker/x86_64/mysql-community-server-minimal-5.7.35-1.el7.x86_64.rpm

# 安装 MySQL 5.7
RUN rpm -ivh mysql-community-server-minimal-5.7.35-1.el7.x86_64.rpm && \
    yum -y update && \
    yum -y install mysql-community-server

# 配置 MySQL
RUN mkdir /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql && \
    chmod 777 /var/lib/mysql && \
    echo "[mysqld]\nbind-address=0.0.0.0\n" >> /etc/my.cnf && \
    echo "skip-host-cache\nskip-name-resolve\n" >> /etc/my.cnf && \
    echo "default-storage-engine = innodb\ninnodb_file_per_table = 1\ninnodb_flush_log_at_trx_commit = 2\nsync_binlog = 0\n" >> /etc/my.cnf && \
    echo "character-set-server=utf8mb4\ncollation-server=utf8mb4_unicode_ci\n" >> /etc/my.cnf && \
    echo "skip-networking=0\n" >> /etc/my.cnf && \
    echo "skip-grant-tables\n" >> /etc/my.cnf

# 设置启动命令
CMD ["mysqld_safe"]
