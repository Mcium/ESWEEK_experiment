%离线计算吞吐率

cyc_time=0.1; % piezo采样周期
%电容值
C=10;
%tile size,V,eta
Solution=xlsread('E:\matlab\ICCAD\networks\fr-TVRF-tt.xlsx');
%Solution=xlsread('E:\matlab\ICCAD\networks\tv-rf\hg-TVRF-tt.xlsx');
%Solution=xlsread('E:\matlab\ICCAD\networks\pv-Thermal-tt.xlsx');

V_pos=31;   %7-31
%能级，能级最低能量
Power_level=zeros(10,2);
%piezo
% Power_level(1,1)=1;
% Power_level(1,2)=1;
% 
% Power_level(2,1)=2;
% Power_level(2,2)=100;
% 
% Power_level(3,1)=3;
% Power_level(3,2)=200;
% 
% Power_level(4,1)=4;
% Power_level(4,2)=300;
% 
% Power_level(5,1)=5;
% Power_level(5,2)=400;
% 
% Power_level(6,1)=6;
% Power_level(6,2)=500;
% 
% Power_level(7,1)=7;
% Power_level(7,2)=600;
% 
% Power_level(8,1)=8;
% Power_level(8,2)=700;
% 
% Power_level(9,1)=9;
% Power_level(9,2)=800;
% 
% Power_level(10,1)=10;
% Power_level(10,2)=900;

%tvrf
Power_level(1,1)=1;
Power_level(1,2)=1;

Power_level(2,1)=2;
Power_level(2,2)=2000;

Power_level(3,1)=3;
Power_level(3,2)=4000;

Power_level(4,1)=4;
Power_level(4,2)=6000;

Power_level(5,1)=5;
Power_level(5,2)=8000;

Power_level(6,1)=6;
Power_level(6,2)=10000;

Power_level(7,1)=7;
Power_level(7,2)=12000;

Power_level(8,1)=8;
Power_level(8,2)=14000;

Power_level(9,1)=9;
Power_level(9,2)=16000;

Power_level(10,1)=10;
Power_level(10,2)=18000;

% Power_level(1,1)=1;
% Power_level(1,2)=1;
% 
% Power_level(2,1)=2;
% Power_level(2,2)=300;
% 
% Power_level(3,1)=3;
% Power_level(3,2)=600;
% 
% Power_level(4,1)=4;
% Power_level(4,2)=900;
% 
% Power_level(5,1)=5;
% Power_level(5,2)=1200;
% 
% Power_level(6,1)=6;
% Power_level(6,2)=1500;
% 
% Power_level(7,1)=7;
% Power_level(7,2)=1800;
% 
% Power_level(8,1)=8;
% Power_level(8,2)=2100;
% 
% Power_level(9,1)=9;
% Power_level(9,2)=2400;

% Power_level(10,1)=10;
% Power_level(10,2)=2700;

[m_ts,n_ts]=size(Solution);
[m_pl,n_pl]=size(Power_level);

Throughput_efficiency=zeros(m_pl*(m_ts-1),1); 

for i=2:m_ts % 遍历tile size
    
    for j=1:m_pl  %遍历能级
        P_harvest=Power_level(j,2)*(1e-6);
        Ops=0;
        
        P_present=Solution(i,3)/(Solution(i,V_pos)*0.01);
        if P_harvest>=P_present %连续执行的吞吐率
            Ops_times=cyc_time/(Solution(i,1)*5e-9);
            Ops=Solution(i,4)*Solution(i,5)*Solution(i,6)*Ops_times;
            Throughput_efficiency(j+10*(i-2),1)=Ops/cyc_time;
        else  %间歇执行的吞吐率
            flag=1; %充电和放电判断参数
            Estore=0;
            t_onecycle=0; %充电时间+执行时间
            charge_flag=0;%一个cycle第一次
            t_total=0; %一个power cycle充电时间总和
            %间歇执行采集的能量
            
            V_present=0;%当前电容的电压值
            t=(C*1e-9*(Solution(1,V_pos)*Solution(1,V_pos)-V_present*V_present))/(2*P_harvest);%充电时间
            working_cycle_time1=0;
            working_cycle_time2=0;
            working_cycle_ops_i=0;
            Energy_consume_tile=0;
            if cyc_time>t %如果充电时间大于采样时间，则进入下一个power cacle
                while cyc_time>t_onecycle % 如果充放电时间超过采样时间，则进入下一个power cacle
                    % ---------------------判定是放电还是放电--------------------- %
                    if flag==0

                        Solution_Effi=Solution(i,V_pos);%当前电压第一层对应的转换效率

                        time_tile=Solution(i,1)/4*20e-9;
                        
                        Energy_consume_tile=(Solution(i,3)/(0.01*Solution_Effi))*time_tile;

                        if Estore>=Energy_consume_tile %第一层执行条件
                            Ops=Ops+Solution(i,4)*Solution(i,5)*Solution(i,6);
                            %执行第一层后电容剩余能量
                            Estore=Estore-Energy_consume_tile;
                 
                            if (1/2*C*1e-9*Solution(1,V_pos)*Solution(1,V_pos))<=(Estore+P_harvest*time_tile)
                                Estore=1/2*C*1e-9*Solution(1,V_pos)*Solution(1,V_pos);%边放边充
                            else
                                Estore=Estore+P_harvest*time_tile;
                            end
                            if charge_flag==1
                                working_cycle_time2=working_cycle_time2+time_tile;
                                working_cycle_ops_i=working_cycle_ops_i+(Solution(i,4)*Solution(i,5)*Solution(i,6));
                            end
                            t_onecycle=t_onecycle+time_tile;  
                        elseif  Estore==(1/2*C*1e-9*Solution(1,V_pos)*Solution(1,V_pos)) && Estore<Energy_consume_tile %电容最大容量不够支持一层运行
                            break;
                        end
                        V_up=sqrt(2*Estore/(C*(1e-9)));
                    else %充电
           
                        V_present=0;
                        t=(C*1e-9*(Solution(1,V_pos)*Solution(1,V_pos)-V_present*V_present))/(2*P_harvest);%充电时间
                        Estore=1/2*C*1e-9*Solution(1,V_pos)*Solution(1,V_pos);%充电之后电容存储的能量
 
                        if charge_flag==0
                            working_cycle_time1=t;
                        end
                        charge_flag=charge_flag+1; 
                        V_up=Solution(1,V_pos);
                        V_down=0;
                    end
                    % --------------------- 充电和放电 end  --------------------- %
                    V=V_up-V_down;
                    %执行一次放电后判断是否继续放电或者执行充电
                    if V>(Solution(1,V_pos)-0.01) && Estore>=Energy_consume_tile %放电判定
                        flag=0; 
                    else %充电判定
                        flag=1;
                        t_total=t_total+t;%一个power cycle充电时间总和
                        t_onecycle=t_onecycle+t;%一个power cycle充电时间和执行时间总和，超过采样周期时，进入下一个power cycle
                    end
                end
            else
                working_cycle_time1=t;
            end
            if working_cycle_time1>=cyc_time
                working_cycle_time=cyc_time;
            elseif working_cycle_time2>=cyc_time
                working_cycle_time=cyc_time;
            else
                working_cycle_time=working_cycle_time1+working_cycle_time2;
            end
            Throughput_efficiency(j+10*(i-2),1)=Ops/working_cycle_time;
        end
    end
end