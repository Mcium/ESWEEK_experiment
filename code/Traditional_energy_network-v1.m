% Power_harvest1=xlsread('E:\matlab\ICCAD\energy\Piezo.xlsx');% power trace read
% Power_harvest=Power_harvest1(:,1);%注意power trace文件采集功率所在列可能不同

Power_harvest1=xlsread('E:\matlab\ICCAD\energy\TV-RF.xlsx');
Power_harvest=Power_harvest1(1:900,1);%注意power trace文件采集功率所在列可能不同

% Power_harvest1=xlsread('E:\matlab\ICCAD\energy\Thermal.xlsx');
% Power_harvest=Power_harvest1(:,1);%注意power trace文件采集功率所在列可能不同

%Power_harvest1=xlsread('E:\matlab\ICCAD\energy\WiFi-home.xlsx');
%Power_harvest=Power_harvest1(1:10000,4);%注意power trace文件采集功率所在列可能不同

% TV-RF Piezo Thermal WiFi-home WiFi-office

%不同能量的采样周期不一样，需要手动修改
%cyc_time=0.0001; % piezo采样周期
cyc_time=0.1; % TV-RF采样周期
% cyc_time=0.2; % Thermal采样周期
%cyc_time=0.2; % WiFi-home采样周期

% 4 cycles在一个power cycle执行的次数
%op_cycle=cyc_time/20e-9;
%------------------------------5层网络 PV每层的tile size和相关参数---------------------------------%
%Solution=xlsread('E:\matlab\ICCAD\networks\pv-piezo-tt.xlsx');
Solution=xlsread('E:\matlab\ICCAD\networks\pv-TVRF-tt.xlsx');
%Solution=xlsread('E:\matlab\ICCAD\networks\pv-thermal-tt.xlsx');
%----------PV网络参数------------%
PV_Conv1=[8,45,45];
PV_Conv2=[12,20,20];
PV_Conv3=[16,8,8];
PV_Conv4=[10,6,6];
PV_Conv5=[6,4,4];


%第一层tile size为最小时，第一层执行的次数(最小激活size 时钟周期 8cycles)
layer1_op_times=PV_Conv1(1)*PV_Conv1(2)*PV_Conv1(3);
%第二层tile size为最小时，，第二层执行的次数(最小激活size 时钟周期 12cycles)
layer2_op_times=PV_Conv2(1)*PV_Conv2(2)*PV_Conv2(3);
%第一层tile size为最小时，第一层执行的次数(最小激活size 时钟周期 12cycles)
layer3_op_times=PV_Conv3(1)*PV_Conv3(2)*PV_Conv3(3);
%第二层tile size为最小时，，第二层执行的次数(最小激活size 时钟周期 16cycles)
layer4_op_times=PV_Conv4(1)*PV_Conv4(2)*PV_Conv4(3);
%第一层tile size为最小时，第一层执行的次数(最小激活size 时钟周期 12cycles)
layer5_op_times=PV_Conv5(1)*PV_Conv5(2)*PV_Conv5(3);

%读取每一层的tile size参数
% Solution_layer1=Solution(1:6,:); %第一层tile size
% Solution_layer2=Solution(7:10,:); %第二层tile size
% Solution_layer3=Solution(11:13,:); %第三层tile size
% Solution_layer4=Solution(14:15,:); %第四层tile size
% Solution_layer5=Solution(16:19,:); %第五层tile size
% piezo
% Solution_layer1=Solution(1:7,:); %第一层tile size
% Solution_layer2=Solution(8:12,:); %第二层tile size
% Solution_layer3=Solution(13:16,:); %第三层tile size
% Solution_layer4=Solution(17:19,:); %第四层tile size
% Solution_layer5=Solution(20:24,:); %第五层tile size

Solution_layer1=Solution(1:29,:); %第一层tile size
Solution_layer2=Solution(30:46,:); %第二层tile size
Solution_layer3=Solution(47:57,:); %第三层tile size
Solution_layer4=Solution(58:66,:); %第四层tile size
Solution_layer5=Solution(67:88,:); %第五层tile size

% Solution_layer1=Solution(1:81,:); %第一层tile size
% Solution_layer2=Solution(82:161,:); %第二层tile size
% Solution_layer3=Solution(162:201,:); %第三层tile size
% Solution_layer4=Solution(202:241,:); %第四层tile size
% Solution_layer5=Solution(242:291,:); %第五层tile size
% 
% Solution_layer1=Solution(1:9,:); %第一层tile size
% Solution_layer2=Solution(10:17,:); %第二层tile size
% Solution_layer3=Solution(18:21,:); %第三层tile size
% Solution_layer4=Solution(22:25,:); %第四层tile size
% Solution_layer5=Solution(26:30,:); %第五层tile size


%所求参数
Power_search=Solution(:,3);
Solution_1=Solution(1,:);
[m_ph,n_ph]=size(Power_harvest);
Energy_efficiency=zeros(m_ph,1); %能效
Throughput_efficiency=zeros(m_ph,1); %吞吐率
Energy_utilization=zeros(m_ph,1); %能量利用率
Out=zeros(m_ph,4);
C=10; %电容
% 1e8/20=5e8

Power_search_layer1=Solution_layer1(:,3);%第一层tile size的功率
Power_search_layer2=Solution_layer2(:,3);%第二层tile size的功率
Power_search_layer3=Solution_layer3(:,3);%第三层tile size的功率
Power_search_layer4=Solution_layer4(:,3);%第四层tile size的功率
Power_search_layer5=Solution_layer5(:,3);%第五层tile size的功率

%最大size的位置
[layer1_rmax,layer1_cmax]=size(Solution_layer1);%第一层
[layer2_rmax,layer2_cmax]=size(Solution_layer2);%第二层
[layer3_rmax,layer3_cmax]=size(Solution_layer3);%第三层
[layer4_rmax,layer4_cmax]=size(Solution_layer4);%第四层
[layer5_rmax,layer5_cmax]=size(Solution_layer5);%第五层


Estore=0;

%-----PV 查询最大功率对应的最小转换效率和最小功率对应的最大转换效率,对于不同网络，该参数需要手动修改-----%
%----------------------------------------用于判断三种情况的参数---------------------------%
Psl_layer1=Solution_layer1(2,3)/(0.01*max(Solution_layer1(2,7:31)));
Psl_layer2=Solution_layer2(1,3)/(0.01*max(Solution_layer2(1,7:31)));
Psl_layer3=Solution_layer3(1,3)/(0.01*max(Solution_layer3(1,7:31)));
Psl_layer4=Solution_layer4(1,3)/(0.01*max(Solution_layer4(1,7:31)));
Psl_layer5=Solution_layer5(1,3)/(0.01*max(Solution_layer5(1,7:31)));

Psl_max=zeros(5,1);
Psl_max(1,1)=Psl_layer1;
Psl_max(2,1)=Psl_layer2;
Psl_max(3,1)=Psl_layer3;
Psl_max(4,1)=Psl_layer4;
Psl_max(5,1)=Psl_layer5;

Psl=max(Psl_max); %min 最小size对应最好的转换效率的功率

Pll_layer1=Solution_layer1(layer1_rmax,3)/(0.01*min(Solution_layer1(layer1_rmax,7:31)));
Pll_layer2=Solution_layer2(layer2_rmax,3)/(0.01*min(Solution_layer2(layer2_rmax,7:31)));
Pll_layer3=Solution_layer3(layer3_rmax,3)/(0.01*min(Solution_layer3(layer3_rmax,7:31)));
Pll_layer4=Solution_layer4(layer4_rmax,3)/(0.01*min(Solution_layer4(layer4_rmax,7:31)));
Pll_layer5=Solution_layer5(layer5_rmax,3)/(0.01*min(Solution_layer5(layer5_rmax,7:31)));

Pll_max=zeros(5,1);
Pll_max(1,1)=Pll_layer1;
Pll_max(2,1)=Pll_layer2;
Pll_max(3,1)=Pll_layer3;
Pll_max(4,1)=Pll_layer4;
Pll_max(5,1)=Pll_layer5;

Pll=max(Pll_max); %max 最大size对应最差的转换效率的功率

%----------------------------------------用于判断三种情况的参数---------------------------%

All_Operand_sum=0;
E_use_sum=0;
E_collect_sum=0;

V=0.48;
%用于判断执行到哪一层
layer1_count=0;
layer2_count=1;
layer3_count=1;
layer4_count=1;
layer5_count=1;
count_layer_times=0;

%-------------------test section---------------------%
%m_ph=10;
% layer1_rmax=2;
% layer2_rmax=1;
% layer3_rmax=1;
% layer4_rmax=1;
% layer5_rmax=1;

for i=1:m_ph
    
    P_harvest=Power_harvest(i,1)*(1e-6); % 当前cycle的Pload 单位W
    
    test_cnt=1;
    Cycle_cnt=0;
    Operand_sum=0;
    Power_Fullsize=0;
    Energy_use=0;
    Energy_collect=0;
    Energy_collect2=0;
    Energy_collect3=0;
    Power_present=0;
    Throughput_i=0;
    Throughput_c=0;
    t=0;%充电时间
    t_onecycle=0;
    t_count=0;%一个cycle的充电次数
    count_time=0;

    Max_Energy_consume=0;
    
    %------------------------- case 1 连续运行 ！！Full size的选择需要讨论！！--------------------------%
    if P_harvest >= Pll % case 1
        
        %选中的Tile size的时钟周期
        time_layer1_tile=Solution_layer1(layer1_rmax,1)/4*20e-9;
        time_layer2_tile=Solution_layer2(layer2_rmax,1)/4*20e-9;
        time_layer3_tile=Solution_layer3(layer3_rmax,1)/4*20e-9;
        time_layer4_tile=Solution_layer4(layer4_rmax,1)/4*20e-9;
        time_layer5_tile=Solution_layer5(layer5_rmax,1)/4*20e-9;
        while cyc_time>t_onecycle
            %第一层
            if layer1_count==0 %第一层执行条件
                Operand_sum=Operand_sum+(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));
         
                count_time=count_time+time_layer1_tile;
                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                else
                    Estore=Estore+P_harvest*time_layer1_tile;
                end
                t_onecycle=t_onecycle+time_layer1_tile;
                count_layer_times=count_layer_times+1*(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));
                %用于判断执行第一层还是第二层
                if  layer1_op_times<=count_layer_times
                    layer1_count=1;
                    layer2_count=0;
                    count_layer_times=0;
                end
            end
            %第二层
            if layer2_count==0 %第二层执行条件
                Operand_sum=Operand_sum+(Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));   
                count_time=count_time+time_layer2_tile;
                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                else
                    Estore=Estore+P_harvest*time_layer2_tile;
                end
                t_onecycle=t_onecycle+time_layer2_tile;
                count_layer_times=count_layer_times+1*(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));
                %用于判断执行第一层还是第二层
                if  layer2_op_times<=count_layer_times
                    layer2_count=1;
                    layer3_count=0;
                    count_layer_times=0;
                end
            end 
             %第三层
            if layer3_count==0 %第二层执行条件
                Operand_sum=Operand_sum+(Solution_layer3(layer3_rmax,4)*Solution_layer3(layer3_rmax,5)*Solution_layer3(layer3_rmax,6));   
                count_time=count_time+time_layer3_tile;
                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer3_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                else
                    Estore=Estore+P_harvest*time_layer3_tile;
                end
                t_onecycle=t_onecycle+time_layer3_tile;
                count_layer_times=count_layer_times+1*(Solution_layer3(layer3_rmax,5)*Solution_layer3(layer3_rmax,6));
                %用于判断执行第一层还是第二层
                if  layer3_op_times<=count_layer_times
                    layer3_count=1;
                    layer4_count=0;
                    count_layer_times=0;
                end
            end
             %第四层
            if layer4_count==0 %第二层执行条件
                Operand_sum=Operand_sum+(Solution_layer4(layer4_rmax,4)*Solution_layer4(layer4_rmax,5)*Solution_layer4(layer4_rmax,6));   
                count_time=count_time+time_layer4_tile;
                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer4_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                else
                    Estore=Estore+P_harvest*time_layer4_tile;
                end
                t_onecycle=t_onecycle+time_layer4_tile;
                count_layer_times=count_layer_times+1*(Solution_layer4(layer4_rmax,5)*Solution_layer4(layer4_rmax,6));
                %用于判断执行第一层还是第二层
                if  layer4_op_times<=count_layer_times
                    layer4_count=1;
                    layer5_count=0;
                    count_layer_times=0;
                end
            end
             %第五层
            if layer5_count==0 %第二层执行条件
                Operand_sum=Operand_sum+(Solution_layer5(layer5_rmax,4)*Solution_layer5(layer5_rmax,5)*Solution_layer5(layer5_rmax,6));   
                count_time=count_time+time_layer5_tile;
                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer5_tile)
                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                else
                    Estore=Estore+P_harvest*time_layer5_tile;
                end
                t_onecycle=t_onecycle+time_layer5_tile;
                count_layer_times=count_layer_times+1*(Solution_layer5(layer5_rmax,5)*Solution_layer5(layer5_rmax,6));
                %用于判断执行第一层还是第二层
                if  layer5_op_times<=count_layer_times
                    layer5_count=1;
                    layer1_count=0;
                    count_layer_times=0;
                end
            end
        end
        Energy_use=((Solution_layer1(layer1_rmax,3)+Solution_layer2(layer2_rmax,3))*cyc_time)/2;
        Energy_collect=P_harvest*cyc_time;
        %------------------------------ case 1 end --------------------------------%
   
   %----------------- case 2  连续执行或间歇执行 选择吞吐率执行方式较高的 --------------%
    elseif P_harvest >= Psl % 充放（间断）模型
    
        Trans_Efficiency_L1Fullsize=Solution_layer1(layer1_rmax,7:31);
        Trans_Efficiency_L2Fullsize=Solution_layer2(layer2_rmax,7:31);
        Trans_Efficiency_L3Fullsize=Solution_layer3(layer3_rmax,7:31);
        Trans_Efficiency_L4Fullsize=Solution_layer4(layer4_rmax,7:31);
        Trans_Efficiency_L5Fullsize=Solution_layer5(layer5_rmax,7:31);

        Trans_Efficiency_L1min=min(Trans_Efficiency_L1Fullsize);
        Trans_Efficiency_L2min=min(Trans_Efficiency_L2Fullsize);
        Trans_Efficiency_L3min=min(Trans_Efficiency_L3Fullsize);
        Trans_Efficiency_L4min=min(Trans_Efficiency_L4Fullsize);
        Trans_Efficiency_L5min=min(Trans_Efficiency_L5Fullsize);

        Power_L1Fullsize=Solution_layer1(layer1_rmax,3);
        Power_L2Fullsize=Solution_layer2(layer2_rmax,3);
        Power_L3Fullsize=Solution_layer3(layer3_rmax,3);
        Power_L4Fullsize=Solution_layer4(layer4_rmax,3);
        Power_L5Fullsize=Solution_layer5(layer5_rmax,3);
        
        Power_present1=Power_L1Fullsize/(Trans_Efficiency_L1min*0.01);
        Power_present2=Power_L2Fullsize/(Trans_Efficiency_L2min*0.01);
        Power_present3=Power_L3Fullsize/(Trans_Efficiency_L3min*0.01);
        Power_present4=Power_L4Fullsize/(Trans_Efficiency_L4min*0.01);
        Power_present5=Power_L5Fullsize/(Trans_Efficiency_L5min*0.01);
        
        Power_present_all=zeros(5,1);
        Power_present_all(1,1)=Power_present1;
        Power_present_all(2,1)=Power_present2;
        Power_present_all(3,1)=Power_present3;
        Power_present_all(4,1)=Power_present4;
        Power_present_all(5,1)=Power_present5;
        
        Power_present_max=max(Power_present_all);

        if P_harvest>=Power_present_max %连续执行
            
            time_layer1_tile=Solution_layer1(layer1_rmax,1)/4*20e-9;
            time_layer2_tile=Solution_layer2(layer2_rmax,1)/4*20e-9;
            time_layer3_tile=Solution_layer3(layer3_rmax,1)/4*20e-9;
            time_layer4_tile=Solution_layer4(layer4_rmax,1)/4*20e-9;
            time_layer5_tile=Solution_layer5(layer5_rmax,1)/4*20e-9;
            while cyc_time>t_onecycle
                %第一层
                if layer1_count==0 %第一层执行条件
                    Operand_sum=Operand_sum+(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));

                    count_time=count_time+time_layer1_tile;
                    if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
                        Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                    else
                        Estore=Estore+P_harvest*time_layer1_tile;
                    end
                    t_onecycle=t_onecycle+time_layer1_tile;
                    count_layer_times=count_layer_times+1*(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));
                    %用于判断执行第一层还是第二层
                    if  layer1_op_times<=count_layer_times
                        layer1_count=1;
                        layer2_count=0;
                        count_layer_times=0;
                    end
                end
                %第二层
                if layer2_count==0 %第二层执行条件
                    Operand_sum=Operand_sum+(Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));   
                    count_time=count_time+time_layer2_tile;
                    if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
                        Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                    else
                        Estore=Estore+P_harvest*time_layer2_tile;
                    end
                    t_onecycle=t_onecycle+time_layer2_tile;
                    count_layer_times=count_layer_times+1*(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));
                    %用于判断执行第一层还是第二层
                    if  layer2_op_times<=count_layer_times
                        layer2_count=1;
                        layer3_count=0;
                        count_layer_times=0;
                    end
                end 
                 %第三层
                if layer3_count==0 %第二层执行条件
                    Operand_sum=Operand_sum+(Solution_layer3(layer3_rmax,4)*Solution_layer3(layer3_rmax,5)*Solution_layer3(layer3_rmax,6));   
                    count_time=count_time+time_layer3_tile;
                    if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer3_tile)
                        Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                    else
                        Estore=Estore+P_harvest*time_layer3_tile;
                    end
                    t_onecycle=t_onecycle+time_layer3_tile;
                    count_layer_times=count_layer_times+1*(Solution_layer3(layer3_rmax,5)*Solution_layer3(layer3_rmax,6));
                    %用于判断执行第一层还是第二层
                    if  layer3_op_times<=count_layer_times
                        layer3_count=1;
                        layer4_count=0;
                        count_layer_times=0;
                    end
                end
                 %第四层
                if layer4_count==0 %第二层执行条件
                    Operand_sum=Operand_sum+(Solution_layer4(layer4_rmax,4)*Solution_layer4(layer4_rmax,5)*Solution_layer4(layer4_rmax,6));   
                    count_time=count_time+time_layer4_tile;
                    if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer4_tile)
                        Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                    else
                        Estore=Estore+P_harvest*time_layer4_tile;
                    end
                    t_onecycle=t_onecycle+time_layer4_tile;
                    count_layer_times=count_layer_times+1*(Solution_layer4(layer4_rmax,5)*Solution_layer4(layer4_rmax,6));
                    %用于判断执行第一层还是第二层
                    if  layer4_op_times<=count_layer_times
                        layer4_count=1;
                        layer5_count=0;
                        count_layer_times=0;
                    end
                end
                 %第五层
                if layer5_count==0 %第二层执行条件
                    Operand_sum=Operand_sum+(Solution_layer5(layer5_rmax,4)*Solution_layer5(layer5_rmax,5)*Solution_layer5(layer5_rmax,6));   
                    count_time=count_time+time_layer5_tile;
                    if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer5_tile)
                        Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                    else
                        Estore=Estore+P_harvest*time_layer5_tile;
                    end
                    t_onecycle=t_onecycle+time_layer5_tile;
                    count_layer_times=count_layer_times+1*(Solution_layer5(layer5_rmax,5)*Solution_layer5(layer5_rmax,6));
                    %用于判断执行第一层还是第二层
                    if  layer5_op_times<=count_layer_times
                        layer5_count=1;
                        layer1_count=0;
                        count_layer_times=0;
                    end
                end
            end
            
            Energy_use=((Solution_layer1(layer1_rmax,3)+Solution_layer2(layer2_rmax,3))*cyc_time)/2;
            Energy_collect=P_harvest*cyc_time;
        else %间歇执行
            flag=1;
            V_present=sqrt(2*Estore/(C*(1e-9)));
            Energy_collect=P_harvest*cyc_time;
            t_total=0;
            t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);
            if cyc_time>t
                while cyc_time>t_onecycle  % case 3 充放（间断）模型
                    % ---------------------判定是放电还是充放一起--------------------- %
                    if flag==0
                        Solution_1abs=abs(V-Solution_1);
                        [size_m,size_n]=find(Solution_1abs==min(Solution_1abs));%当前电压


                        Layer1_Trans_Efficiency=Solution_layer1(layer1_rmax,size_n);%当前电压第一层对应的转换效率
                        Layer2_Trans_Efficiency=Solution_layer2(layer2_rmax,size_n);%当前电压第二层对应的转换效率
                        Layer3_Trans_Efficiency=Solution_layer3(layer3_rmax,size_n);%当前电压第三层对应的转换效率
                        Layer4_Trans_Efficiency=Solution_layer4(layer4_rmax,size_n);%当前电压第四层对应的转换效率
                        Layer5_Trans_Efficiency=Solution_layer5(layer5_rmax,size_n);%当前电压第五层对应的转换效率

                        time_layer1_tile=Solution_layer1(layer1_rmax,1)/4*20e-9;
                        time_layer2_tile=Solution_layer2(layer2_rmax,1)/4*20e-9;
                        time_layer3_tile=Solution_layer3(layer3_rmax,1)/4*20e-9;
                        time_layer4_tile=Solution_layer4(layer4_rmax,1)/4*20e-9;
                        time_layer5_tile=Solution_layer5(layer5_rmax,1)/4*20e-9;

                        %每一层的能量消耗
                        %Energy_consume_layer1=(Solution_layer1i(layer1_trans_r,3)/(0.01*Trans_Efficiency_layer1_present))*time_layer1;
                        %Energy_consume_layer2=(Solution_layer2i(layer2_trans_r,3)/(0.01*Trans_Efficiency_layer2_present))*time_layer2;

                        Energy_consume_layer1_tile=(Solution_layer1(layer1_rmax,3)/(0.01*Layer1_Trans_Efficiency))*time_layer1_tile;
                        Energy_consume_layer2_tile=(Solution_layer2(layer2_rmax,3)/(0.01*Layer2_Trans_Efficiency))*time_layer2_tile;
                        Energy_consume_layer3_tile=(Solution_layer3(layer3_rmax,3)/(0.01*Layer3_Trans_Efficiency))*time_layer3_tile;
                        Energy_consume_layer4_tile=(Solution_layer4(layer4_rmax,3)/(0.01*Layer4_Trans_Efficiency))*time_layer4_tile;
                        Energy_consume_layer5_tile=(Solution_layer5(layer5_rmax,3)/(0.01*Layer5_Trans_Efficiency))*time_layer5_tile;

                        if layer1_count==0
                            Max_Energy_consume=Energy_consume_layer1_tile;
                        elseif layer2_count==0
                            Max_Energy_consume=Energy_consume_layer2_tile;
                        elseif layer3_count==0
                            Max_Energy_consume=Energy_consume_layer3_tile;
                        elseif layer4_count==0
                            Max_Energy_consume=Energy_consume_layer4_tile;
                        elseif layer5_count==0
                            Max_Energy_consume=Energy_consume_layer5_tile;
                        end

                        if Estore>=Max_Energy_consume %电容的存储的能量可以至少执行一层网络
                            if layer1_count==0 && Estore>=Energy_consume_layer1_tile
                                Operand_sum=Operand_sum+(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));
                                Energy_use=Energy_use+Energy_consume_layer1_tile;
                                Estore=Estore-Energy_consume_layer1_tile;
                                count_time=count_time+time_layer1_tile;
                                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
                                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                                else
                                    Estore=Estore+P_harvest*time_layer1_tile;
                                end
                                t_onecycle=t_onecycle+time_layer1_tile;
                                count_time= count_time+time_layer1_tile;
                                count_layer_times=count_layer_times+1*(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));
                                %用于判断执行第一层还是第二层
                                if  layer1_op_times<=count_layer_times
                                    layer1_count=1;
                                    layer2_count=0;
                                    count_layer_times=0;
                                end
                            end
                            if layer2_count==0 && Estore>=Energy_consume_layer2_tile
                                Operand_sum=Operand_sum+(Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));
                                Energy_use=Energy_use+Energy_consume_layer2_tile;
                                Estore=Estore-Energy_consume_layer2_tile;
                                count_time=count_time+time_layer2_tile;

                                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
                                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                                else
                                    Estore=Estore+P_harvest*time_layer2_tile;
                                end
                                t_onecycle=t_onecycle+time_layer2_tile;
                                count_time= count_time+time_layer2_tile;
                               count_layer_times=count_layer_times+1*(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));
                                %用于判断执行第一层还是第二层
                                if  layer2_op_times<=count_layer_times
                                    layer2_count=1;
                                    layer3_count=0;
                                    count_layer_times=0;
                                end
                            end
                            %第三层
                            if layer3_count==0 && Estore>=Energy_consume_layer3_tile
                                Operand_sum=Operand_sum+(Solution_layer3(layer3_rmax,4)*Solution_layer3(layer3_rmax,5)*Solution_layer3(layer3_rmax,6));
                                Energy_use=Energy_use+Energy_consume_layer3_tile;
                                Estore=Estore-Energy_consume_layer3_tile;
                                count_time=count_time+time_layer3_tile;

                                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer3_tile)
                                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                                else
                                    Estore=Estore+P_harvest*time_layer3_tile;
                                end
                                t_onecycle=t_onecycle+time_layer3_tile;
                                count_time= count_time+time_layer3_tile;
                                count_layer_times=count_layer_times+1*(Solution_layer3(layer3_rmax,5)*Solution_layer3(layer3_rmax,6));
                                %用于判断执行第一层还是第二层
                                if  layer3_op_times<=count_layer_times
                                    layer3_count=1;
                                    layer4_count=0;
                                    count_layer_times=0;
                                end
                            end
                            %第四层
                            if layer4_count==0 && Estore>=Energy_consume_layer4_tile
                                Operand_sum=Operand_sum+(Solution_layer4(layer4_rmax,4)*Solution_layer4(layer4_rmax,5)*Solution_layer4(layer4_rmax,6));
                                Energy_use=Energy_use+Energy_consume_layer4_tile;
                                Estore=Estore-Energy_consume_layer4_tile;
                                count_time=count_time+time_layer4_tile;

                                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer4_tile)
                                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                                else
                                    Estore=Estore+P_harvest*time_layer4_tile;
                                end
                                t_onecycle=t_onecycle+time_layer4_tile;
                                count_time= count_time+time_layer4_tile;
                                count_layer_times=count_layer_times+1*(Solution_layer4(layer4_rmax,5)*Solution_layer4(layer4_rmax,6));
                                %用于判断执行第一层还是第二层
                                if  layer4_op_times<=count_layer_times
                                    layer4_count=1;
                                    layer5_count=0;
                                    count_layer_times=0;
                                end
                            end
                            %第五层
                            if layer5_count==0 && Estore>=Energy_consume_layer5_tile
                                Operand_sum=Operand_sum+(Solution_layer5(layer5_rmax,4)*Solution_layer5(layer5_rmax,5)*Solution_layer5(layer5_rmax,6));
                                Energy_use=Energy_use+Energy_consume_layer5_tile;
                                Estore=Estore-Energy_consume_layer5_tile;
                                count_time=count_time+time_layer5_tile;

                                if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer5_tile)
                                    Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                                else
                                    Estore=Estore+P_harvest*time_layer5_tile;
                                end
                                t_onecycle=t_onecycle+time_layer5_tile;
                                count_time= count_time+time_layer5_tile;
                                count_layer_times=count_layer_times+1*(Solution_layer5(layer5_rmax,5)*Solution_layer5(layer5_rmax,6));
                                %用于判断执行第一层还是第二层
                                if  layer5_op_times<=count_layer_times
                                    layer5_count=1;
                                    layer1_count=0;
                                    count_layer_times=0;
                                end
                            end
                        elseif  Estore==(1/2*C*1e-9*0.48*0.48) && Estore<Max_Energy_consume 
                            
                            break;
                        end
                        V_up=sqrt(2*Estore/(C*(1e-9)));

                    else %充电
                        V_present=sqrt(2*Estore/(C*(1e-9)));
                        t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%充电时间
                        Estore=1/2*C*1e-9*0.48*0.48;%充电到0.48V电容的能量 
                        V_up=0.48;
                        V_down=0;
                    end
                    % --------------------- 充放电 end     --------------------- %
                    V=V_up-V_down;
                    if V>=0.24 && Estore>=Max_Energy_consume %放电判定
                        flag=0;
                    else %充电判定
                        flag=1;
                        t_total=t_total+t;%一个power cycle充电时间总和
                        t_onecycle=t_onecycle+t;%一个power cycle充电时间和执行时间总和
                        count_time=0;
                    end   
                end
            else
                Operand_sum=0;
                Energy_use=0;
                Estore=Estore+P_harvest*cyc_time;
            end
        end
    
    %--------------------------- case 3 ---------------------------------%
    elseif P_harvest > 0 %只能间歇执行 执行方式同 case 2 间歇执行方式
        flag=1;
        V_present=sqrt(2*Estore/(C*(1e-9)));
        Energy_collect=P_harvest*cyc_time;
        t_total=0;
        t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);
        if cyc_time>t
            while cyc_time>t_onecycle  % case 3 充放（间断）模型
                % ---------------------判定是放电还是充放一起--------------------- %
                if flag==0
                    Solution_1abs=abs(V-Solution_1);
                    [size_m,size_n]=find(Solution_1abs==min(Solution_1abs));%当前电压


                    Layer1_Trans_Efficiency=Solution_layer1(layer1_rmax,size_n);%当前电压第一层对应的转换效率
                    Layer2_Trans_Efficiency=Solution_layer2(layer2_rmax,size_n);%当前电压第二层对应的转换效率
                    Layer3_Trans_Efficiency=Solution_layer3(layer3_rmax,size_n);%当前电压第三层对应的转换效率
                    Layer4_Trans_Efficiency=Solution_layer4(layer4_rmax,size_n);%当前电压第四层对应的转换效率
                    Layer5_Trans_Efficiency=Solution_layer5(layer5_rmax,size_n);%当前电压第五层对应的转换效率

                    time_layer1_tile=Solution_layer1(layer1_rmax,1)/4*20e-9;
                    time_layer2_tile=Solution_layer2(layer2_rmax,1)/4*20e-9;
                    time_layer3_tile=Solution_layer3(layer3_rmax,1)/4*20e-9;
                    time_layer4_tile=Solution_layer4(layer4_rmax,1)/4*20e-9;
                    time_layer5_tile=Solution_layer5(layer5_rmax,1)/4*20e-9;

                    %每一层的能量消耗
                    %Energy_consume_layer1=(Solution_layer1i(layer1_trans_r,3)/(0.01*Trans_Efficiency_layer1_present))*time_layer1;
                    %Energy_consume_layer2=(Solution_layer2i(layer2_trans_r,3)/(0.01*Trans_Efficiency_layer2_present))*time_layer2;

                    Energy_consume_layer1_tile=(Solution_layer1(layer1_rmax,3)/(0.01*Layer1_Trans_Efficiency))*time_layer1_tile;
                    Energy_consume_layer2_tile=(Solution_layer2(layer2_rmax,3)/(0.01*Layer2_Trans_Efficiency))*time_layer2_tile;
                    Energy_consume_layer3_tile=(Solution_layer3(layer3_rmax,3)/(0.01*Layer3_Trans_Efficiency))*time_layer3_tile;
                    Energy_consume_layer4_tile=(Solution_layer4(layer4_rmax,3)/(0.01*Layer4_Trans_Efficiency))*time_layer4_tile;
                    Energy_consume_layer5_tile=(Solution_layer5(layer5_rmax,3)/(0.01*Layer5_Trans_Efficiency))*time_layer5_tile;

                    if layer1_count==0
                        Max_Energy_consume=Energy_consume_layer1_tile;
                    elseif layer2_count==0
                        Max_Energy_consume=Energy_consume_layer2_tile;
                    elseif layer3_count==0
                        Max_Energy_consume=Energy_consume_layer3_tile;
                    elseif layer4_count==0
                        Max_Energy_consume=Energy_consume_layer4_tile;
                    elseif layer5_count==0
                        Max_Energy_consume=Energy_consume_layer5_tile;
                    end

                    %if Estore>=Max_Energy_consume %电容的存储的能量可以至少执行一层网络
                    if layer1_count==0 && Estore>=Energy_consume_layer1_tile
                        Operand_sum=Operand_sum+(Solution_layer1(layer1_rmax,4)*Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));
                        Energy_use=Energy_use+Energy_consume_layer1_tile;
                        Estore=Estore-Energy_consume_layer1_tile;
                        if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer1_tile)
                            Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                        else                  
                            Estore=Estore+P_harvest*time_layer1_tile;
                        end
                        t_onecycle=t_onecycle+time_layer1_tile;
                        count_time= count_time+time_layer1_tile;
                        count_layer_times=count_layer_times+1*(Solution_layer1(layer1_rmax,5)*Solution_layer1(layer1_rmax,6));
                        %用于判断执行第一层还是第二层
                        if  layer1_op_times<=count_layer_times
                            layer1_count=1;
                            layer2_count=0;
                            count_layer_times=0;
                        end
                    end
                    if layer2_count==0 && Estore>=Energy_consume_layer2_tile
                        Operand_sum=Operand_sum+(Solution_layer2(layer2_rmax,4)*Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));
                        Energy_use=Energy_use+Energy_consume_layer2_tile;
                        Estore=Estore-Energy_consume_layer2_tile;
                        count_time=count_time+time_layer2_tile;

                        if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer2_tile)
                            Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                        else
                            Estore=Estore+P_harvest*time_layer2_tile;
                        end
                        t_onecycle=t_onecycle+time_layer2_tile;
                        count_time= count_time+time_layer2_tile;
                        count_layer_times=count_layer_times+1*(Solution_layer2(layer2_rmax,5)*Solution_layer2(layer2_rmax,6));
                        %用于判断执行第一层还是第二层
                        if  layer2_op_times<=count_layer_times
                            layer2_count=1;
                            layer3_count=0;
                            count_layer_times=0;
                        end
                    end
                    %第三层
                    if layer3_count==0 && Estore>=Energy_consume_layer3_tile
                        Operand_sum=Operand_sum+(Solution_layer3(layer3_rmax,4)*Solution_layer3(layer3_rmax,5)*Solution_layer3(layer3_rmax,6));
                        Energy_use=Energy_use+Energy_consume_layer3_tile;
                        Estore=Estore-Energy_consume_layer3_tile;

                        if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer3_tile)
                            Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                        else
                            Estore=Estore+P_harvest*time_layer3_tile;
                        end
                        t_onecycle=t_onecycle+time_layer3_tile;
                        count_time= count_time+time_layer3_tile;
                        count_layer_times=count_layer_times+1*(Solution_layer3(layer3_rmax,5)*Solution_layer3(layer3_rmax,6));
                        %用于判断执行第一层还是第二层
                        if  layer3_op_times<=count_layer_times
                            layer3_count=1;
                            layer4_count=0;
                            count_layer_times=0;
                        end
                    end
                    %第四层
                    if layer4_count==0 && Estore>=Energy_consume_layer4_tile
                        Operand_sum=Operand_sum+(Solution_layer4(layer4_rmax,4)*Solution_layer4(layer4_rmax,5)*Solution_layer4(layer4_rmax,6));
                        Energy_use=Energy_use+Energy_consume_layer4_tile;
                        Estore=Estore-Energy_consume_layer4_tile;

                        if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer4_tile)
                            Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                        else
                            Estore=Estore+P_harvest*time_layer4_tile;
                        end
                        t_onecycle=t_onecycle+time_layer4_tile;
                        count_time= count_time+time_layer4_tile;
                        count_layer_times=count_layer_times+1*(Solution_layer4(layer4_rmax,5)*Solution_layer4(layer4_rmax,6));
                        %用于判断执行第一层还是第二层
                        if  layer4_op_times<=count_layer_times
                            layer4_count=1;
                            layer5_count=0;
                            count_layer_times=0;
                        end
                    end
                    %第五层
                    if layer5_count==0 && Estore>=Energy_consume_layer5_tile
                        Operand_sum=Operand_sum+(Solution_layer5(layer5_rmax,4)*Solution_layer5(layer5_rmax,5)*Solution_layer5(layer5_rmax,6));
                        Energy_use=Energy_use+Energy_consume_layer5_tile;
                        Estore=Estore-Energy_consume_layer5_tile;

                        if (1/2*C*1e-9*0.48*0.48)<=(Estore+P_harvest*time_layer5_tile)
                            Estore=1/2*C*1e-9*0.48*0.48;%边放边充
                        else
                            Estore=Estore+P_harvest*time_layer5_tile;
                        end
                        t_onecycle=t_onecycle+time_layer5_tile;
                        count_time= count_time+time_layer5_tile;
                        count_layer_times=count_layer_times+1*(Solution_layer5(layer5_rmax,5)*Solution_layer5(layer5_rmax,6));
                        %用于判断执行第一层还是第二层
                        if  layer5_op_times<=count_layer_times
                            layer5_count=1;
                            layer1_count=0;
                            count_layer_times=0;
                        end
                    end
                    if  Estore==(1/2*C*1e-9*0.48*0.48) && Estore<Max_Energy_consume 
                        break;
                    end
                    

                else %充电
                    V_present=sqrt(2*Estore/(C*(1e-9)));
                    t=(C*1e-9*(0.48*0.48-V_present*V_present))/(2*P_harvest);%充电时间
                    Estore=1/2*C*1e-9*0.48*0.48;%充电到0.48V电容的能量 
                    V_up=0.48;
                    V_down=0;
                end
                % --------------------- 充放电 end     --------------------- %
                %V_up=sqrt(2*Estore/(C*(1e-9)));
                V=V_up-V_down;
                if V>=0.24 && Estore>=Max_Energy_consume %放电判定
                    flag=0;
                else %充电判定
                    flag=1;
                    t_total=t_total+t;%一个power cycle充电时间总和
                    t_onecycle=t_onecycle+t;%一个power cycle充电时间和执行时间总和
                    count_time=0;
                end   
            end
        else
            Operand_sum=0;
            Energy_use=0;
            Estore=Estore+P_harvest*cyc_time;
        end
    end
    %--------------------------- case 3 end ------------------------------%

    if P_harvest == 0
        Energy_efficiency(i,1)= 0;
        Throughput_efficiency(i,1)=0;
        Energy_utilization(i,1)=0;
    else
        if Energy_collect~=0 
            Energy_efficiency(i,1)= Operand_sum/Energy_collect;
        else 
            Energy_efficiency(i,1)=0;
        end
        Throughput_efficiency(i,1)=Operand_sum/cyc_time;
        if Energy_collect~=0 
            Energy_utilization(i,1)=Energy_use/Energy_collect;
        else 
            Energy_utilization(i,1)=0;
        end
        E_use_sum=E_use_sum+Energy_use;
        E_collect_sum=E_collect_sum+Energy_collect;
        All_Operand_sum=All_Operand_sum+Operand_sum;
    end
end

Energy_efficiency_final=All_Operand_sum/E_collect_sum;
Throughput_efficiency_final=All_Operand_sum/(cyc_time*m_ph);
Esum_uti=E_use_sum/E_collect_sum;
%Throughtput_average=All_Operand_sum/(cyc_time*m_ph);
%Energy_Effi_average=All_Operand_sum/E_use_sum;

Out(:,1)=Power_harvest(:,1);
Out(:,2)=Energy_efficiency;
Out(:,3)=Throughput_efficiency;
Out(:,4)=Energy_utilization;

%csvwrite('Tradi3_fr_Piezo.csv',Out);
%csvwrite('Tradi3_fr_TV-RF.csv',Out);
%csvwrite('Tradi3_fr_Thermal2.csv',Out);
%csvwrite('Tradi3_fr_WiFi-home.csv',Out);

% xlswrite('result_lenet.xls',Power_harvest(:,1),sheet1,'A2');
% xlswrite('result_lenet.xls',Energy_efficiency,sheet1,'B2');
% xlswrite('result_lenet.xls',Throughput_efficiency,sheet1,'C2');
% xlswrite('result_lenet.xls',Energy_utilization,sheet1,'D2');