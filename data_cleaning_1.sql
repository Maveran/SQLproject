/*cleaning data





*/

SELECT * FROM PortfolioProject1.dbo.NashvilleHousing

-- Standardizing Date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject1.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populating Property Address Data

	--looking at nulls
SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
order by ParcelID




SELECT a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject1.dbo.NashvilleHousing A
JOIN PortfolioProject1.dbo.NashvilleHousing B
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET	PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject1.dbo.NashvilleHousing A
JOIN PortfolioProject1.dbo.NashvilleHousing B
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]


	--breaking Address into individual columns

SELECT PropertyAddress
FROM PortfolioProject1.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
order by ParcelID


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))  AS Address

FROM PortfolioProject1.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

SELECT * 
FROM PortfolioProject1.dbo.NashvilleHousing



SELECT OwnerAddress
FROM PortfolioProject1.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,
PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM PortfolioProject1.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT * FROM
PortfolioProject1.dbo.NashvilleHousing

SELECT DISTINCT(SOLDASVACANT), COUNT(SOLDASVACANT)
FROM
PortfolioProject1.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


SELECT SoldAsVacant,
CASE WHEN Soldasvacant = 'Y' THEN 'Yes'
WHEN Soldasvacant = 'N' THEN 'No'
ELSE Soldasvacant
END
FROM
PortfolioProject1.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN Soldasvacant = 'Y' THEN 'Yes'
WHEN Soldasvacant = 'N' THEN 'No'
ELSE Soldasvacant
END


--Removing Duplicates


WITH RowNumCTE AS(
SELECT *,

	ROW_NUMBER() OVER (
	PARTITION BY	ParcelID,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID
						)	row_num
					

FROM PortfolioProject1.dbo.NashvilleHousing
--ORDER BY ParcelID
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress

SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing

--Deleting obsolete columns

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN SaleDate


SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing
