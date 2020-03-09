% Section II: Classification and Big Data Analysis (70%)

% Task 4 - Split dataset into training and test

[m,n] = size(clinical_data);
P = 0.70;
idx = randperm(m);
train_data = clinical_data(idx(1:round(P*m)),:); 
test_data = clinical_data(idx(round(P*m)+1:end),:);

x_train = train_data(:,1:9);
y_train = train_data(:,10);

x_test = test_data(:,1:9);
y_test = test_data(:,10);

% Task 5 - Train decision tree and SVM

dt_train = fitctree(x_train, y_train);

view(dt_train, 'mode', 'graph')

svm_train = fitcsvm(x_train, y_train);

dt_test = fitctree (x_test, y_test);

view(dt_test, 'mode', 'graph')

svm_test = fitcsvm(x_test, y_test);

label_dt = predict(dt_test, x_test(30,:));

label_svm = predict(svm_test, x_test(30,:));



% Task 8

ds = datastore('clinicalfeatures1.csv', 'TreatAsMissing', 'NA');

mean_homa = mapreduce(ds, @mean_homa_mapper, @mean_homa_reducer);
max_homa = mapreduce(ds, @max_homa_mapper, @max_homa_reducer);
min_homa = mapreduce(ds, @min_homa_mapper, @min_homa_reducer);

readall(mean_homa)
readall(max_homa)
readall(min_homa)

function mean_homa_mapper(data, info, interm_kv_store)
    homas = data.HOMA(~isnan(data.HOMA));
    sum_len_value = [sum(homas) length(homas)];
    add(interm_kv_store, 'sum and length', sum_len_value);
end
function mean_homa_reducer(interm_key, interm_val_iter, out_kv_store)
    sum_len = [0 0];
    while hasnext(interm_val_iter)
        sum_len = sum_len + getnext(interm_val_iter);
    end
    add(out_kv_store, 'Mean HOMA', sum_len(1)/sum_len(2));
end

function max_homa_mapper(data, info, interm_kv_store)
    part_max = max(data.HOMA);
    add(interm_kv_store, 'partial_maximum', part_max);
end

function max_homa_reducer(interm_key, interm_val_iter, out_kv_store)
    max_val = -Inf;
    while hasnext(interm_val_iter)
        max_val=max(getnext(interm_val_iter), max_val);
    end
    add(out_kv_store, 'Maximum HOMA',max_val);
end

function min_homa_mapper(data, info, interm_kv_store)
    part_min = min(data.HOMA);
    add(interm_kv_store, 'partial_minimum', part_min);
end

function min_homa_reducer(interm_key, interm_val_iter, out_kv_store)
    min_val = Inf;
    while hasnext(interm_val_iter)
        min_val=min(getnext(interm_val_iter), min_val);
    end
    add(out_kv_store, 'Minimum HOMA', min_val);
end

function var_homa_mapper(data, info, interm_kv_store)
    homas = data.HOMA(~isnan(data.HOMA));
    sum_len_value = [sum(homas) length(homas)];
    add(interm_kv_store, 'sum and length', sum_len_value);
end

function var_homa_reducer(interm_key, interm_val_iter, out_kv_store)
    
    

    
    

