% Section II: Classification and Big Data Analysis (70%)

% Task 4 - Split dataset into training and test

% Splits data into training/test with a 70/30 split

[m,n] = size(clinical_data);
P = 0.70;
idx = randperm(m); % Permutates
train_data = clinical_data(idx(1:round(P*m)),:); % Gets 70% training
test_data = clinical_data(idx(round(P*m)+1:end),:); % Gets 30% testing

% Checks size of training and testing
train_size = size(train_data);
test_size = size(test_data);

x_train = train_data(:,1:9); % Sets 1-9 columns as x
y_train = train_data(:,10); % Sets classification column as y

x_test = test_data(:,1:9);
y_test = test_data(:,10);
  
train_healthy = 0; % Creates variables and sets to 0
train_cancer = 0;

for i = 1:numel(y_train) % Iterates through every value in y
    if y_train(i) == 1;  % If 1, increment train_healthy
        train_healthy = train_healthy + 1;
    elseif y_train(i) == 2; % If 2, increment test_healthy
        train_cancer = train_cancer + 1;
    end
end

test_healthy=0;
test_cancer = 0;

for i = 1:numel(y_test)
    if y_test(i) == 1;
        test_healthy = test_healthy + 1;
    elseif y_test(i) == 2;
        test_cancer = test_cancer + 1;
    end
end

% Print number of healthy and cancer for training and testing
train_healthy;
train_cancer;  
test_healthy;
test_cancer;

% Task 5 - Train decision tree and SVM

dt_train = fitctree(x_train, y_train); % Creates decision tree
view(dt_train, 'mode', 'graph'); % Displays decision tree

svm_train = fitcsvm(x_train, y_train); % Creates SVM

predict_dt = predict(dt_train, x_test); % Uses decision tree to classify x
predict_svm = predict(svm_train, x_test); % Uses SVM classifier to classify x

figure()
conf_dt = confusionmat(y_test, predict_dt); % Creates confusion matrix
confusionchart(conf_dt) % Plots matrix in a chart
title('Decision Tree')

figure()

conf_svm = confusionmat(y_test, predict_svm); % Creates confusion matrix
confusionchart(conf_svm) % Plots matrix in a chart
title('SVM')

% Sensitivity = TP/Actual Positives
sens_dt = conf_dt(2,2)/sum(conf_dt(2,:));
sens_svm = conf_svm(2,2)/sum(conf_svm(2,:));

% Specificty = TN/Actual Negatives
spec_dt = conf_dt(1,1)/sum(conf_dt(1,:));
spec_svm = conf_svm(1,1)/sum(conf_svm(1,:));

% Error rate = (FP+FN)/Total
error_dt = (conf_dt(2,1)+conf_dt(1,2))/sum(conf_dt, 'all');
error_svm = (conf_svm(2,1)+conf_svm(1,2))/sum(conf_svm, 'all');

% Table to show confusion metrics
Metrics = categorical(["Sensitivity"; "Specificity"; "Error Rate"]);
Decision_Tree = [sens_dt; spec_dt; error_dt];
SVM = [sens_svm; spec_svm; error_svm];
t_compare = table(Metrics, Decision_Tree, SVM)

% Task 8
ds = datastore('clinicalfeatures1.csv', 'TreatAsMissing', 'NA'); % Reads data in as a datastore

mean_homa = mapreduce(ds, @mean_homa_mapper, @mean_homa_reducer); % Calls mapreduce function
readall(mean_homa) % Prints mean

max_homa = mapreduce(ds, @max_homa_mapper, @max_homa_reducer); % Calls mapreduce function
readall(max_homa) % Prints maximum
min_homa = mapreduce(ds, @min_homa_mapper, @min_homa_reducer); % Calls mapreduce function
readall(min_homa) % Prints minimum

var_homa = mapreduce(ds, @var_homa_mapper, @var_homa_reducer);
readall(var_homa)

function mean_homa_mapper(data, info, interm_kv_store) % Mean map function
    homas = data.HOMA(~isnan(data.HOMA)); % Removes missing values
    sum_len_value = [sum(homas) length(homas)]; % Finds count and sum of each block
    add(interm_kv_store, 'sum_and_length', sum_len_value); % Added intermediate results
end

function mean_homa_reducer(interm_key, interm_val_iter, out_kv_store) % Mean reduce function
    sum_len = [0 0]; % Sum and length declares in matrix
    while hasnext(interm_val_iter) % Loops through each value
        sum_len = sum_len + getnext(interm_val_iter); % Running total of distance and count after each pass
    end
    add(out_kv_store, 'Mean_HOMA', sum_len(1)/sum_len(2)); % Adds final key-value pair
end

function max_homa_mapper(data, info, interm_kv_store) % Maximum map function
    part_max = max(data.HOMA); % Finds maximum of each block
    add(interm_kv_store, 'partial_maximum', part_max); % Adds intermediate results
end

function max_homa_reducer(interm_key, interm_val_iter, out_kv_store) % Maximum reduce function
    max_val = -Inf; % Declares maximum as negative infinity
    while hasnext(interm_val_iter) % Loops through each value
        max_val=max(getnext(interm_val_iter), max_val); % Finds overall maximum
    end
    add(out_kv_store, 'Maximum HOMA',max_val); % Adds final key-value pair
end

function min_homa_mapper(data, info, interm_kv_store) % Minimum map function
    part_min = min(data.HOMA); % Finds minimum of each block
    add(interm_kv_store, 'partial_minimum', part_min); % Adds intermediate results
end

function min_homa_reducer(interm_key, interm_val_iter, out_kv_store) % Minimum reduce function
    min_val = Inf; % Declares minimum as infinity
    while hasnext(interm_val_iter) % Loops through each value
        min_val=min(getnext(interm_val_iter), min_val); % Finds overall minimum
    end
    add(out_kv_store, 'Minimum HOMA', min_val); % Adds final key-value pair
end

function var_homa_mapper(data, info, interm_kv_store) % Map function to calculate variance
    homas = data.HOMA(~isnan(data.HOMA)); % Checks for NaN
    sum_len_value = [sum(((homas)-1.6253).^2), length(homas)]; % Begins to calculate variance, and stores the length
    add(interm_kv_store, 'sum and length', sum_len_value); % Adds intermediate results
end

function var_homa_reducer(interm_key, interm_val_iter, out_kv_store) % Reduce function to calculate variance
    sum = 0; % Declares sum as 0
    length = 0; % Declares length as 0
    while hasnext(interm_val_iter) % Loops through each value
        sum_len_value2 = getnext(interm_val_iter); % Finds total length and sum
        sum = sum + sum_len_value2(1); % Updates sum
        length = length + sum_len_value2(2); % Updates length
    end
    variance = sum/length; % Divides sum of all numbers(-mean) by length
    add(out_kv_store, 'HOMA Variance', variance) % Adds final key-value pair
end


    

    
    

