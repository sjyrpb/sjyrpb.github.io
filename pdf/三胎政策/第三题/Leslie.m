clear;
clc;
warning off;
close all;
%% 从Excel表格中读取数据
female = xlsread('人口数量与比例.xls',1,'D7:D126'); %2010年各年龄段女性人口数量
rsex = xlsread('人口数量与比例.xls',1,'H7:H126'); %2010年各年龄段性别比，女=100的男性数量
death = xlsread('存活率.xls',1,'J8:J127'); %2010年各年龄段死亡率，千分之单位
%% 从数据中读取各年龄女性人口数、女性人口比例和存活率
j = 1;
for i=1:1:length(female)
    if mod(i-1,6) ~= 0
        x(j,1) = female(i)/1e8;
        w(j,1) = 100/(rsex(i)+100);
        s(j,1) = 1-death(i)/1000;
        j = j+1;
    end
end
%% 总和生育率
b1(1:15,1) = 0; %0-14岁
b1(16:50,1) = 1.6/35; %15-49岁，现有政策
b1(51:100,1) = 0; %50-100岁

b2(1:15,1) = 0; %0-14岁
b2(16:50,1) = 1.8/35; %15-49岁,三胎政策
b2(51:100,1) = 0; %50-100岁
%% 计算Leslie人口预测模型中Leslie矩阵
L1 = zeros(100); %现有政策
for i=1:1:length(b1)
    L1(1,i) = w(i)*b1(i);
    if i ~= length(b1)
        L1(i+1,i) = s(i);
    end
end

L2 = zeros(100); %三胎政策
for i=1:1:length(b2)
    L2(1,i) = w(i)*b2(i);
    if i ~= length(b2)
        L2(i+1,i) = s(i);
    end
end
%% 预测每年的女性人口数量
t(1,1) = 2010; %数据起始年
period = 25; %预测年数
x1 = x;
x2 = x;
for i=2:1:period+1
    t(i,1) = 2010+i-1;
    x1(:,i) = L1*x1(:,i-1); %现有政策
    if t<2016
        x2(:,i) = L1*x2(:,i-1);
    else
        x2(:,i) = L2*x2(:,i-1); %三胎政策       
    end
end
%% 转换成总人口数量
X1 = x1./w; %现有政策
X2 = x2./w; %三胎政策
%% 将结果写入Excel文件
filename = ['2010年人口普查后',num2str(period),'年人口预测.xlsx'];
name = {'年龄/年份'};
% 现有政策sheet数据
sheet = '现有政策';
xlRange = 'A1';
xlswrite(filename,name,sheet,xlRange);
rowname = [0:1:99]';
xlRange = 'A2';
xlswrite(filename,rowname,sheet,xlRange);
colname = 2010:1:period+2010;
xlRange = 'B1';
xlswrite(filename,colname,sheet,xlRange);
xlRange = 'B2';
xlswrite(filename,X1,sheet,xlRange);
% 二胎政策sheet数据
sheet = '三胎政策';
xlRange = 'A1';
xlswrite(filename,name,sheet,xlRange);
rowname = [0:1:99]';
xlRange = 'A2';
xlswrite(filename,rowname,sheet,xlRange);
colname = 2010:1:period+2010;
xlRange = 'B1';
xlswrite(filename,colname,sheet,xlRange);
xlRange = 'B2';
xlswrite(filename,X2,sheet,xlRange);
%% 画图
figure(1)
hold on;
box on;
grid on;
plot(t,sum(X1,1),'r+');
plot(t,sum(X2,1),'bo');
xlabel('年份');
ylabel('各年总人口(亿人)');
legend({'现有政策','三胎政策'});

figure(2)
hold on;
box on;
grid on;

yyaxis left;
plot(t,sum(X1,1),'+');
ylim([11 15]);
ylabel('现有政策各年龄层总人口(亿人)');

yyaxis right
plot(t,sum(X2,1),'o');
ylim([1 15]);
ylabel('三胎政策各年龄层总人口(亿人)');
xlabel('年份');

figure(3)
subplot(2,2,1)
hold on;
box on;
grid on;
plot(t,sum(X1,1),'r+');
plot(t,sum(X2,1),'bo');
xlim([2010 2035]);
xlabel('年份');
ylabel('各年龄层总人口(亿人)');
legend({'现有政策','三胎政策'});

subplot(2,2,2)
hold on;
box on;
grid on;
plot(t,sum(X1(1:15,:),1),'r+');
plot(t,sum(X2(1:15,:),1),'bo');
xlim([2010 2035]);
xlabel('年份');
ylabel('0-14岁年龄层总人口(亿人)');
legend({'现有政策','三胎政策'});

subplot(2,2,3)
hold on;
box on;
grid on;
plot(t,sum(X1(16:65,:),1),'r+');
plot(t,sum(X2(16:65,:),1),'bo');
xlim([2010 2035]);
xlabel('年份');
ylabel('15-64岁年龄层总人口(亿人)');
legend({'现有政策','三胎政策'});

subplot(2,2,4)
hold on;
box on;
grid on;
plot(t,sum(X1(66:end,:),1),'r+');
plot(t,sum(X2(66:end,:),1),'bo');
xlim([2010 2035]);
xlabel('年份');
ylabel('65岁及以上年龄层总人口(亿人)');
legend({'现有政策','三胎政策'});
