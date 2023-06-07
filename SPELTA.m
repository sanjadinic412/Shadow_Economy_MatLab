clc, clearvars; close all
%% load data
load shadoweconomy_dataset.mat
% MV tolgo shadow + 1 a caso (Edu3)
MV_labels={'GDPGrowth','GrowthTax','ICP','Edu1','Edu2','Edu3','Industrial',...
    'Unempl','PercevIRAP','IrrEmpl'}';
% LV label (latent non observales)
LV_labels={'Economy','Education','Taxation','Sadow'}';
% relazioni tra latant
DB=zeros(length(LV_labels),length(LV_labels));
% economy influence shadow
DB(1,4)=1; 
% education influence shadow
DB(2,4)=1; 
% taxation influence shadow
DB(3,4)=1; 
% economy influence taxation
DB(1,3)=1;
% education influence economy
DB(2,1)=1;

% come misuro latent observables x latent
DP=zeros(length(MV_labels),length(LV_labels));
DP([1 7 8],1)=1;
DP([4 5 6],2)=1;
DP(2,3)=1;
DP([3 9 10],4)=1;

% In ECSI example, all measurement bocks are estimated as reflective model. 
Mmode=['A'; 'A'; 'A'; 'A'];

% xy=randi(length(LV_labels),length(LV_labels));
load Location.mat
color='blue';
path_graph(DB,xy,2,color,LV_labels)


method='path';
max_iter=500;
[results]=plssem(MV,DP,DB,Mmode,method,max_iter); 
dec=30;
[ OM_Tables, IM_Tables,OVERALL_Tables ] = summary_plssem(results,MV_labels,LV_labels,dec );
OM_Tables;
OM_Tables.weights;
OM_Tables.loadings;

IM_Tables;
measure='loadings';
r=2;
color='blue';
measurement_graph(results,measure, r,color,LV_labels,MV_labels);
graph_type='weights';


nboot=500;
% Default value for ci_type is 'basic'.
ci_type='studentized';
%
% conf_level specifies the confidence level of confidence intervals.
% conf_level is a value in the interval [0,1]. Default value is 0.95
conf_level=0.95;
%
% bias is logical value true or false
% *       bias=true calculates bias-corrected confidence interval 
% *       bias=false calculates non bias-corrected confidence interval
bias=1;
%
% Bootstrap Results
%
[ results ] = boot_confint( results,nboot,ci_type,conf_level,bias);
[ CI_Tables ] = summary_bootstrap(results,MV_labels,LV_labels,dec);
%
% CI_Tables is a strucutred array formed by three matrices:
%        CI_Tables.W contains the confidence interval for outer weigths
%        CI_Tables.L contains the confidence interval for outer loadings
%        CI_Tables.B contains the confidence interval for inner path coefficients
%        the generic row of a CI matrix is composed by 7 elements:
%        |Sample estimation | Bootstrap estimation | Bias | t stat | Pvalue | CI lower bound | CI upper bound|
%%
% CI_Tables = 
% 
%     W: [24x7 double]
%     L: [24x7 double]
%     B: [12x7 double]
%%
% CI_Tables.W;
%
% ans = 
% 
%             Sample_estim    Boot_estim     Bias     t_stat    Pvalue    CI_LB    CI_UB
%             ____________    __________    ______    ______    ______    _____    _____
% 
%     ima1    0.301           0.299          0.002    11.309        0     0.256    0.359
%     ima2     0.26           0.259          0.001     7.452        0     0.192    0.326
%     ima3    0.218           0.219         -0.001     6.592        0     0.152    0.282
%     ima4    0.329           0.329         -0.001    10.944        0     0.263    0.385
%     ima5    0.325           0.326         -0.001     9.198        0     0.244    0.378
%     exp1    0.521           0.515          0.006     9.575        0     0.428    0.644
%     exp2    0.474           0.478         -0.004     6.405        0     0.321    0.601
%     exp3    0.446            0.44          0.006     6.716        0     0.321    0.587
%     qua1    0.213           0.213              0     14.02        0     0.178    0.239
%     qua2    0.145           0.144              0    10.833        0      0.12    0.174
%     qua3      0.2             0.2              0    16.195        0     0.174    0.223
%     qua4    0.179           0.179              0    17.394        0     0.158    0.199
%     qua5    0.179           0.178              0    14.135        0     0.156    0.203
%     qua6    0.179           0.178          0.001    12.094        0     0.156    0.213
%     qua7    0.215           0.216         -0.001    13.945        0     0.181    0.242
%     val1    0.479           0.479              0     23.39        0     0.443    0.524
%     val2    0.604           0.604              0    22.352        0     0.548    0.648
%     sat1    0.365           0.365              0    20.108        0     0.331    0.401
%     sat2    0.383           0.385         -0.002    22.954        0     0.345    0.411
%     sat3    0.451           0.449          0.002    21.928        0     0.409    0.491
%     comp        1               1              0       Inf        0         1        1
%     loy1    0.461           0.459          0.001    16.632        0     0.411    0.525
%     loy2    0.114            0.11          0.004     1.876    0.031     0.016    0.251
%     loy3    0.654           0.652          0.002    16.325        0     0.574    0.725
%%
% CI_Tables.L;
%
% ans = 
% 
%             Sample_estim    Boot_estim     Bias     t_stat    Pvalue    CI_LB    CI_UB
%             ____________    __________    ______    ______    ______    _____    _____
% 
%     ima1    0.745           0.738          0.007    17.421        0     0.691    0.856
%     ima2    0.599           0.596          0.003    10.123        0     0.503    0.729
%     ima3    0.576           0.574          0.002     9.056        0     0.465    0.707
%     ima4    0.769           0.764          0.005    18.481        0     0.714    0.874
%     ima5    0.744           0.747         -0.003    24.415        0     0.681    0.797
%     exp1    0.771           0.765          0.005    14.782        0     0.704    0.896
%     exp2    0.691           0.691              0     8.214        0     0.552    0.878
%     exp3    0.608           0.601          0.006     7.987        0     0.481    0.794
%     qua1    0.803           0.804         -0.001    33.237        0     0.755    0.851
%     qua2    0.638           0.636          0.002    12.939        0     0.555    0.745
%     qua3    0.784           0.784              0    26.584        0     0.734    0.854
%     qua4    0.769           0.769          0.001    16.818        0     0.691    0.871
%     qua5    0.755           0.754              0    19.185        0     0.689    0.852
%     qua6    0.775           0.771          0.004    13.497        0     0.688    0.908
%     qua7     0.78           0.781         -0.001    25.872        0     0.727    0.847
%     val1    0.902           0.901          0.001    43.582        0     0.872     0.95
%     val2     0.94            0.94              0       Inf        0     0.925    0.955
%     sat1    0.792           0.791          0.001    24.704        0     0.739    0.867
%     sat2    0.847           0.847              0    36.494        0     0.807    0.896
%     sat3    0.857           0.856          0.001     45.08        0     0.825    0.898
%     comp        1               1              0       Inf        0         1        1
%     loy1     0.82           0.817          0.004    19.097        0      0.76    0.936
%     loy2    0.202           0.196          0.006     1.918    0.028     0.029    0.442
%     loy3    0.915           0.914          0.001    81.312        0     0.899    0.943
%%
% CI_Tables.B;
%
% ans = 
% 
%                                Sample_estim    Boot_estim     Bias     t_stat    Pvalue    CI_LB     CI_UB
%                                ____________    __________    ______    ______    ______    ______    _____
% 
%     Image->CustExpect          0.505           0.516         -0.011    8.759         0      0.375    0.599
%     Image->CustSat             0.557           0.561         -0.004    10.22         0       0.44    0.653
%     Image->Loyalty              0.05            0.06          -0.01    0.619     0.268     -0.137    0.186
%     CustExpect->PercQuality    0.558           0.551          0.007    6.774         0      0.413    0.732
%     CustExpect->PercValue      0.179           0.185         -0.006    3.386         0      0.056    0.267
%     CustExpect->CustSat        0.063           0.064         -0.002    1.274     0.102      -0.04    0.157
%     PercQuality->PercValue     0.512           0.503          0.009    8.553         0        0.4    0.647
%     PercQuality->CustSat       0.195           0.199         -0.004    3.315     0.001      0.064    0.303
%     PercValue->CustSat         0.528           0.525          0.003    9.795         0       0.43    0.659
%     CustSat->Compliant         0.196           0.206          -0.01     2.47     0.007      0.027    0.334
%     CustSat->Loyalty           0.485            0.48          0.006    5.759         0      0.344    0.653
%     Compliant->Loyalty         0.067           0.067              0    1.115     0.133     -0.039    0.186




