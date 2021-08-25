--Data cleaning in SQL Queries
SELECT *
FROM PortfolioProject.dbo.NashvilleHousingData



--Standardize the Date format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousingData

UPDATE NashvilleHousingData
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousingData
Add SaleDateConverted Date;

UPDATE NashvilleHousingData
SET SaleDateConverted = CONVERT(Date, SaleDate)



--Populate property address

SELECT *
FROM PortfolioProject.dbo.NashvilleHousingData
--WHERE PropertyAddress IS NULL
order by ParcelID


SELECT a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousingData AS a
JOIN PortfolioProject.dbo.NashvilleHousingData AS b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousingData AS a
JOIN PortfolioProject.dbo.NashvilleHousingData AS b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL



--Breaking out Address into individual columns (Address, City and State)


SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousingData
--WHERE PropertyAddress IS NULL
--order by ParcelID

--To separate the city name in the address into a new column and take out the comma
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

FROM PortfolioProject.dbo.NashvilleHousingData


ALTER TABLE NashvilleHousingData
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousingData
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


SELECT *
FROM PortfolioProject.dbo.NashvilleHousingData



SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousingData


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

FROM PortfolioProject.dbo.NashvilleHousingData


ALTER TABLE NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousingData
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousingData
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT *
FROM PortfolioProject.dbo.NashvilleHousingData



-- Change N or Y to Yes or No in "SoldAsVacant"

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousingData
Group by SoldAsVacant
Order by 2



SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant 
	   END
FROM PortfolioProject.dbo.NashvilleHousingData

UPDATE NashvilleHousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END





-- Remove duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER By
					UniqueID
					) Row_num

FROM PortfolioProject.dbo.NashvilleHousingData
-- ORDER BY ParcelID
)
SELECT * 
FROM RowNumCTE
WHERE Row_num > 1
Order by PropertyAddress


-- Delete unused columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousingData


ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
DROP COLUMN SaleDate















