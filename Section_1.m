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

ismember(1, isnan(clinical_data))

% Task 2 - Summary statistics

% Splits dataset into healthy patients and patients with cancer, based on
% classification column

healthy = clinical_data(1:52,1:9);
cancer = clinical_data(53:116,1:9);

% Computes summary statistics for each feature in the healthy group, and
% puts them in a table

Variable = categorical(["Age";"BMI";"Glucose";"Insulin";"HOMA";"Leptin";"Adiponectin";"Resistin";"MCP.1"]); 
Minimum = min(healthy)';
Maximum = max(healthy)';
Mean = mean(healthy)';
Median = median(healthy)';
Variance = var(healthy)';
t_health = table(Variable, Minimum, Maximum, Mean, Median, Variance);

% Computes summary statistics for each feature in the cancer group, and
% puts them in a table

Variable = categorical(["Age";"BMI";"Glucose";"Insulin";"HOMA";"Leptin";"Adiponectin";"Resistin";"MCP.1"]); 
Minimum = min(cancer)';
Maximum = max(cancer)';
Mean = mean(cancer)';
Median = median(cancer)';
Variance = var(cancer)';
t_cancer = table(Variable, Minimum, Maximum, Mean, Median, Variance);

% Creates boxplot of each feature in the healthy group

age_1 = boxplot(healthy(:,1));
bmi_1 = boxplot(healthy(:,2));
glucose_1 = boxplot(healthy(:,3));
insulin_1 = boxplot(healthy(:,4));
homa_1 = boxplot(healthy(:,5));
leptin_1 = boxplot(healthy(:,6));
adipon_1 = boxplot(healthy(:,7));
resistin_1 = boxplot(healthy(:,8));
mcp_1 = boxplot(healthy(:,9));

% Creates boxplot of each feature in the cancer group

age_2 = boxplot(cancer(:,1));
bmi_2 = boxplot(cancer(:,2));
glucose_2 = boxplot(cancer(:,3));
insulin_2 = boxplot(cancer(:,4));
homa_2 = boxplot(cancer(:,5));
leptin_2 = boxplot(cancer(:,6));
adipon_2 = boxplot(cancer(:,7));
resistin_2 = boxplot(cancer(:,8));
mcp_2 = boxplot(cancer(:,9));

% Task 3 - Correlation matrix

corr_matrix = corrcoef(clinical_data(:,1:9));

