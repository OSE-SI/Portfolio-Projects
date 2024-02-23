select SaleDateConverted
from NashvilleHousing


--standardize date format

select saledate, CONVERT(date,saledate)
from NashvilleHousing

Update NashvilleHousing
SET Saledate = CONVERT(Date, Saledate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, Saledate)

--populate property address data

select *
from PortfolioProject..NashvilleHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


--breaking out Adress into Individual columns(Address, city, state)

select PropertyAddress
from PortfolioProject..NashvilleHousing
--order by ParcelID

select 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

 from PortfolioProject..NashvilleHousing

 ALTER TABLE Portfolioproject..NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update Portfolioproject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE Portfolioproject..NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update Portfolioproject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) 

select *
from PortfolioProject..NashvilleHousing

select owneraddress
from PortfolioProject..NashvilleHousing



--easier version of splitting address columns

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from PortfolioProject..NashvilleHousing

 ALTER TABLE Portfolioproject..NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update Portfolioproject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


 ALTER TABLE Portfolioproject..NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update Portfolioproject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


 ALTER TABLE Portfolioproject..NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update Portfolioproject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) 


--change y and n to yes and no in 'sold as vacant' field

select SoldAsVacant
 , CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
        WHEN SoldAsVacant = 'N' THEN 'NO'
	    Else SoldAsVacant
		END
from PortfolioProject..NashvilleHousing
 
Update PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
    WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END

select SoldAsVacant 
from PortfolioProject..NashvilleHousing


--remove Duplicates

WITH RowNumCTE AS(
select *,
   ROW_NUMBER() OVER( 
   Partition BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				  UniqueID
				  ) row_num

from PortfolioProject..NashvilleHousing
--Order by ParcelID
)
Delete
from RowNumCTE
where row_num  > 1
--order by PropertyAddress



--check if duplicates have been removed


WITH RowNumCTE AS(
select *,
   ROW_NUMBER() OVER( 
   Partition BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				  UniqueID
				  ) row_num

from PortfolioProject..NashvilleHousing
--Order by ParcelID
)
select*
from RowNumCTE
where row_num  > 1
order by PropertyAddress


--delete unused columns

select *
from PortfolioProject..NashvilleHousing

ALTER TABLE  PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

