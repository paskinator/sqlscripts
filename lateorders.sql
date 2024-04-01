
  select 
   DATEFROMPARTS(year(orderdate),MONTH(orderdate),day(orderdate)) as shortstartdate
  ,EOMONTH(DATEFROMPARTS(year(orderdate),MONTH(orderdate),day(orderdate))) as eomonthmonth
  ,DATEFROMPARTS(year(shipdate),MONTH(shipdate),day(shipdate)) as shortenddate
  ,DATEFROMPARTS(year(shipdate),MONTH(shipdate),day(shipdate)) as shorterenddate
  ,month(orderdate) as startmonthnum
  ,month(shipdate) as endmonthnum
  ,[RevisionNumber]
  ,[Status]
  ,[EmployeeID]
  ,[VendorID]
  ,[ShipMethodID]
  ,[SubTotal]
  ,[TaxAmt]
  ,[Freight]
  ,[TotalDue]
  into #temporderdates
  from [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader];

  select 
  *
  ,"lateorder" = case when shortstartdate = eomonthmonth  then 1 else 0 end
  ,"signeddiffmonth" = case when startmonthnum != endmonthnum then 1 else 0 end
  into #lateorders
  from #temporderdates;

  select 
  *
  , "flag_as_late_order" = case when lateorder = 1 and signeddiffmonth = 1 then 1 else 0 end
  from #lateorders
  order by flag_as_late_order desc;


  drop table #temporderdates;
  go
  drop table #lateorders ;
  go
