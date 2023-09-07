import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import BP
from sklearn import metrics
from sklearn.metrics import mean_absolute_error
from sklearn.metrics import mean_squared_error
from sklearn import preprocessing

df1 = pd.read_excel('育龄妇女数.xls',0)
df1 = df1.iloc[:, 1:3]
print(df1)
# print(df1)
# # 进行数据归一化
# min_max_scaler = preprocessing.MinMaxScaler()  # MinMaxScaler方法默认是对每一列做这样的归一化操作
# df0 = min_max_scaler.fit_transform(df1)
# print(df1.iloc[:20, -1])
# print(df1.iloc[:20, :-1])
# 进行数据归一化
# min_max_scaler = preprocessing.MinMaxScaler()  # MinMaxScaler方法默认是对每一列做这样的归一化操作
# df0 = min_max_scaler.fit_transform(df1)
# df = pd.DataFrame(df0, columns=df1.columns)
# x = df.iloc[:20, -1]   # 输入变量
# y = df.iloc[:, :-1]    # 预测变量
# print(df1.iloc[:20, -1])
# print(y)

# # 划分训练集测试集
# cut = 4  # 20%数据为测试集
# x_train, x_test = x.iloc[:-cut], x.iloc[-cut:]  # 列表的切片操作，X.iloc[0:2400，0:7]即为1-2400行，1-7列
# y_train, y_test = y.iloc[:-cut], y.iloc[-cut:]
# x_train, x_test = x_train.values, x_test.values
# y_train, y_test = y_train.values, y_test.values
#
# # print(x)
# # print(y)
# bp1 = BP.BPNNRegression([3, 16, 1])
# bp1 = BP.BPNNRegression([3, 16, 1])
# train_data = [[sx.reshape(3, 1), sy.reshape(1, 1)] for sx, sy in zip(x_train, y_train)]
# print(train_data)