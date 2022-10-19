--Cleaning Data NashvilleeHousing in SQL Queries


select * from [Portfolio Projects].dbo.NashvilleHousing;

--------------------------------------------------------
--1)Standardise Date Format--

--add a column(saledateconverted) in existing table

alter table [Portfolio Projects].dbo.NashvilleHousing
add saledateconverted date;

--update recently added column 
update [Portfolio Projects].dbo.NashvilleHousing
set saledateconverted = convert(date, saledate);

--------------------------------------------------------
--2)Populate Property Address Data 

select * 
from [Portfolio Projects].dbo.NashvilleHousing
order by ParcelID

--if the propertyaddress has nulls, replace nulls with the addresss of same parcel id
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Projects].dbo.NashvilleHousing a
join [Portfolio Projects].dbo.NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--update table 
update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Projects].dbo.NashvilleHousing a
join [Portfolio Projects].dbo.NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--------------------------------------------------------
--3)Breaking out Property Address into invidual columns(Address, City )
select PropertyAddress from [Portfolio Projects].dbo.NashvilleHousing

select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',propertyaddress)-1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress) + 1, len(propertyaddress)) as city
from [Portfolio Projects].dbo.NashvilleHousing

---add and update column for property Address 
alter table [Portfolio Projects].dbo.NashvilleHousing
add propertysplitaddress varchar(255);

update [Portfolio Projects].dbo.NashvilleHousing
set propertysplitaddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',propertyaddress)-1)

---add and update column for property City 
alter table [Portfolio Projects].dbo.NashvilleHousing
add propertysplitcity varchar(255);

update [Portfolio Projects].dbo.NashvilleHousing
set propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress) + 1, len(propertyaddress))


--------------------------------------------------------
--4)Breaking Out Owner Address into individual columns(Address, City, State)
select 
PARSENAME(replace(owneraddress, ',','.'),3) as address,
PARSENAME(replace(owneraddress, ',','.'),2) as city,
PARSENAME(replace(owneraddress, ',','.'),1) as state
from [Portfolio Projects].dbo.NashvilleHousing

---add and update column for owner address 
alter table [Portfolio Projects].dbo.NashvilleHousing
add ownersplitaddress varchar(255);

update [Portfolio Projects].dbo.NashvilleHousing
set propertysplitaddress = PARSENAME(replace(owneraddress, ',','.'),3)

---add and update column for owner city 
alter table [Portfolio Projects].dbo.NashvilleHousing
add ownersplitcity varchar(255);

update [Portfolio Projects].dbo.NashvilleHousing
set ownersplitcity = PARSENAME(replace(owneraddress, ',','.'),2) 

---add and update column for owner state 
alter table [Portfolio Projects].dbo.NashvilleHousing
add ownersplitstate varchar(255);

update [Portfolio Projects].dbo.NashvilleHousing
set ownersplitstate = PARSENAME(replace(owneraddress, ',','.'),1)


--------------------------------------------------------
--5) change Y and N to yes and No in "sold as vaccant " field
select distinct(soldasvacant), count(soldasvacant)
from [Portfolio Projects].dbo.NashvilleHousing
group by soldasvacant
order by 2


select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end 
from [Portfolio Projects].dbo.NashvilleHousing


update [Portfolio Projects].dbo.NashvilleHousing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end 

--------------------------------------------------------
--6)remove duplicates
with rownumcte as(
	select * ,
	ROW_NUMBER() 
	over(partition by parcelid, propertyaddress, saleprice, saledate, legalreference order by uniqueid) rownum
	from [Portfolio Projects].dbo.NashvilleHousing
)
delete 
from  rownumcte
where rownum > 1

--------------------------------------------------------
--7)delete unused columns 
select * from [Portfolio Projects].dbo.NashvilleHousing

alter table [Portfolio Projects].dbo.NashvilleHousing
drop column propertyaddress, owneraddress, taxdistrict

alter table [Portfolio Projects].dbo.NashvilleHousing
drop column saledate
