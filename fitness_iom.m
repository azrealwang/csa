function [distance] = fitness_iom(x, hashcode,opts)
db_data.X=x';
[all_code, ~] = IoM(db_data, opts, opts.model);
[distance] = 1 - matching_IoM(hashcode,all_code.Hx');
end