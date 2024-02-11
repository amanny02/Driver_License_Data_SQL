use Data310
Create Table Driver_Licenses_Original
(
	Count_New_WA_Driver_Licenses int,
	Year int,
	Month int,
	Issue_Date date,
	card_type_issued nvarchar(255),
	county_of_residency nvarchar(255),
	prior_state_of_USA_license_id nvarchar(255),
	prior_country_issuing_license_id nvarchar(255),
	iso_2 nvarchar(255),
	iso_3 nvarchar(255),
	iso_num_code int, 
	irs_country_code nvarchar(255),
	card_origin nvarchar(255)
)
--drop table driver_licenses_original
insert into Driver_Licenses_Original
select *
from Driver_Licenses_and_ID_Cards_Tr$

-- select * from Driver_Licenses_Original
----------------------------------

Create Table Driver_Licenses
(
	Year int,
	Month int,
	Issue_Date date,
	issue_date_converted AS CONVERT(varchar, Issue_Date, 1),
	card_type_issued nvarchar(255),
	county nvarchar(255),
	prior_state nvarchar(255),
	prior_country nvarchar(255),
	out_of_country_license_transfers BIT
	)

-- exec sp_rename 'Driver_Licenses.country', 'county', 'column' -- to change the name of the column
--SELECT CONVERT(varchar, Issue_Date, 1) as issue_date from driver_licenses

insert into Driver_Licenses
Select Year, Month, Issue_Date, card_type_issued, county_of_residency, prior_state_of_USA_license_id, prior_country_issuing_license_id, 
case 
	when prior_state_of_USA_license_id= 'Not Applicable' then 1 /* 1= yes */
	else 0 /* 0= no */
end as out_of_country_license_transfers
from Driver_Licenses_Original

--drop table driver_licenses
-- select * from driver_licenses
----------------------------------------

create procedure county_view 
	@county nvarchar(30)
as
	select issue_date_converted, card_type_issued, county
	from Driver_Licenses 
	where county=@county
go
-- drop procedure county_view
exec county_view @county = 'King'
--------------------------------------

create procedure state_view
	@prior_state nvarchar(30)
as
	select issue_date_converted, card_type_issued, prior_state
	from Driver_Licenses
	where prior_state=@prior_state
go
-- drop procedure state_view
exec state_view @prior_state = 'California'
------------------------------------------------

create procedure country_view
	@prior_country nvarchar(30)
as
	select issue_date_converted, card_type_issued, prior_country
	from Driver_Licenses
	where prior_country= @prior_country
go 
-- drop procedure country_view
exec country_view @prior_country = 'Egypt'