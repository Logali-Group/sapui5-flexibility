namespace com.logaligroup;

using {
    cuid,
    managed,
    sap.common.CodeList
} from '@sap/cds/common';


entity Employees : cuid, managed {
    // Grupo de campos: Información Personal
    FirstName   : String(40) not null;
    LastName    : String(40) not null;
    FullName    : String(80);
    BirthDate   : Date not null;
    Image       : LargeString          @UI.IsImageURL;
    Photo       : LargeBinary          @Core.MediaType: ImageType  @UI.IsImage;
    ImageType   : String default 'png' @Core.IsMediaType;
    // Grupo de campos: Información Organizacional
    Title       : Association to Titles;
    Department  : Association to Departments;
    HireDate    : Date;
    CostCenter  : String(10);
    Status      : Association to Status;
    //Grupo de campos: Información de contactos
    Email       : String(100);
    HomePhone   : String(24);
    MobilePhone : String(24);
    Extension   : String(4);
    //Grupo de campos: Dirección
    Country     : Association to Countries;
    Region      : Association to Regions;
    City        : Association to Cities;
    Address     : String(40);
    PostalCode  : String(6);
    ToOrders    : Composition of many Orders
                      on ToOrders.Employee = $self;
};

entity Orders : cuid {
    OrderID        : Integer;
    CustomerID     : String(10);
    OrderDate      : Date;
    RequiredDate   : Date;
    ShippedDate    : Date;
    ShipVia        : Integer;
    Freight        : Decimal(10, 2);
    ShipName       : String(100);
    ShipAddress    : String(100);
    ShipCity       : String(50);
    ShipRegion     : String(50);
    ShipPostalCode : String(10);
    ShipCountry    : String(50);
    Employee       : Association to Employees;
};

/** Value Helps */

entity Countries : cuid {
    Code      : String(2);
    Country   : String(80);
    Flag      : LargeString @UI.IsImageURL;
    ToRegions : Composition of many Regions
                    on ToRegions.Country = $self;
};


entity Regions : cuid {
    Region   : String(80);
    Country  : Association to Countries;
    ToCities : Composition of many Cities
                   on ToCities.Region = $self;
};


entity Cities : cuid {
    City   : String(80);
    Region : Association to Regions;
};

entity Departments : cuid {
    Department : String(80);
};


entity Titles : cuid {
    Title : String(80);
};

entity Status : CodeList {
    key Code        : String enum {
            Active = 'Activo';
            Inactive = 'Inactivo';
            OnLeave = 'De Permiso';
        };
        Criticality : Integer;
};
