SELECT *
FROM NashvilleHousingData..Housing


SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM NashvilleHousingData..Housing




ALTER TABLE NashvilleHousingData..Housing
Add SaleDateConverted Date;

UPDATE Housing
SET SaleDateConverted = CONVERT(Date, SaleDate)

ALTER TABLE Housing
DROP COLUMN SaleDate;

SELECT *
FROM Housing
WHERE PropertyAddress is NULL

SELECT a.ParcelID, a.PropertyAddress ,  b.ParcelID, b.PropertyAddress
FROM NashvilleHousingData..Housing a
JOIN NashvilleHousingData..Housing b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 WHERE a.PropertyAddress IS NULL


 SELECT a.ParcelID, a.PropertyAddress ,  b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousingData..Housing a
JOIN NashvilleHousingData..Housing b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 WHERE a.PropertyAddress IS NULL

 -- must use alias while updating with JOIN statement
 UPDATE a
 SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM NashvilleHousingData..Housing a
JOIN NashvilleHousingData..Housing b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 WHERE a.PropertyAddress IS NULL

 SELECT propertyaddress
 FROM Housing


 -- CHARINDEX searches for that comma in PropertyAddress and then goes a index back in -1 and one forward in +1. 
 --The LEN() specifies till where should SUBSTRING search, the search ending point

 SELECT 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS ADDRESS,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS PLACE
 FROM Housing

 ALTER TABLE NashvilleHousingData..Housing
Add PropertyStreetAddress nvarchar(111);

UPDATE Housing
SET PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousingData..Housing
Add PropertyCityAddress nvarchar(111);

UPDATE Housing
SET PropertyCityAddress =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT * FROM Housing

-- using PARSENAME to do the above thing diffferently.
-- So, PARSENAME always looks for period and we have comma in here, so we need to replace it
-- ALso, PARSENAME works backwards, i.e. 1 means the last substring

SELECT OwnerAddress,
PARSENAME(REPLACE(Owneraddress,',','.'),1),
PARSENAME(REPLACE(Owneraddress,',','.'),2),
PARSENAME(REPLACE(Owneraddress,',','.'),3)
FROM NashvilleHousingData..Housing




ALTER TABLE NashvilleHousingData..Housing
Add OwnerStreetAddress nvarchar(111);

UPDATE Housing
SET OwnerStreetAddress = PARSENAME(REPLACE(Owneraddress,',','.'),3)



ALTER TABLE NashvilleHousingData..Housing
Add OwnerCityAddress nvarchar(111);

UPDATE Housing
SET OwnerCityAddress = PARSENAME(REPLACE(Owneraddress,',','.'),2)



ALTER TABLE NashvilleHousingData..Housing
Add OwnerStateAddress nvarchar(111);

UPDATE Housing
SET OwnerStateAddress = PARSENAME(REPLACE(Owneraddress,',','.'),1)

SELECT * FROM Housing


SELECT SoldAsVacant, COUNT(SoldASVacant)
FROM Housing
Group by SoldAsVacant
ORDER BY 2




SELECT SoldAsVacant,
CASE When SoldAsVacant = 'Y' Then 'Yes'
     WHen SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant
END
FROM Housing


UPDATE Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
    WHen SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END
FROM Housing


-- Remove duplicates and removing unused columns
-- Best Practice to store duplicates into a temp table rather than deleting it completely


SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY ParcelID,PropertyAddress, SalePrice, SaleDateConverted, LegalReference
ORDER BY UniqueID) row_num
FROM housing


WITH RownumCTE AS(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY ParcelID,PropertyAddress, SalePrice, SaleDateConverted, LegalReference
ORDER BY UniqueID) row_num
FROM NashvilleHousingData..Housing )

SELECT * FROM RowNumCTE

-- the SELECT * statement at the end must be inlcuded after CTE



WITH RownumCTE AS(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY ParcelID,PropertyAddress, SalePrice, SaleDateConverted, LegalReference
ORDER BY UniqueID) row_num
FROM NashvilleHousingData..Housing )

SELECT *
FROM RowNumCTE
WHERE row_num > 1




ALTER TABLE Housing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict


SELECT * FROM Housing