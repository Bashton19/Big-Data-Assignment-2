% Section I: Data Summary, Understanding and Visualisation (30%)

% Reads the dataset into the workspace
clinical_data = xlsread('clinicalfeatures.xlsx');

% Task 1 - Check for missing values

%{ 
isnan creates an array where every element is replaced by "0" or "1"
"0" indicates the element has a numerical value, and 1 indicates the
element has no value 
%}

%{
ismember checks for 1's (NaN) in the array, and returns a 0 or 1
"0" indicates there are no NaN values, and "1" indicates there is at least one
missing value
%}

% Checks for missing values in dataset
ismember(1, isnan(clinical_data));

% Task 2 - Summary statistics

% Splits dataset into healthy patients and patients with cancer, based on
% classification column

healthy = clinical_data(1:52,1:9);
cancer = clinical_data(53:116,1:9);

% Computes summary statistics for each feature in the healthy group, and puts them in a table

Variable = categorical(["Age";"BMI";"Glucose";"Insulin";"HOMA";"Leptin";"Adiponectin";"Resistin";"MCP.1"]); 
Minimum = min(healthy)'; % Transposes row vector for each stat
Maximum = max(healthy)';
Mean = mean(healthy)';
Median = median(healthy)';
Variance = var(healthy)';
t_health = table(Variable, Minimum, Maximum, Mean, Median, Variance)

% Computes summary statistics for each feature in the cancer group, and puts them in a table

Variable = categorical(["Age";"BMI";"Glucose";"Insulin";"HOMA";"Leptin";"Adiponectin";"Resistin";"MCP.1"]); 
Minimum = min(cancer)'; % Transposes row vector for each stat
Maximum = max(cancer)';
Mean = mean(cancer)';
Median = median(cancer)';
Variance = var(cancer)';
t_cancer = table(Variable, Minimum, Maximum, Mean, Median, Variance)

% Creates boxplot of each feature for both groups
x = [healthy(:,1); cancer(:,1)]; % Groups age columns, and groups varying sizes as one size
g = [repmat({'Healthy Controls'}, size(healthy(:,1))); repmat({'Cancer Patients'}, size(cancer(:,1)))];
boxplot(x, g) % Plots age values
xlabel('Subjects') % Labels x axis
ylabel('Age') % Labels y axis
title('Age of Subjects') % Gives title

% Repeats above process for other features
figure()
x = [healthy(:,2); cancer(:,2)];
g = [repmat({'Healthy Controls'}, size(healthy(:,2))); repmat({'Cancer Patients'}, size(cancer(:,2)))];
boxplot(x, g)
xlabel('Subjects')
ylabel('BMI')
title('BMI of Subjects')
figure()
x = [healthy(:,3); cancer(:,3)];
g = [repmat({'Healthy Controls'}, size(healthy(:,3))); repmat({'Cancer Patients'}, size(cancer(:,3)))];
boxplot(x, g)
xlabel('Subjects')
ylabel('Glucose')
title('Glucose Levels of Subjects')
figure()
x = [healthy(:,4); cancer(:,4)];
g = [repmat({'Healthy Controls'}, size(healthy(:,4))); repmat({'Cancer Patients'}, size(cancer(:,4)))];
boxplot(x, g)
xlabel('Subjects')
ylabel('Insulin')
title('Insulin Levels of Subjects')
figure()
x = [healthy(:,5); cancer(:,5)];
g = [repmat({'Healthy Controls'}, size(healthy(:,5))); repmat({'Cancer Patients'}, size(cancer(:,5)))];
boxplot(x, g)
xlabel('Subjects')
ylabel('HOMA')
title('HOMA of Subjects')
figure()
x = [healthy(:,6); cancer(:,6)];
g = [repmat({'Healthy Controls'}, size(healthy(:,6))); repmat({'Cancer Patients'}, size(cancer(:,6)))];
boxplot(x, g)
xlabel('Subjects')
ylabel('Leptin')
title('Leptin Levels of Subjects')
figure()
x = [healthy(:,7); cancer(:,7)];
g = [repmat({'Healthy Controls'}, size(healthy(:,7))); repmat({'Cancer Patients'}, size(cancer(:,7)))];
boxplot(x, g)
xlabel('Subjects')
ylabel('Adiponectin')
title('Adiponectin Levels of Subjects')
figure()
x = [healthy(:,8); cancer(:,8)];
g = [repmat({'Healthy Controls'}, size(healthy(:,8))); repmat({'Cancer Patients'}, size(cancer(:,8)))];
boxplot(x, g)
xlabel('Subjects')
ylabel('Resistin')
title('Resistin Levels of Subjects')
figure()
x = [healthy(:,9); cancer(:,9)];
g = [repmat({'Healthy Controls'}, size(healthy(:,9))); repmat({'Cancer Patients'}, size(cancer(:,9)))];
boxplot(x, g)
xlabel('Subjects')
ylabel('MCP.1')
title('MCP.1 Levels of Subjects')

% Task 3 - Correlation matrix

% Creates correlation matrix of clinical features
corr_matrix = corrcoef(clinical_data(:,1:9))
array2table(corr_matrix)

% Creates correlation plot

figure()
corrplot(clinical_data(:,1:9))

VariableNo = (['var1'; "var2"; "var3"; "var4"; "var5"; "var6"; "var7"; "var8"; "var9"]);
Variable = (["Age"; "BMI"; "Glucose"; "Insulin"; "HOMA"; "Leptin"; "Adiponectin"; "Resistin"; "MCP.1"]);
 
table(VariableNo, Variable)





