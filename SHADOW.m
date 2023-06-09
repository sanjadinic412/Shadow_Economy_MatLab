clc, clearvars; close all
%% load data
load shadoweconomy_dataset.mat
DB=zeros(length(LV_labels),length(LV_labels));
DB(1,4)=1; 
DB(1,3)=1;
DB(2,1)=1;
DB(2,4)=1; 
DB(3,4)=1; 
DB;
DP=zeros(length(MV_labels),length(LV_labels));
DP([1 7 8],1)=1;
DP([4 5 6],2)=1;
DP(2,3)=1;
DP([3 9 10],4)=1;
DP;
Mmode=['A'; 'A'; 'A'; 'A'];
load Location.mat
color='blue';
path_graph(DB,xy,2,color,LV_labels);
method='path';
max_iter=500;
[results]=plssem(MV,DP,DB,Mmode,method,max_iter);
dec=30;
[ OM_Tables, IM_Tables,OVERALL_Tables ] = summary_plssem(results,MV_labels,LV_labels,dec );
OVERALL_Tables;
OVERALL_Tables.SRMR;
OVERALL_Tables.rel_ind;
OM_Tables;
OM_Tables.weights;
OM_Tables.loadings;
OM_Tables.consistency;
OM_Tables.vif;
OM_Tables.CA;
OM_Tables.CR;
OM_Tables.communality;
OM_Tables.HTMT;
OM_Tables.AVE;
OM_Tables.crossload;
OM_Tables.discriminant;
OM_Tables.FLcrit;
IM_Tables;
IM_Tables.B;
IM_Tables.R2;
IM_Tables.gof;
IM_Tables.LVcommunality;
IM_Tables.totaleffects;
IM_Tables.indirecteffects;
IM_Tables.effect_overview;

measure='loadings';
r=2;
color='blue';
measurement_graph(results,measure, r,color,LV_labels,MV_labels);
graph_type='weights';
graph_type='scatter';
graph_type='crossloadings';
nboot=500;
ci_type='studentized';
conf_level=0.95;
bias=1;
[ results ] = boot_confint( results,nboot,ci_type,conf_level,bias);
[ CI_Tables ] = summary_bootstrap(results,MV_labels,LV_labels,dec);
CI_Tables.W;
CI_Tables.L;
CI_Tables.B;
