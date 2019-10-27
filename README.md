# Intelligent_Algorithm
用matlab解决路径规划和竞争设施选址问题

一、五个基础算法以及示例：

ga  遗传算法解决分配问题

	问题描述：
	现有10个工人去做10件工作，每个工人完成每项工作所需时间不同。
	要求每个工人只做一项工作，每项工作只由一个工人完成。
	怎样指派工人完成工作可以使所用总时间最少？
tabu 禁忌搜索算法解决解决商旅问题

	问题描述：
	某5个城市旅行商问题，
	用禁忌搜索算法实使得旅行商走过所有城市后回到原点的总路径最小。

ants 蚁群算法

	问题描述：
	设有19个客户随机分布于长为10km的正方形区域内。配送中心位于区域正中央，其坐标为（0，0）。
	各客户的坐标及需求量如下表所示，配送中心拥有若干辆载重量为9t的车辆，对客户进行服务时都从配送中心出发，
	完成对客户点的配送任务后再回到配送中心。现要求以最少的车辆数、最小的车辆总行程来完成货物的派送任务，
	用蚁群算法求解该VRP问题(vehicle routing problem)。	
SA  模拟退火算法

	问题描述：
	n 个工作将要指派给n 个工人分别完成，问如何安排可使总的工作时间达到最小
PSO 粒子群算法

	问题描述：
	在一范围为(0,0)到(100，100)的矩形区域内，散布着40个连锁超市。要求在该矩形区域内确定9个位置建立配送中心。
	已知各配送中心容量不限，每个超市只由一个配送中心负责配送，使得9个配送中心到所有超市的总配送物流量（距
	离×需求量）最小，其中配送中心到超市的距离为直线距离。
	
二、竞争设施选址问题相关论文以及代码复现：

论文一：

	Qi M.Y., Xia M.F., Zhang Y., Miao L.X. Competitive facility location problem with foresight considering 
	service distance limitations[J]. Computers & Industrial Engineering, 2017; 112:483-491.

	在只有两个竞争设施的情况下，存在一个领导者和一个跟随者，领导者在潜在位点先放置设施，跟随者根据领导者的选址情况选择新的设施点。在领导者知道追随者目标函数的情况下如何设置选址位点是论文研究的重点。

	思路：采用了双层禁忌搜索算法，将追随者当前最优解放入领导者可交换的备选位点中，将领导者当前位点与备选位点邻域交换，生成新解进行下一轮求解。

	代码：leader_follower.m

	算例：随机生成

论文二：

	Fernández P., Pelegrín B., Lančinskas A., Žilinskas J. New heuristic algorithms for discrete competitive location problems with binary and partially binary customer behavior[J]. Computers & Operations Research,2017; 79: 12-18.

	市场中已经存在两个以上的竞争公司，每个公司都有相应数量的现有设施，现在有一家新的公司要进入市场，如何选择新设施位点使得新进入公司获得的市场份额最大是该论文研究的重点

	思路：基于排名的离散优化算法
	代码：partially_binary.m
	算例：http://www.tageo.com/index-e-sp-cities-ES.htm

三、在已知高程数据的情况下画高程图：

	代码：Elevation_map.m	

	高程数据：Elevation_data.xlsx	