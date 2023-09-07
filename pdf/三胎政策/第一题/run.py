import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import BP
from sklearn import metrics
from sklearn.metrics import mean_absolute_error
from sklearn.metrics import mean_squared_error
from sklearn import preprocessing
# 导入必要的库

df1 = pd.read_excel('多个变量预测.xls', 0)
df1 = df1.iloc[:, 1:]
print(df1.shape)
# 进行数据归一化
min_max_scaler = preprocessing.MinMaxScaler()
df0 = min_max_scaler.fit_transform(df1)
df = pd.DataFrame(df0, columns=df1.columns)
x = df.iloc[:, :-1]   # 1980-2035
y = df.iloc[:, -1]    # 2021-2035

# 划分训练集测试集
cut = 15    # 41， 一共56
x_train, x_test = x.iloc[:-cut], x.iloc[-cut:]
y_train, y_test = y.iloc[-cut:], y.iloc[-cut:]
x_train, x_test = x_train.values, x_test.values
y_train, y_test = y_train.values, y_test.values

'''
x_train: 1980-2020 7个变量
Y_train: 2021-2035 7个变量
x_test:  2021-2035灰度预测的人口数
Y_test:  2021-2035灰度预测的人口数(只是用来计算误差)
'''

# 神经网络搭建
bp1 = BP.BPNNRegression([8, 16, 1])
train_data = [[sx.reshape(8, 1), sy.reshape(1, 1)] for sx, sy in zip(x_train, y_train)]
test_data = [np.reshape(sx, (8, 1)) for sx in x_test]

# 神经网络训练
bp1.MSGD(train_data, 60000, len(train_data)-6, 0.09)

# 神经网络预测
y_predict = bp1.predict(test_data)
y_pre = np.array(y_predict)  # 列表转数组
y_pre = y_pre.reshape(15, 1)
y_pre = y_pre[:, 0]

# 反归一化
df0[0:15, -1] = y_pre

a = min_max_scaler.inverse_transform(df0)

# 可视化，展示在测试集上的表现
plt.rcParams['font.sans-serif'] = ['SimHei']  # 使标题乱码变为中文
plt.figure(figsize=(8, 4))
plt.title('时间与总人口',  # 标题字体比坐标轴更大些
         fontsize = 20)
plt.xlabel('时间',fontsize=15)
plt.ylabel('总人口',fontsize=15)
plt.plot([i+2007 for i in list(range(15))], a[0:15,-1],color = 'blue')
plt.plot([i+2007 for i in list(range(15))], a[-15:,-1],color = 'red')
plt.legend(labels=['预测', '真实'])
plt.show()

predict_population = a[0:15, -1]
print(predict_population)

# 输出精度指标
print('测试集上的MAE/MSE/RMSE：')
print('平均绝对误差:', mean_absolute_error(y_pre, y_test))
print('均方误差(损失函数):', mean_squared_error(y_pre, y_test))
print('均方根误差:', mean_squared_error(y_pre, y_test)**0.5)
mape = np.mean(np.abs((y_pre-y_test)/(y_test))*100)
print('MAPE = ', mape, '%')
# 画出真实数据和预测数据的对比曲线图
print("R2 = ", metrics.r2_score(y_test, y_pre))