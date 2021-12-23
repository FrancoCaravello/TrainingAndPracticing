--
SELECT *
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SaleDateConverted Date

update PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--SELECT SaleDateConverted, CONVERT(date, SaleDate)  Doesnt works
--FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate

-------------------------------------------------------------------------------------

SELECT p.ParcelID, p.PropertyAddress, pp.ParcelID, pp.PropertyAddress, ISNULL(p.PropertyAddress,pp.PropertyAddress)
FROM PortfolioProject..NashvilleHousing p
join PortfolioProject..NashvilleHousing pp
	on p.ParcelID = pp.ParcelID
	and p.[UniqueID ] <> pp.[UniqueID ]
where p.PropertyAddress IS NULL

update p
SET PropertyAddress = ISNULL(p.PropertyAddress,pp.PropertyAddress)
FROM PortfolioProject..NashvilleHousing p
join PortfolioProject..NashvilleHousing pp
	on p.ParcelID = pp.ParcelID
	and p.[UniqueID ] <> pp.[UniqueID ]
where p.PropertyAddress IS NULL


-----------------------------------------------------------------------------------

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address
FROM PortfolioProject..NashvilleHousing

SELECT SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress)) AS City
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropAddress Nvarchar(255)

update PortfolioProject..NashvilleHousing
SET PropAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropCity Nvarchar(255)

update PortfolioProject..NashvilleHousing
SET PropCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress))

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN PropertyAddress

---------------------------------------------------------------------------------------------------

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

with cte as (
SELECT LTRIM(PARSENAME(REPLACE(OwnerAddress,',','.'),3)) AS OwnerAdr ,
		LTRIM(PARSENAME(REPLACE(OwnerAddress,',','.'),2)) as OwnerCity,
		LTRIM(PARSENAME(REPLACE(OwnerAddress,',','.'),1)) as OwnerState
FROM PortfolioProject..NashvilleHousing
)
select *
from cte
where OwnerState is not null


ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerAdr Nvarchar(255)

update PortfolioProject..NashvilleHousing
SET OwnerAdr = LTRIM(PARSENAME(REPLACE(OwnerAddress,',','.'),3))

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerCity Nvarchar(255)

update PortfolioProject..NashvilleHousing
SET OwnerCity = LTRIM(PARSENAME(REPLACE(OwnerAddress,',','.'),2))


ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerState Nvarchar(255)

update PortfolioProject..NashvilleHousing
SET OwnerState = LTRIM(PARSENAME(REPLACE(OwnerAddress,',','.'),1))

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress

------------------------------------------------------------------------------------------

SELECT distinct SoldAsVacant, COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant
	 END

------------------------------------------------------------------------

SELECT *
FROM PortfolioProject..NashvilleHousing

WITH rn_cte as (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropAddress,
				 PropCity,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY UniqueID
				 ) Rn
FROM PortfolioProject..NashvilleHousing
)
DELETE
FROM rn_cte
WHERE Rn > 1

--------------------------------------------------------------------------------------------------------------

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN TaxDistrict

SELECT *
FROM PortfolioProject..NashvilleHousing