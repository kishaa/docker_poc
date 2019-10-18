# Base OS layer: latest CentOS 7
FROM centos:7
MAINTAINER Kishan Agarwal

RUN yum -y update

# Setting username and license information
RUN export SA_PASSWORD=Anna@2606
RUN export MSSQL_PID=1
RUN export ACCEPT_EULA=Y

# Install latest mssql-server package
RUN curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo && \
     ACCEPT_EULA=Y curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/7/prod.repo 

# Installing/ Uninstalling required components
RUN yum remove -y unixODBC && \
    yum install -y mssql-server && \
    yum install -y mssql-tools && \
    yum install -y msodbcsql && \
    yum install -y unixODBC-devel && \
    yum clean all

#Create symlinks for tools
RUN ln -sfn /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd && \
    ln -sfn /opt/mssql-tools/bin/bcp /usr/bin/bcp

# Setting environment variable to use sqlcmd command
RUN 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
# Default SQL Server TCP/Port
EXPOSE 1433

# Starting SQL server
RUN /opt/mssql/bin/mssql-conf setup
