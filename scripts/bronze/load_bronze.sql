create or alter procedure bronze.load_bronze as 
declare @whole_start datetime , @whole_end datetime;
set @whole_start=getdate();
begin
  declare @start_time datetime , @end_time datetime;
  begin try
    print 'Loading Bronze Layer'
	--we created the tables for two sources
	--now load the data from source to created tables use BULK INSERT
	--first make the table empty
	print '----Loading crm tables-----'

	set @start_time = getdate();
	print 'truncating table bronze.crm_cust_info'
	print 'inserting data into bronze.crm_cust_info'
	truncate table bronze.crm_cust_info;
	bulk insert bronze.crm_cust_info
	from 
	'C:\Users\manik\OneDrive\Documents\S\Ps\SQL DWDM project\datasets\source_crm\cust_info.csv'
	with (
	firstrow=2,
	fieldterminator = ',',
	tablock
	);
	set @end_time = getdate();
	print ' >> Load Duration :'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
	print '------------------';

	set @start_time = getdate();
	print 'truncating table bronze.crm_prd_info'
	print 'inserting data into bronze.crm_prd_info'
	truncate table bronze.crm_prd_info;
	bulk insert bronze.crm_prd_info
	from 'C:\Users\manik\OneDrive\Documents\S\Ps\SQL DWDM project\datasets\source_crm\prd_info.csv'
	with(
	firstrow=2,
	fieldterminator=',',
	tablock
	);
	set @end_time=getdate();
	print ' >> Load Duration :'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
	print '------------------';

	set @start_time=getdate();
	print 'truncating table bronze.crm_sales_details'
	print 'inserting data into bronze.crm_sales_details'
	truncate table bronze.crm_sales_details;
	bulk insert bronze.crm_sales_details
	from 'C:\Users\manik\OneDrive\Documents\S\Ps\SQL DWDM project\datasets\source_crm\sales_details.csv'
	with(
	firstrow=2,
	fieldterminator=',',
	tablock
	);
	set @end_time=getdate();
	print ' >> Load Duration :'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
	print '------------------';

	print '----Loading erp tables-----'

	set @start_time=getdate();
	print 'truncating table bronze.erp_cust_az12'
	print 'inserting data into bronze.erp_cust_az12'
	truncate table bronze.erp_cust_az12;
	bulk insert bronze.erp_cust_az12
	from 'C:\Users\manik\OneDrive\Documents\S\Ps\SQL DWDM project\datasets\source_erp\CUST_AZ12.csv'
	with(
	firstrow=2,
	fieldterminator=',',
	tablock
	);
	set @end_time=getdate();
	print ' >> Load Duration :'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
	print '------------------';

	set @start_time=getdate();
	print 'truncating table bronze.erp_cust_az12'
	print 'inserting data into bronze.erp_cust_az12'
	truncate table bronze.erp_cust_az12;
	bulk insert bronze.erp_cust_az12
	from 'C:\Users\manik\OneDrive\Documents\S\Ps\SQL DWDM project\datasets\source_erp\CUST_AZ12.csv'
	with(
	firstrow=2,
	fieldterminator=',',
	tablock
	);
	set @end_time=getdate();
	print ' >> Load Duration :'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
	print '------------------';

	set @start_time=getdate();
	print 'truncating table bronze.erp_loc_a101'
	print 'inserting data into bronze.erp_loc_a101'
	truncate table bronze.erp_loc_a101;
	bulk insert bronze.erp_loc_a101
	from 'C:\Users\manik\OneDrive\Documents\S\Ps\SQL DWDM project\datasets\source_erp\LOC_A101.csv'
	with(
	firstrow=2,
	fieldterminator=',',
	tablock
	);
	set @end_time=getdate();
	print ' >> Load Duration :'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
	print '------------------';

	set @start_time=getdate();
	print 'truncating table bronze.erp_px_cat_g1v2'
	print 'inserting data into bronze.erp_px_cat_g1v2'
	truncate table bronze.erp_px_cat_g1v2;
	bulk insert bronze.erp_px_cat_g1v2
	from 'C:\Users\manik\OneDrive\Documents\S\Ps\SQL DWDM project\datasets\source_erp\PX_CAT_G1V2.csv'
	with(
	firstrow=2,
	fieldterminator=',',
	tablock
	);
	set @end_time=getdate();
	print ' >> Load Duration :'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +' seconds';
	print '------------------';
  end try
  begin catch
  print 'ERROR OCCURED DURING LOADING OF BRONZE LAYER'
  print 'error message '+error_message();
  print 'error message '+cast(error_number() as nvarchar);
  print 'error message '+cast(error_state() as nvarchar);

  end catch
end
set @whole_end=getdate();
	print ' >> Load Duration of whole bronze layer :'+ cast(datediff(second,@whole_start,@whole_end) as nvarchar) +' seconds';
	print '------------------';
