clear;
clc;
warning off;
close all;
%% ��Excel����ж�ȡ����
female = xlsread('�˿����������.xls',1,'D7:D126'); %2010��������Ů���˿�����
rsex = xlsread('�˿����������.xls',1,'H7:H126'); %2010���������Ա�ȣ�Ů=100����������
death = xlsread('�����.xls',1,'J8:J127'); %2010�������������ʣ�ǧ��֮��λ
%% �������ж�ȡ������Ů���˿�����Ů���˿ڱ����ʹ����
j = 1;
for i=1:1:length(female)
    if mod(i-1,6) ~= 0
        x(j,1) = female(i)/1e8;
        w(j,1) = 100/(rsex(i)+100);
        s(j,1) = 1-death(i)/1000;
        j = j+1;
    end
end
%% �ܺ�������
b1(1:15,1) = 0; %0-14��
b1(16:50,1) = 1.6/35; %15-49�꣬��������
b1(51:100,1) = 0; %50-100��

b2(1:15,1) = 0; %0-14��
b2(16:50,1) = 1.8/35; %15-49��,��̥����
b2(51:100,1) = 0; %50-100��
%% ����Leslie�˿�Ԥ��ģ����Leslie����
L1 = zeros(100); %��������
for i=1:1:length(b1)
    L1(1,i) = w(i)*b1(i);
    if i ~= length(b1)
        L1(i+1,i) = s(i);
    end
end

L2 = zeros(100); %��̥����
for i=1:1:length(b2)
    L2(1,i) = w(i)*b2(i);
    if i ~= length(b2)
        L2(i+1,i) = s(i);
    end
end
%% Ԥ��ÿ���Ů���˿�����
t(1,1) = 2010; %������ʼ��
period = 25; %Ԥ������
x1 = x;
x2 = x;
for i=2:1:period+1
    t(i,1) = 2010+i-1;
    x1(:,i) = L1*x1(:,i-1); %��������
    if t<2016
        x2(:,i) = L1*x2(:,i-1);
    else
        x2(:,i) = L2*x2(:,i-1); %��̥����       
    end
end
%% ת�������˿�����
X1 = x1./w; %��������
X2 = x2./w; %��̥����
%% �����д��Excel�ļ�
filename = ['2010���˿��ղ��',num2str(period),'���˿�Ԥ��.xlsx'];
name = {'����/���'};
% ��������sheet����
sheet = '��������';
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
% ��̥����sheet����
sheet = '��̥����';
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
%% ��ͼ
figure(1)
hold on;
box on;
grid on;
plot(t,sum(X1,1),'r+');
plot(t,sum(X2,1),'bo');
xlabel('���');
ylabel('�������˿�(����)');
legend({'��������','��̥����'});

figure(2)
hold on;
box on;
grid on;

yyaxis left;
plot(t,sum(X1,1),'+');
ylim([11 15]);
ylabel('�������߸���������˿�(����)');

yyaxis right
plot(t,sum(X2,1),'o');
ylim([1 15]);
ylabel('��̥���߸���������˿�(����)');
xlabel('���');

figure(3)
subplot(2,2,1)
hold on;
box on;
grid on;
plot(t,sum(X1,1),'r+');
plot(t,sum(X2,1),'bo');
xlim([2010 2035]);
xlabel('���');
ylabel('����������˿�(����)');
legend({'��������','��̥����'});

subplot(2,2,2)
hold on;
box on;
grid on;
plot(t,sum(X1(1:15,:),1),'r+');
plot(t,sum(X2(1:15,:),1),'bo');
xlim([2010 2035]);
xlabel('���');
ylabel('0-14����������˿�(����)');
legend({'��������','��̥����'});

subplot(2,2,3)
hold on;
box on;
grid on;
plot(t,sum(X1(16:65,:),1),'r+');
plot(t,sum(X2(16:65,:),1),'bo');
xlim([2010 2035]);
xlabel('���');
ylabel('15-64����������˿�(����)');
legend({'��������','��̥����'});

subplot(2,2,4)
hold on;
box on;
grid on;
plot(t,sum(X1(66:end,:),1),'r+');
plot(t,sum(X2(66:end,:),1),'bo');
xlim([2010 2035]);
xlabel('���');
ylabel('65�꼰������������˿�(����)');
legend({'��������','��̥����'});
